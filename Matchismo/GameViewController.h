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

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *resultOfLastFlipLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *history;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSelector;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) GameResult *gameResult;

@property (strong, nonatomic) GameSettings *gameSettings;

- (void)updateUI;

// abstract
- (Deck *)createDeck;

@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger numberOfMatchingCards;
@property (strong, nonatomic) NSString *gameType;

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card;

@end
