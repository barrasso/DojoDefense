//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
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
}

@end
