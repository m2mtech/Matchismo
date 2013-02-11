//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Martin Mandl on 09.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *descriptionOfLastFlip;

@property (strong, nonatomic) NSMutableArray *cards; // of Card

@end

@implementation CardMatchingGame

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (int)numberOfMatchingCards
{
    if (!_numberOfMatchingCards) {
        _numberOfMatchingCards = 2;
    }
    return _numberOfMatchingCards;
}

- (void)setNumberOfMatchingCards:(int)numberOfMatchingCards
{
    if (numberOfMatchingCards < 2) _numberOfMatchingCards = 2;
    else if (numberOfMatchingCards > 3) _numberOfMatchingCards = 3;
    else _numberOfMatchingCards = numberOfMatchingCards;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }            
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count] ? self.cards[index] : nil);
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                    [otherContents addObject:otherCard.contents];
                }
            }
            if ([otherCards count] < self.numberOfMatchingCards - 1) {
                self.descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            } else {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                        
                    }
                    self.score += matchScore * MATCH_BONUS;              
                    self.descriptionOfLastFlip =
                        [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                         card.contents,
                         [otherContents componentsJoinedByString:@" & "],
                         matchScore * MATCH_BONUS];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }                    
                    self.score -= MISMATCH_PENALTY;
                    self.descriptionOfLastFlip =
                        [NSString stringWithFormat:@"%@ & %@ don’t match! %d point penalty!",
                         card.contents,
                         [otherContents componentsJoinedByString:@" & "],
                         MISMATCH_PENALTY];
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
}

@end
