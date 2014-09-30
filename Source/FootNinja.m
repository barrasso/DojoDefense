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
}

@end
