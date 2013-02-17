//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 14.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSArray *allGameResults;

@end

@implementation GameResultViewController

- (void)updateUI
{
    NSString *displayText = @"";
    for (GameResult *result in self.allGameResults) {
        displayText = [displayText stringByAppendingFormat:@"%@: %d, (%@, %gs)\n",
                       result.gameType ? result.gameType : @"Card Matching",
                       result.score,
                       [NSDateFormatter localizedStringFromDate:result.end
                                                      dateStyle:NSDateFormatterShortStyle
                                                      timeStyle:NSDateFormatterShortStyle],
                       round(result.duration)];
    }
    self.display.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allGameResults = [GameResult allGameResults];
    [self updateUI];
}

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (IBAction)sortByDate {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateUI];
}

- (IBAction)sortByScore {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}

- (IBAction)sortByDuration {
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI];
}

@end
