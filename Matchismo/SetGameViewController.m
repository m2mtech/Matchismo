//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 15.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]];
        self.game.numberOfMatchingCards = 3;
        self.game.matchBonus = 2;
    }
    return _game;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        if (card.isFaceUp) {
            [cardButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        } else {
            [cardButton setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    [super updateUI];
}


@end
