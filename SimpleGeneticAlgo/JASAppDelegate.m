//
//  JASAppDelegate.m
//  SimpleGeneticAlgo
//
//  Created by Joshua Smith on 4/3/12.
//  Copyright (c) 2012 iJoshSmith. All rights reserved.
//

#import "JASAppDelegate.h"
#import "JASGeneticAlgo.h"

@implementation JASAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)handleRunAlgorithmButton:(id)sender 
{
    [self.textView setString:@"Processing..."];
    [self performSelector:@selector(runAlgorithm) 
               withObject:nil 
               afterDelay:0.1];
}

- (void)runAlgorithm
{
    NSString *targetString = [self.textField stringValue];
    NSDate *start = [NSDate date];
    JASGeneticAlgo *algo = [[JASGeneticAlgo alloc] initWithTargetSequence:targetString];
    [algo execute];
    NSTimeInterval runtime = [start timeIntervalSinceNow] * -1;
    NSString *msg = [NSString stringWithFormat:@"Output Sequence: %@\nElapsed Generations: %ld\nDuration: %.2f seconds",
                     algo.result, 
                     (long)algo.generations, 
                     runtime];
    [self.textView setString:msg];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Force menu validation
    [[NSApp mainMenu] update];

    // Ensure all submenus have correct parent references
    [self validateMenuHierarchy:[NSApp mainMenu]];
}

- (void)validateMenuHierarchy:(NSMenu *)menu {
    if (!menu) return;

    for (NSMenuItem *item in menu.itemArray) {
        if (item.submenu) {
            item.submenu.supermenu = menu;
            [self validateMenuHierarchy:item.submenu];
        }
    }
}

@end
