//
//  DayScene.h
//  DojoDefense
//
//  Created by Mark on 9/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface DayScene : CCNode

// Day Label
@property (strong, nonatomic) CCLabelTTF *dayLabel;

// Day Number
@property (assign, nonatomic) int dayNumber;

@end
