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

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *resultOfLastFlipLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *history;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSelector;

@property (strong, nonatomic) CardMatchingGame *game;

@property (strong, nonatomic) GameResult *gameResult;

- (void)updateUI;

- (IBAction)flipCard:(UIButton *)sender;
- (IBAction)dealButtonPressed:(UIButton *)sender;
- (IBAction)cardModeChanged:(UISegmentedControl *)sender;
- (IBAction)historySliderChanged:(UISlider *)sender;
- (void)updateSliderRange;

@end
