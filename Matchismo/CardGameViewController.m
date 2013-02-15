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

@end

@implementation CardGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        //[self cardModeChanged:self.cardModeSelector];
        self.game.numberOfMatchingCards = 2;
    }
    return _game;
}

@end
