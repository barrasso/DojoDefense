//
//  Gameplay.h
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

// Day Number
@property (assign, nonatomic) int dayNumber;

// Dojo Health
@property (assign, nonatomic) int dojoHealth;

@end
