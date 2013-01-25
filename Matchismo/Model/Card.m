//
//  Card.m
//  Matchismo
//
//  Created by Martin Mandl on 25.01.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
