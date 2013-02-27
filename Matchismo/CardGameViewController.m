//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 25.01.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface CardGameViewController ()

@end

@implementation CardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return self.gameSettings.numberPlayingCards;
}

- (NSUInteger)numberOfMatchingCards
{
    return 2;
}

- (NSString *)gameType
{
    return @"Card Matching";
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

@end
