//
//  MainScene.m
//  Dojo Defense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2013 Mark Barrasso. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // Enable touches
    self.userInteractionEnabled = YES;
}

- (void)onExit
{
    // Deallocate
    [super onExit];
}

#pragma mark - Selectors

- (void)newGameSelected
{
    // Start new game
    
    // Set the saved DayNumber to 1
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"DayNumber"];
    
    // Load into transition scene
    CCScene *loadDay = [CCBReader loadAsScene:@"DayScene"];
    [[CCDirector sharedDirector] replaceScene:loadDay];
}

@end
