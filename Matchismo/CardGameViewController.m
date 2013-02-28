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

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = !indexPath.section ? playingCard.isFaceUp : YES;
            playingCardView.alpha = playingCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) return CGSizeMake(56, 72);
    if (indexPath.section == 1) return CGSizeMake(150, 20);
    return CGSizeMake(70, 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) return UIEdgeInsetsMake(10, 10, 0, 0);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
