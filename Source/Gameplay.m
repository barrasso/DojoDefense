//
//  Gameplay.m
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "FootNinja.h"

@implementation Gameplay
{
    // Multi grab
    ChipmunkMultiGrab *_grab;
    
    // Physics Node
    CCPhysicsNode *_physicsNode;
    
    // Tower Node
    CCNode *_tower;
    
    // Floor Node
    CCNode *_floor;
    
    // User grabbing flag
    BOOL isUserGrabbing;
    
    // Screen Size
    CGSize screenSize;
    
    // Touch Coordinates
    CGPoint touchLocation;
    
    // Init speed constant
    CGFloat daySpeedConstant;
    
    // Enemy arrays
    NSMutableArray *_allNinjas;
    
    // Blood explosion array
    NSMutableArray *_allBloodEffects;
}

#pragma mark - Initialization

- (id)init
{
    if ((self = [super init]))
    {
        // Enable touches
        self.userInteractionEnabled = YES;
        
        // Enable multi touch
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)onEnter
{
    [super onEnter];
    
    // Init grab variable
    _grab = [[ChipmunkMultiGrab alloc] initForSpace:_physicsNode.space withSmoothing:powf(0.1f, 10.0f) withGrabForce:1e4];
    
    // Enable to debug physics
    //_physicsNode.debugDraw = YES;
    
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
    
    // Get dojo health from NSUser Defaults
    self.dojoHealth = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DojoHealth"] intValue];
    
    // Get dojo zen from NSUser Defaults
    self.dojoZen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DojoZen"] intValue];
}

- (void)onExit
{
    // Deallocate
    [super onExit];
}

#pragma mark - Update method

- (void)update:(CCTime)delta
{
    // CCLOG(@"TouchLocation: %f, %f",touchLocation.x,touchLocation.y);
    
    /* CHECK NINJA ARRAY FOR CASES */
    for (FootNinja *footNinja in _allNinjas)
    {
        /* CHECKING NINJA POSITIONS */
        
        // If the ninjas position is above the ground
        if (footNinja.position.y > (screenSize.height * 0.21f))
            // Set ground flag to false
            footNinja.isNinjaOnGround = NO;
        
        // If the ninjas position has passed the dojo
        if ((footNinja.position.x > (screenSize.width * 0.69f)) && (footNinja.position.y < (screenSize.height * .24f)))
            // Set ninjas position to be in front of dojo
            footNinja.position = ccp(screenSize.width * 0.66f, screenSize.height * 0.20f);
        
        
        /* CHECKING NINJA VELOCITY */
        
        // If the user is not touching the ninja, and the user isn't grabbing, and the ninja is on the ground
        if (!(CGRectContainsPoint(footNinja.boundingBox, touchLocation)) && !isUserGrabbing && footNinja.isNinjaOnGround)
            // Apply constant velocity to ninja
            footNinja.physicsBody.velocity = ccp((footNinja.constantVelocity.x * daySpeedConstant), footNinja.physicsBody.velocity.y);
        
        // If the ninja is on the floor and velocity < 0
        if ((footNinja.position.y < (screenSize.height * .24f))&& (footNinja.physicsBody.velocity.x < 0) && (footNinja.position.x < (screenSize.width * 0.6f)))
            // Apply constant velocity to ninja
            footNinja.physicsBody.velocity = ccp((footNinja.constantVelocity.x * daySpeedConstant), footNinja.physicsBody.velocity.y);
    }
}

#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Get user touch location
    touchLocation = [touch locationInNode:self];
    
    // Get the beginning location of the grab
    [_grab beginLocation:[touch locationInNode:self]];
    
    // Set user grabbing bool to yes
    isUserGrabbing = YES;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Update the location of the grab
    [_grab updateLocation:[touch locationInNode:self]];
    
    // Set user grabbing bool to yes
    isUserGrabbing = YES;
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Get the ending location of the grab
    [_grab endLocation:[touch locationInNode:self]];
    
    // Set user grabbing bool to no
    isUserGrabbing = NO;
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Call the touch ended event
    [self touchEnded:touch withEvent:event];
    
    // Set user grabbing bool to no
    isUserGrabbing = NO;
}

#pragma mark - Enemy Methods

- (void)spawnNewNinja
{
    // Load Foot Ninja
    FootNinja *footNinja = (FootNinja *)[CCBReader load:@"FootNinja"];
    
    // Set ninja position
    footNinja.position = ccp((screenSize.width * .01f), (screenSize.height * .20f));
    
    // Add footninja to physics node
    [_physicsNode addChild:footNinja];
    
    // Add footninja to allNinjas array
    [_allNinjas addObject:footNinja];
}

#pragma mark - Animation Event Methods

- (void)killFootNinja:(CCNode *)footNinja
{
    // Load the bloody effect
    CCNode *bloodExplosion = (CCNode *)[CCBReader load:@"BloodyExplosion"];
    
    // Place bloody effect on enemy's position
    bloodExplosion.positionInPoints = footNinja.positionInPoints;
    
    // Add bloody effect to same parent as enemy
    [footNinja.parent addChild:bloodExplosion];
    
    // Add blood effect to bloodeffect array
    [_allBloodEffects addObject:bloodExplosion];
    
    // Remove footninja
    [footNinja removeFromParent];
}

- (void)clearBloodEffects
{
    // Clear blood effect array
    [_allBloodEffects removeAllObjects];
}

#pragma mark - Collision Methods

// Collision between FOOTNINJA and TOWER
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair footninja:(CCNode *)nodeA tower:(CCNode *)nodeB
{
    // Get kinetic energy of collision
    CCLOG(@"Ninja Position: (%f, %f)", nodeA.position.x, nodeA.position.y);
}

// Collision between FOOTNINJA and FLOOR
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair footninja:(CCNode *)nodeA floor:(CCNode *)nodeB
{
    // Get kinetic energy of collision
    float kineticEnergy = [pair totalKineticEnergy];
    
    // If the kinetic energy is high enough, load ninjas death
    if (kineticEnergy > 400000.f)
    {
        // Load ninja deaths
        [self killFootNinja:nodeA];
        
        // Remove the bloody explosion
        [self clearBloodEffects];
    }
    
    // Loop through the ninjas array
    for (FootNinja *footNinja in _allNinjas)
    {
        // Set touching ground flag to true
        footNinja.isNinjaOnGround = YES;
    }
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
            
            // Set the Dojo Health to 100
            [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"DojoHealth"];
            
            // Set the Dojo Zen
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"DojoZen"];
            
            // Spawn new ninja every 4 - 6 seconds
            [self schedule:@selector(spawnNewNinja) interval:(arc4random() % 3) + 4];
            
            break;
            
        // Day 2
        case 2:
            // Day 2 Speed Constant
            daySpeedConstant = 1.05f;
            
            break;
            
        // Day 3
        case 3:
            // Day 3 Speed Constant
            daySpeedConstant = 1.1f;
            
            break;
            
        default:
            break;
    }
}

@end
