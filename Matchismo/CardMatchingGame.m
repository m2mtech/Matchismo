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

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
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
            self.descriptionOfLastFlip = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                                                      card.contents, otherCard.contents,
                                                      matchScore * MATCH_BONUS];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.descriptionOfLastFlip = [NSString stringWithFormat:@"%@ and %@ don’t match! %d point penalty!",
                                                      card.contents, otherCard.contents,
                                                      MISMATCH_PENALTY];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;            
        }
        card.faceUp = !card.faceUp;
    }
}

@end
