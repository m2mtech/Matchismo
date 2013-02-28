//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Martin Mandl on 09.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

//@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *descriptionOfLastFlip;

@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, nonatomic) Deck *deck;

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

- (int)numberOfCards
{
    return [self.cards count];
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

- (BOOL)deckIsEmpty
{
    if (self.deck.numberOfCardsInDeck) return NO;
    return YES;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        _deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }            
        }
        _matchBonus = -1;
        _mismatchPenalty = -1;
        _flipCost = -1;
    }
    
    return self;
}

- (int)matchBonus
{
    if (_matchBonus < 0) _matchBonus = 4;
    return _matchBonus;
}

- (int)mismatchPenalty
{
    if (_mismatchPenalty < 0) _mismatchPenalty = 2;
    return _mismatchPenalty;
}

- (int)flipCost
{
    if (_flipCost < 0) _flipCost = 1;
    return _flipCost;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count] ? self.cards[index] : nil);
}

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
                    self.score += matchScore * self.matchBonus;
                    self.descriptionOfLastFlip =
                        [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
                         card.contents,
                         [otherContents componentsJoinedByString:@" & "],
                         matchScore * self.matchBonus];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }                    
                    self.score -= self.mismatchPenalty;
                    self.descriptionOfLastFlip =
                        [NSString stringWithFormat:@"%@ & %@ don’t match! %d point penalty!",
                         card.contents,
                         [otherContents componentsJoinedByString:@" & "],
                         self.mismatchPenalty];
                }
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.faceUp;
    }
}

- (NSArray *)nextCombinationAfter:(NSArray *)combination
{
    int n = [self.cards count];
    int k = self.numberOfMatchingCards;
    int i = k - 1;
    NSMutableArray *next = [combination mutableCopy];
    next[i] = @([next[i] intValue] + 1);
    while ((i > 0) && ([next[i] intValue] > n - k + i)) {
        i--;
        next[i] = @([next[i] intValue] + 1);
    }
    if ([next[0] intValue] > n - k) return nil;
    for (i = i + 1; i < k; ++i) {
        next[i] = @([next[i - 1] intValue] + 1);
    }
    return next;
}

- (BOOL)validCombination:(NSArray *)combination
{
    for (NSNumber *index in combination) {
        Card *card = self.cards[[index intValue]];
        if (card.isUnplayable) return NO;
    }
    return YES;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination startinWithIndex:(int)start
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int i = start; i < [combination count]; i++) {
        [cards addObject:self.cards[[combination[i] intValue]]];
    }
    return cards;
}

- (NSArray *)cardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startinWithIndex:0];
}

- (NSArray *)otherCardsFromCombination:(NSArray *)combination
{
    return [self cardsFromCombination:combination startinWithIndex:1];
}

- (NSArray *)matchingCards {
    NSMutableArray *combination = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.numberOfMatchingCards; i++) {
        [combination addObject:@(i)];
    }
    
    NSArray *matchedCards;
    NSArray *nextCombination = combination;
    do {
        if (![self validCombination:nextCombination]) continue;
        if ([self.cards[[nextCombination[0] intValue]] match:[self otherCardsFromCombination:nextCombination]]) {
            matchedCards = [self cardsFromCombination:nextCombination];
            break;
        }
    } while ((nextCombination = [self nextCombinationAfter:nextCombination]));
    
    
    return matchedCards;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (void)drawNewCard
{
    Card *card = [self.deck drawRandomCard];
    if (card) {
        [self.cards addObject:card];
    }
}

@end
