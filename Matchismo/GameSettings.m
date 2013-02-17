//
//  GameSettings.m
//  Matchismo
//
//  Created by Martin Mandl on 17.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

#define GAME_SETTINGS_KEY @"Game_Settings_Key"
#define MATCHBONUS_KEY @"MatchBonus_Key"
#define MISMATCHPENALTY_KEY @"MismatchPenalty_Key"
#define FLIPCOST_KEY @"FlipCost_Key"

- (int)getIntForKey:(NSString *)key withDefaultInt:(int)defaultValue
{
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:GAME_SETTINGS_KEY];
    if (!settings) return defaultValue;
    if (![[settings allKeys] containsObject:key]) return defaultValue;
    return [settings[key] intValue];
}

- (int)matchBonus
{
    return [self getIntForKey:MATCHBONUS_KEY withDefaultInt:4];
}

- (int)mismatchPenalty
{
    return [self getIntForKey:MISMATCHPENALTY_KEY withDefaultInt:2];
}

- (int)flipCost
{
    return [self getIntForKey:FLIPCOST_KEY withDefaultInt:1];
}

- (void)setInt:(int)value forKey:(NSString *)key
{
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:GAME_SETTINGS_KEY] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[key] = @(value);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:GAME_SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setMatchBonus:(int)matchBonus
{
    if (matchBonus != self.matchBonus)
        [self setInt:matchBonus forKey:MATCHBONUS_KEY];
}

- (void)setMismatchPenalty:(int)mismatchPenalty
{
    if (mismatchPenalty != self.mismatchPenalty)
        [self setInt:mismatchPenalty forKey:MISMATCHPENALTY_KEY];
}

- (void)setFlipCost:(int)flipCost
{
    if (flipCost != self.flipCost) [self setInt:flipCost forKey:FLIPCOST_KEY];

}

@end
