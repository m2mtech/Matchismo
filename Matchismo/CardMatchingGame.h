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

@property (nonatomic) int numberOfMatchingCards;

@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@property (nonatomic) int numberOfCards;

@property (nonatomic) BOOL deckIsEmpty;

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)drawNewCard;

@end
