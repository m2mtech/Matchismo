//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 25.01.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) PlayingCardDeck *deck;

@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (!sender.isSelected) {
        [sender setTitle:[self.deck drawRandomCard].contents
                forState:UIControlStateSelected];
    }
    
    sender.selected = !sender.selected;
    self.flipCount++;
    
}

- (void)viewDidLoad
{
    
}

@end
