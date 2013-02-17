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
@synthesize gameResult = _gameResult;

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        //[self cardModeChanged:self.cardModeSelector];
        _game.numberOfMatchingCards = 2;
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = @"Card Matching";
    return _gameResult;
}

- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    
    [super updateUI];
}

@end
