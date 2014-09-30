//
//  Gameplay.m
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay
{
    // Physics Node
    CCPhysicsNode *_physicsNode;
    
    // Tower Node
    CCNode *_tower;
    
    // Floor Node
    CCNode *_floor;
}

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

@end
