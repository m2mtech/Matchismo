//
//  GameResult.h
//  Matchismo
//
//  Created by Martin Mandl on 14.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResults

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@property (strong, nonatomic) NSString *gameType;

- (NSComparisonResult)compareDate:(GameResult *)aGameResult;
- (NSComparisonResult)compareScore:(GameResult *)aGameResult;
- (NSComparisonResult)compareDuration:(GameResult *)aGameResult;

@end
