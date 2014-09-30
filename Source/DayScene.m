//
//  DayScene.m
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DayScene.h"

@implementation DayScene

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // Load Day Number
    self.dayNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DayNumber"] intValue];
    
    // Set Day # Label
    self.dayLabel.string = [NSString stringWithFormat:@"DAY %i",self.dayNumber];
}

- (void)onExit
{
    // Deallocate
    [super onExit];
}

#pragma mark - Callbacks

- (void)loadGameplay
{
    // Load Gameplay Scene
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
