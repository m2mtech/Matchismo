//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 15.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (NSUInteger)numberOfMatchingCards
{
    return 3;
}

- (NSString *)gameType
{
    return @"Set Game";
}

- (BOOL)removeUnplayableCards
{
    return YES;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.color = setCard.color;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.number = setCard.number;
            setCardView.faceUp = !indexPath.section ? setCard.isFaceUp : NO;
            setCardView.alpha = setCard.isUnplayable && !indexPath.section ? 0.3 : 1.0;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) return CGSizeMake(40, 40);
    if (indexPath.section == 1) return CGSizeMake(150, 20);
    return CGSizeMake(65, 65);
}

 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) return UIEdgeInsetsMake(10, 10, 0, 0);
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSAttributedString *)updateAttributedString:(NSAttributedString *)attributedString withAttributesOfCard:(SetCard *)card
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    
    NSRange range = [[mutableAttributedString string] rangeOfString:card.contents];
    if (range.location != NSNotFound) {
        NSString *symbol = @"?";
        if ([card.symbol isEqualToString:@"oval"]) symbol = @"●";
        if ([card.symbol isEqualToString:@"squiggle"]) symbol = @"▲";
        if ([card.symbol isEqualToString:@"diamond"]) symbol = @"■";
       
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        
        if ([card.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];

        if ([card.shading isEqualToString:@"solid"])
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        if ([card.shading isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                     NSStrokeWidthAttributeName : @-5,
                     NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                     NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
             }];
        if ([card.shading isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];

        symbol = [symbol stringByPaddingToLength:card.number withString:symbol startingAtIndex:0];
        [mutableAttributedString replaceCharactersInRange:range
                                     withAttributedString:[[NSAttributedString alloc] initWithString:symbol
                                                                                          attributes:attributes]];
    }
    
    return mutableAttributedString;
}

- (void)addSetCard:(SetCard *)setCard toView:(UIView *)view atX:(CGFloat)x
{
    CGFloat height = self.resultOfLastFlipLabel.bounds.size.height;
    SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(x, 0, height, height)];
    setCardView.color = setCard.color;
    setCardView.symbol = setCard.symbol;
    setCardView.shading = setCard.shading;
    setCardView.number = setCard.number;
    setCardView.backgroundColor = [UIColor clearColor];
    [view addSubview:setCardView];
}

#define LASTFLIP_CARD_OFFSET_FACTOR 1.2

- (void)updateUILabel:(UILabel *)label withText:(NSString *)text andSetCards:(NSArray *)setCards
{
    if ([setCards count]) {
        label.text = text;
        CGFloat x = [label.text sizeWithFont:label.font].width;
        
        for (SetCard *setCard in setCards) {
            [self addSetCard:setCard toView:label atX:x];
            x += label.bounds.size.height * LASTFLIP_CARD_OFFSET_FACTOR;
        }
    } else label.text = @"";
}

- (void)updateUI
{
    [super updateUI];
    
    for (UIView *view in self.resultOfLastFlipLabel.subviews) {
        [view removeFromSuperview];
    }    
    if (self.game.descriptionOfLastFlip) {
        if ([self.game.descriptionOfLastFlip rangeOfString:@"Flipped up"].location != NSNotFound) {
            NSMutableArray *setCards = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.game.numberOfCards; i++) {
                Card *card = [self.game cardAtIndex:i];
                if (card.isFaceUp && [card isKindOfClass:[SetCard class]])
                    [setCards addObject:(SetCard *)card];
            }
            [self updateUILabel:self.resultOfLastFlipLabel withText:@"Flipped up: " andSetCards:setCards];
        } else if ([self.game.descriptionOfLastFlip rangeOfString:@"Matched"].location != NSNotFound) {
            [self updateUILabel:self.resultOfLastFlipLabel withText:@"✅ "
                    andSetCards:[self setCardsFromString:self.game.descriptionOfLastFlip]];
        } else {
            [self updateUILabel:self.resultOfLastFlipLabel withText:@"❌ "
                    andSetCards:[self setCardsFromString:self.game.descriptionOfLastFlip]];
        }
    }
    [self.resultOfLastFlipLabel setNeedsDisplay];    
}

- (NSArray *)setCardsFromString:(NSString *)string
{
    NSString *pattern = [NSString stringWithFormat:@"(%@):(%@):(%@):(\\d+)",
                         [[SetCard validSymbols] componentsJoinedByString:@"|"],
                         [[SetCard validColors] componentsJoinedByString:@"|"],
                         [[SetCard validShadings] componentsJoinedByString:@"|"]];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NULL
                                                                             error:&error];
    if (error) return nil;
    NSArray *matches = [regex matchesInString:string
                                      options:NULL
                                        range:NSMakeRange(0, [string length])];
    if (![matches count]) return nil;
    NSMutableArray *setCards = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in matches) {
        SetCard *setCard = [[SetCard alloc] init];
        setCard.symbol = [string substringWithRange:[match rangeAtIndex:1]];
        setCard.color = [string substringWithRange:[match rangeAtIndex:2]];
        setCard.shading = [string substringWithRange:[match rangeAtIndex:3]];
        setCard.number = [[string substringWithRange:[match rangeAtIndex:4]] intValue];
        [setCards addObject:setCard];
    }
    return setCards;
}

@end
