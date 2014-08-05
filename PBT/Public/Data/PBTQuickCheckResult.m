#import "PBTQuickCheckResult.h"

@implementation PBTQuickCheckResult

- (NSString *)description
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%@: ",
                               NSStringFromClass([self class])];
    [string appendString:(self.succeeded ? @"passed" : @"FAILED")];
    [string appendFormat:@"\n seed: %u", self.seed];
    [string appendFormat:@"\n maxSize: %lu", (unsigned long)self.maxSize];
    [string appendFormat:@"\n numberOfTests: %lu", (unsigned long)self.numberOfTests];

    if (!self.succeeded) {
        [string appendFormat:@"\n failingSize: %lu", (unsigned long)self.failingSize];
        [string appendFormat:@"\n failingArguments: %@", self.failingArguments];
        [string appendFormat:@"\n   smallestFailingArguments: %@", self.smallestFailingArguments];
        [string appendFormat:@"\n   shrinkDepth: %lu", (unsigned long)self.shrinkDepth];
        [string appendFormat:@"\n   shrinkNodeWalkCount: %lu", (unsigned long)self.shrinkNodeWalkCount];
    }

    [string appendString:@">"];

    return string;
}

- (NSString *)friendlyDescription
{
    NSMutableString *string = [NSMutableString stringWithString:@"RESULT: "];
    [string appendString:(self.succeeded ? @"passed" : @"FAILED")];
    [string appendFormat:@"\n seed: %u", self.seed];
    [string appendFormat:@"\n maximum size: %lu", (unsigned long)self.maxSize];
    [string appendFormat:@"\n number of tests until failure: %lu", (unsigned long)self.numberOfTests];

    if (!self.succeeded) {
        [string appendFormat:@"\n size that failed: %lu", (unsigned long)self.failingSize];
        [string appendFormat:@"\n value that failed: %@", self.failingArguments];
        [string appendFormat:@"\n smallest failing value: %@", self.smallestFailingArguments];
        [string appendFormat:@"\n shrink depth: %lu", (unsigned long)self.shrinkDepth];
        [string appendFormat:@"\n shrink nodes walked: %lu", (unsigned long)self.shrinkNodeWalkCount];
    }
    return string;
}

@end