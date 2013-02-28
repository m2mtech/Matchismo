//
//  GameViewController.h
//  Matchismo
//
//  Created by Martin Mandl on 15.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "GameSettings.h"

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultOfLastFlipLabel;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) GameSettings *gameSettings;

- (void)updateUI;

@property (nonatomic) BOOL removeUnplayableCards;

// abstract
- (Deck *)createDeck;

@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger numberOfMatchingCards;
@property (strong, nonatomic) NSString *gameType;

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath;

@end
