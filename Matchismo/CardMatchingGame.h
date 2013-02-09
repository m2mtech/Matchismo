//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Martin Mandl on 09.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *descriptionOfLastFlip;

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;

@end
