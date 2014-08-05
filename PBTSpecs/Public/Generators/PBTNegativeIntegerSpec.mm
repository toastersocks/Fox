#import "PBT.h"
#import "PBTSpecHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(PBTNegativeIntegerSpec)

describe(@"PBTNegativeInteger", ^{
    context(@"unit test", ^{
        context(@"when the randomizer returns zero", ^{
            it(@"should return an number within the range generated", ^{
                PBTConstantRandom *random = [[PBTConstantRandom alloc] initWithValue:0];
                PBTRoseTree *tree = [PBTNegativeInteger() lazyTreeWithRandom:random maximumSize:0];
                tree should equal([PBTRoseTree treeFromArray:@[@0, @[]]]);
            });
        });

        context(@"when the randomizer returns -1", ^{
            it(@"should return an number within the range generated [0, 1]", ^{
                PBTConstantRandom *random = [[PBTConstantRandom alloc] initWithValue:1];
                PBTRoseTree *tree = [PBTNegativeInteger() lazyTreeWithRandom:random maximumSize:1];
                tree should equal([PBTRoseTree treeFromArray:@[@(-1), @[@[@0, @[]]]]]);
            });
        });

        context(@"when the randomizer returns -2", ^{
            it(@"should return an number within the range generated [0, 2]", ^{
                PBTConstantRandom *random = [[PBTConstantRandom alloc] initWithValue:2];
                PBTRoseTree *tree = [PBTNegativeInteger() lazyTreeWithRandom:random maximumSize:2];
                tree should equal([PBTRoseTree treeFromArray:@[@(-2), @[@[@0, @[]],
                                                                        @[@(-1), @[@[@0, @[]]]]]]]);
            });
        });
    });

    context(@"integration", ^{
        it(@"should only produce negative numbers", ^{
            PBTQuickCheckResult *result = [PBTSpecHelper resultForAll:PBTNegativeInteger() then:^BOOL(NSNumber *value) {
                return [value integerValue] <= 0;
            }];

            result.succeeded should be_truthy;
        });

        it(@"should shrink to zero", ^{
            PBTQuickCheckResult *result = [PBTSpecHelper shrunkResultForAll:PBTNegativeInteger()];

            result.succeeded should be_falsy;
            result.smallestFailingArguments should equal(@0);
        });
    });
});

SPEC_END