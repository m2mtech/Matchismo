//
//  SetCardView.m
//  Matchismo
//
//  Created by Martin Mandl on 21.02.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:12.0];
    [roundedRect addClip];

    if (self.faceUp) {
        [[UIColor colorWithWhite:0.9 alpha:1.0] setFill];
    } else {
        [[UIColor whiteColor] setFill];        
    }
    UIRectFill(self.bounds);

    [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
    [roundedRect stroke];
    
    [[UIColor blackColor] setFill];
    CGPoint point;
    point.x = 5;
    point.y = 2;
    [self.color drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
    point.y += 10;
    [self.symbol drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
    point.y += 10;
    [self.shading drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
    point.y += 10;
    [[NSString stringWithFormat:@"%d", self.number] drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

@end
