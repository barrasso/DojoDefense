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
static const CGFloat firstNinjasXPosition = -75.f;

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
    
    // Touch Coordinates
    CGPoint touchLocation;
    
    // Init speed constant
    CGFloat daySpeedConstant;
    
    // Enemy arrays
    NSMutableArray *_allNinjas;
}

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // Enable to debug physics
    //_physicsNode.debugDraw = YES;
    
    // Enable touches
    self.userInteractionEnabled = YES;
    
    // Set collision delegate
    _physicsNode.collisionDelegate = self;
    
    // Get device screen size
    screenSize = [[CCDirector sharedDirector] viewSize];
    
    // Set contentsize to normalized
    self.contentSizeType = CCSizeTypeNormalized;
    
    // Set collision types
    _tower.physicsBody.collisionType = @"tower";
    _floor.physicsBody.collisionType = @"floor";
    
    // Init enemy arrays
    _allNinjas = [[NSMutableArray alloc] init];
    
    // Get day number from NSUser Defaults
    self.dayNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DayNumber"] intValue];
    
    // Load game mechanics based on day number
    [self loadGameMechanics];
}

- (void)onExit
{
    // Deallocate
    [super onExit];
}

#pragma mark - Update method
- (void)update:(CCTime)delta
{
    
}

#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Get user touch location
    touchLocation = [touch locationInNode:self];
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
    
    // Apply velocity to ninja
    footNinja.physicsBody.velocity = ccp(40.f*daySpeedConstant, 0.f);
    
    // Add footninja to physics node
    [_physicsNode addChild:footNinja];
    
    // Add footninja to allNinjas array
    [_allNinjas addObject:footNinja];
}

#pragma mark - Collision Methods

// Collision between FOOTNINJA and TOWER
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair footninja:(CCNode *)nodeA tower:(CCNode *)nodeB
{
    // Get kinetic energy of collision
   // float kineticEnergy = [pair totalKineticEnergy];
}

#pragma mark - Helper Methods

- (void)loadGameMechanics
{
    // Figure out speed constant and enemy type based on day number
    switch (self.dayNumber)
    {
        // Day 1
        case 1:
            // Day 1 Speed Constant
            daySpeedConstant = 1.0f;
            
            // Spawn new ninja
            [self spawnNewNinja];
            
            // End Case
            break;
        // Day 2
        case 2:
            // Day 2 Speed Constant
            daySpeedConstant = 1.05f;
            
            // End Case
            break;
        // Day 3
        case 3:
            // Day 3 Speed Constant
            daySpeedConstant = 1.1f;
            
            // End Case
            break;
        // Default
        default:
            // Default to 100%
            daySpeedConstant = 1.0f;
            
            // End case
            break;
    }
}

@end
