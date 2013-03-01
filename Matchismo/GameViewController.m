//
//  GameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 15.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *history;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSelector;

@property (strong, nonatomic) GameResult *gameResult;

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;

@property (strong, nonatomic) NSMutableArray *matchedCards; // of Card
@property (strong, nonatomic) NSArray *cheatCards; // of Card

@end

@implementation GameViewController

- (NSMutableArray *)matchedCards
{
    if (!_matchedCards) {
        _matchedCards = [[NSMutableArray alloc] init];
    }
    return _matchedCards;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (section == 2) return [self.matchedCards count];
    if (section == 1) return [self.matchedCards count] ? 1 : 0;
    return self.game.numberOfCards;
}

- (void)clearCell:(UICollectionViewCell*) cell
{
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) [view removeFromSuperview];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
        [self clearCell:cell];
        [self updateCell:cell usingCard:self.matchedCards[indexPath.item] atIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section == 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:cell.bounds];
        textLabel.text = @"matched cards:";
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"System Bold" size:20.0];
        [cell addSubview:textLabel];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    [self clearCell:cell];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card atIndexPath:indexPath];
    [self updateCell:cell ifCheatCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
       atIndexPath:(NSIndexPath *)indexPath
{
    // abstract
}

- (void)updateCell:(UICollectionViewCell *)cell ifCheatCard:(Card *)card
{
    if ([self.cheatCards containsObject:card]) {
        UIImage *image = [UIImage imageNamed:@"star.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat min = cell.bounds.size.width;
        if (cell.bounds.size.height < min) min = cell.bounds.size.height;
        imageView.frame = CGRectMake(min / 10, min / 10, min / 5, min / 5);
        [cell addSubview:imageView];        
    }
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

- (NSMutableArray *)history {
    if (!_history) {
        _history = [[NSMutableArray alloc] init];
    }
    return _history;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
        _game.numberOfMatchingCards = self.numberOfMatchingCards;
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
    }
    return _game;
}

- (Deck *)createDeck
{
    return nil; // abstract
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = self.gameType;
    return _gameResult;
}

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        [self clearCell:cell];
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        if (indexPath.section == 2) {
            [self updateCell:cell
                   usingCard:self.matchedCards[indexPath.item]
                 atIndexPath:indexPath];
        } else {
            [self updateCell:cell
                   usingCard:[self.game cardAtIndex:indexPath.item]
                 atIndexPath:indexPath];
            [self updateCell:cell ifCheatCard:[self.game cardAtIndex:indexPath.item]];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultOfLastFlipLabel.alpha = 1;
    self.resultOfLastFlipLabel.text = self.game.descriptionOfLastFlip;
    
    [self updateSliderRange];
}

- (void)updateSliderRange
{
    int maxValue = [self.history count] - 1;
    if (maxValue < 0) maxValue = 0;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath && (indexPath.section == 0)) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        
        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
        NSMutableArray *matchedIndexPaths = [[NSMutableArray alloc] init];
        for (int i = self.game.numberOfCards - 1; i >= 0; i--) {
            Card *card = [self.game cardAtIndex:i];
            if (card.isUnplayable) {
                if (![self.matchedCards containsObject:card]) {
                    [matchedIndexPaths addObject:[NSIndexPath indexPathForItem:[self.matchedCards count] inSection:2]];
                    [self.matchedCards addObject:card];
                }
                if (self.removeUnplayableCards) {
                    [self.game removeCardAtIndex:i];
                    [deleteIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
            }
        }        
        [self.cardCollectionView performBatchUpdates:^{
            if ([deleteIndexPaths count]) {
                [self.cardCollectionView deleteItemsAtIndexPaths:deleteIndexPaths];
            }
            if ([matchedIndexPaths count]) {
                self.cheatCards = nil;
                [self.cardCollectionView insertItemsAtIndexPaths:matchedIndexPaths];
                if ([self.matchedCards count] == self.numberOfMatchingCards) {
                    [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
                }
            }
        } completion:nil];
        
        if (![[self.history lastObject] isEqualToString:self.game.descriptionOfLastFlip])
            [self.history addObject:self.game.descriptionOfLastFlip];
        
        self.gameResult.score = self.game.score;
        
        [self updateUI];
        self.cardModeSelector.enabled = NO;
    }    
}

- (IBAction)cheatButtonPressed {
    self.cheatCards = [self.game matchingCards];
    [self updateUI];
}

- (IBAction)addCardsButtonPressed:(UIButton *)sender {
    
    if ([[self.game matchingCards] count]) {
        self.game.score -= self.gameSettings.mismatchPenalty * sender.tag;
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
    
    for (int i = 0; i < sender.tag; i++) {
        [self.game drawNewCard];
        [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:(self.game.numberOfCards - 1) inSection:0]]];
    }
//    [self.cardCollectionView reloadData];
    
    [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.game.numberOfCards - 1) inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    if (self.game.deckIsEmpty) {
        sender.enabled = NO;
        sender.alpha = 0.5;
        if (![[self.game matchingCards] count]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"No matches left ..."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Game Over!", nil];
            [alert show];
        }
    }
}

- (IBAction)dealButtonPressed:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    self.cardModeSelector.enabled = YES;
    self.history = nil;
    self.gameResult = nil;
    self.matchedCards = nil;
    self.cheatCards = nil;
    if (!self.game.deckIsEmpty) {
        self.addCardsButton.enabled = YES;
        self.addCardsButton.alpha = 1.0;
    }
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (IBAction)cardModeChanged:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.game.numberOfMatchingCards = 2;
            break;
        case 1:
            self.game.numberOfMatchingCards = 3;
            break;
        default:
            self.game.numberOfMatchingCards = 2;
            break;
    }
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    
    if ([self.history count]) {
        self.resultOfLastFlipLabel.alpha = (sliderValue + 1 < [self.history count]) ? 0.6 : 1.0;
        self.resultOfLastFlipLabel.text = [self.history objectAtIndex:sliderValue];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardCollectionView.delegate = self;
    [self updateUI];
}

@end
