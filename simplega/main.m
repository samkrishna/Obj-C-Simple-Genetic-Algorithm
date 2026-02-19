//
//  main.m
//  simplega
//
//  Created by Sam Krishna on 2026-02-18.
//  Copyright © 2026 iJoshSmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JASGeneticAlgo.h"

static void printUsage(const char *programName) {
    fprintf(stderr, "Usage: %s [options] <target-string>\n", programName);
    fprintf(stderr, "\nRuns a genetic algorithm to evolve a random population toward the target string.\n");
    fprintf(stderr, "\nOptions:\n");
    fprintf(stderr, "  -q, --quiet     Suppress per-generation log output\n");
    fprintf(stderr, "  -v, --verbose   Show fittest chromosome each generation (default)\n");
    fprintf(stderr, "  -h, --help      Show this help message\n");
    fprintf(stderr, "\nExamples:\n");
    fprintf(stderr, "  %s \"Hello World\"\n", programName);
    fprintf(stderr, "  %s -q \"Genetic Algorithm\"\n", programName);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray<NSString *> *args = [NSMutableArray array];
        BOOL quiet = NO;

        for (int i = 1; i < argc; i++) {
            NSString *arg = [NSString stringWithUTF8String:argv[i]];

            if ([arg isEqualToString:@"-h"] || [arg isEqualToString:@"--help"]) {
                printUsage(argv[0]);
                return EXIT_SUCCESS;
            }
            else if ([arg isEqualToString:@"-q"] || [arg isEqualToString:@"--quiet"]) {
                quiet = YES;
            }
            else if ([arg isEqualToString:@"-v"] || [arg isEqualToString:@"--verbose"]) {
                quiet = NO;
            }
            else {
                [args addObject:arg];
            }
        }

        if (args.count == 0) {
            fprintf(stderr, "Error: No target string provided.\n\n");
            printUsage(argv[0]);
            return EXIT_FAILURE;
        }

        NSString *targetString = [args componentsJoinedByString:@" "];

        if (quiet) {
            // Redirect stderr to /dev/null to suppress NSLog output
            freopen("/dev/null", "w", stderr);
        }

        fprintf(stdout, "Target: %s\n", [targetString UTF8String]);
        fprintf(stdout, "Running genetic algorithm...\n");

        NSDate *start = [NSDate date];
        JASGeneticAlgo *algo = [[JASGeneticAlgo alloc] initWithTargetSequence:targetString];
        [algo execute];
        NSTimeInterval runtime = [start timeIntervalSinceNow] * -1;

        // Restore stderr if it was redirected
        if (quiet) {
            freopen("/dev/tty", "w", stderr);
        }

        if (algo.result) {
            fprintf(stdout, "\nOutput Sequence: %s\n", [algo.result UTF8String]);
            fprintf(stdout, "Elapsed Generations: %ld\n", (long)algo.generations);
            fprintf(stdout, "Duration: %.2f seconds\n", runtime);
        }
        else {
            fprintf(stdout, "\nFailed to match target within maximum generations.\n");
            fprintf(stdout, "Elapsed Generations: %ld\n", (long)algo.generations);
            fprintf(stdout, "Duration: %.2f seconds\n", runtime);
            return EXIT_FAILURE;
        }
    }
    return EXIT_SUCCESS;
}
