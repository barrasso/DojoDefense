//
//  FootNinja.m
//  DojoDefense
//
//  Created by Mark on 9/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FootNinja.h"

@implementation FootNinja

#pragma mark - Lifecycle

- (void)didLoadFromCCB
{
    // Set collision type
    self.physicsBody.collisionType = @"footninja";
    
    // Set collision group
    self.physicsBody.collisionGroup = @"enemy";
    
    // Set constant velocity
    self.constantVelocity = ccp(30.f, 0.f);
}

@end
