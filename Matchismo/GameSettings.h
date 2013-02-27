//
//  GameSettings.h
//  Matchismo
//
//  Created by Martin Mandl on 17.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;
@property (nonatomic) int numberPlayingCards;

@end
