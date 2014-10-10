//
//  FootNinja.h
//  DojoDefense
//
//  Created by Mark on 9/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface FootNinja : CCNode

// Foot Ninja constant velocity
@property (assign) CGPoint constantVelocity;

// Grabbing boolean
@property (assign) BOOL isNinjaOnGround;

// Did Load Method
- (void)didLoadFromCCB;

@end
