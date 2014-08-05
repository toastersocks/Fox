#import "PBTQuickCheck.h"
#import "PBTRoseTree.h"
#import "PBTRandom.h"
#import "PBTSequence.h"
#import "PBTQuickCheckResult.h"
#import "PBTStandardReporter.h"


typedef struct _PBTShrinkReport {
    NSUInteger depth;
    NSUInteger numberOfNodesVisited;
    void *smallestArgument;
    void *smallestUncaughtException;
} PBTShrinkReport;


@interface PBTQuickCheck ()

@property (nonatomic) id<PBTRandom> random;
@property (nonatomic) id<PBTQuickCheckReporter> reporter;

@end


@implementation PBTQuickCheck

- (instancetype)init
{
    return [self initWithReporter:[[PBTStandardReporter alloc] initWithFile:stdout]];
}

- (instancetype)initWithReporter:(id<PBTQuickCheckReporter>)reporter
{
    return [self initWithReporter:reporter random:[[PBTRandom alloc] init]];
}

- (instancetype)initWithReporter:(id<PBTQuickCheckReporter>)reporter random:(id<PBTRandom>)random
{
    self = [super init];
    if (self) {
        self.random = random;
        self.reporter = reporter;
    }
    return self;
}

- (PBTQuickCheckResult *)checkWithNumberOfTests:(NSUInteger)totalNumberOfTests
                                       property:(id<PBTGenerator>)property
                                           seed:(uint32_t)seed
                                        maxSize:(NSUInteger)maxSize
{
    NSUInteger currentTestNumber = 0;
    [self.random setSeed:seed];
    [self.reporter checkerWillRunWithSeed:seed];

    while (true) {
        for (NSUInteger size = 0; size < maxSize; size++) {
            if (currentTestNumber == totalNumberOfTests) {
                return [self successfulReportWithNumberOfTests:totalNumberOfTests
                                                       maxSize:maxSize
                                                          seed:seed];
            }

            ++currentTestNumber;

            PBTRoseTree *tree = [property lazyTreeWithRandom:self.random maximumSize:size];
            PBTPropertyResult *result = tree.value;
            NSAssert([result isKindOfClass:[PBTPropertyResult class]],
                     @"Expected property generator to return PBTPropertyResult, got %@",
                     NSStringFromClass([result class]));


            [self.reporter checkerWillVerifyTestNumber:currentTestNumber
                                       withMaximumSize:size];

            if ([result hasFailedOrRaisedException]) {
                return [self failureReportWithNumberOfTests:currentTestNumber
                                            failureRoseTree:tree
                                                failingSize:size
                                                    maxSize:maxSize
                                                       seed:seed];
            } else {
                [self.reporter checkerDidPassTestNumber:totalNumberOfTests];
            }
        }
    }
}

- (PBTQuickCheckResult *)checkWithNumberOfTests:(NSUInteger)numberOfTests
                                       property:(id<PBTGenerator>)property
{
    return [self checkWithNumberOfTests:numberOfTests
                               property:property
                                   seed:(uint32_t)time(NULL)
                                maxSize:50];
}

- (PBTQuickCheckResult *)checkWithNumberOfTests:(NSUInteger)numberOfTests
                                         forAll:(id<PBTGenerator>)values
                                           then:(PBTPropertyStatus (^)(id generatedValue))then
{
    return [self checkWithNumberOfTests:numberOfTests
                               property:[PBTProperty forAll:values then:then]];
}


#pragma mark - Private

- (PBTQuickCheckResult *)successfulReportWithNumberOfTests:(NSUInteger)numberOfTests
                                                   maxSize:(NSUInteger)maxSize
                                                      seed:(uint32_t)seed
{
    PBTQuickCheckResult *result = [[PBTQuickCheckResult alloc] init];
    result.succeeded = YES;
    result.numberOfTests = numberOfTests;
    result.seed = seed;
    result.maxSize = maxSize;

    [self.reporter checkerDidPassNumberOfTests:numberOfTests
                                    withResult:result];
    return result;
}

- (PBTQuickCheckResult *)failureReportWithNumberOfTests:(NSUInteger)numberOfTests
                                        failureRoseTree:(PBTRoseTree *)failureRoseTree
                                            failingSize:(NSUInteger)failingSize
                                                maxSize:(NSUInteger)maxSize
                                                   seed:(uint32_t)seed
{
    [self.reporter checkerWillShrinkFailingTestNumber:numberOfTests
                             failedWithPropertyResult:failureRoseTree.value];
    PBTPropertyResult *propertyResult = failureRoseTree.value;
    PBTShrinkReport report = [self shrinkReportForRoseTree:failureRoseTree
                                             numberOfTests:numberOfTests];
    PBTQuickCheckResult *result = [[PBTQuickCheckResult alloc] init];
    result.numberOfTests = numberOfTests;
    result.seed = seed;
    result.maxSize = maxSize;
    result.failingSize = failingSize;
    result.failingArguments = propertyResult.generatedValue;
    result.failingException = propertyResult.uncaughtException;
    result.shrinkDepth = report.depth;
    result.shrinkNodeWalkCount = report.numberOfNodesVisited;
    result.smallestFailingArguments = CFBridgingRelease(report.smallestArgument);
    result.smallestFailingException = CFBridgingRelease(report.smallestUncaughtException);

    [self.reporter checkerDidFailTestNumber:numberOfTests
                                 withResult:result];

    return result;
}

- (PBTShrinkReport)shrinkReportForRoseTree:(PBTRoseTree *)failureRoseTree
                             numberOfTests:(NSUInteger)numberOfTests
{
    NSUInteger numberOfNodesVisited = 0;
    NSUInteger depth = 0;
    id<PBTSequence> shrinkChoices = failureRoseTree.children;
    PBTPropertyResult *currentSmallest = failureRoseTree.value;

    while ([shrinkChoices firstObject]) {
        PBTRoseTree *firstTree = [shrinkChoices firstObject];
        PBTPropertyResult *smallestCandidate = firstTree.value;
        if ([smallestCandidate hasFailedOrRaisedException]) {
            currentSmallest = smallestCandidate;

            if ([firstTree.children firstObject] && [firstTree.children firstObject]) {
                shrinkChoices = firstTree.children;
                ++depth;
            } else {
                shrinkChoices = [shrinkChoices remainingSequence];
            }
        } else {
            shrinkChoices = [shrinkChoices remainingSequence];
        }

        ++numberOfNodesVisited;
        [self.reporter checkerShrankFailingTestNumber:numberOfTests
                                   withPropertyResult:smallestCandidate];
    }

    return (PBTShrinkReport){
        .depth=depth,
        .numberOfNodesVisited=numberOfNodesVisited,
        .smallestArgument=(void *)CFBridgingRetain(currentSmallest.generatedValue),
        .smallestUncaughtException=(void *)CFBridgingRetain(currentSmallest.uncaughtException),
    };
}

@end