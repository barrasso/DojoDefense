//
//  Gameplay.m
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "FootNinja.h"

// First Ninja's X Position
static const CGFloat firstNinjasXPosition = -50.f;

// Distance between Ninjas
static const CGFloat distanceBetweenNinjas = 20.f;

@implementation Gameplay
{
    // Physics Node
    CCPhysicsNode *_physicsNode;
    
    // Tower Node
    CCNode *_tower;
    
    // Floor Node
    CCNode *_floor;
    
    // Screen Size
    CGSize screenSize;
    
    // Enemy arrays
    NSMutableArray *_allNinjas;
}

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // debug physics
    _physicsNode.debugDraw = YES;
    
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Set collision delegate
    _physicsNode.collisionDelegate = self;
    
    // Get device screen size
    screenSize = [[CCDirector sharedDirector] viewSize];
    
    // Set contentsize to normalized
    self.contentSizeType = CCSizeTypeNormalized;
    
    // Get day number from NSUser Defaults
    self.dayNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DayNumber"] intValue];
    
    // Set collision types
    self.physicsBody.collisionType = @"tower";
    self.physicsBody.collisionType = @"floor";
    self.physicsBody.collisionType = @"footninja";
    
    // Init enemy arrays
    _allNinjas = [[NSMutableArray alloc] init];
    
    // Spawn new ninja
    [self spawnNewNinja];
}

- (void)onExit
{
    // Deallocate
    [super onExit];
}

#pragma mark - Enemy Methods

- (void)spawnNewNinja
{
    // Base new ninja position on previous
    CCNode *previousNinja = [_allNinjas lastObject];
    
    // Get previous ninjas x position
    CGFloat previousNinjasXPosition = previousNinja.position.x;
    
    // If previous ninja is nil
    if (!previousNinja)
        // Then this is the first ninja
        previousNinjasXPosition = firstNinjasXPosition;
    
    // Load Foot Ninja
    FootNinja *footNinja = (FootNinja *)[CCBReader load:@"FootNinja"];
    
    // Set ninja position
    footNinja.position = ccp(previousNinjasXPosition + distanceBetweenNinjas, (screenSize.height * .20f));
    
    // Apply for to ninja
    [footNinja.physicsBody applyForce:ccp(2000.f, 0)];
    
    // Add footninja to physics node
    [_physicsNode addChild:footNinja];
    
    // Add footninja to allNinjas array
    [_allNinjas addObject:footNinja];
}

@end
