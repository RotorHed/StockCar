//
//  Pitboard.m
//  StockCar
//
//  Created by Alan Jenkins on 10/15/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pitboard.h"

@implementation Pitboard
// P : Player Number
// Laps Remaining
// Number of players left to take turns
//Crash ahead, slow traffic (blue flag), failures?
// Seems like all this data in the StockCarController object


-(Pitboard *) init {
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"PitBoard.png"]];
    if (self) {
        [self scaleToSize:CGSizeMake(100, 200)];
        [self setPosition:CGPointMake(-380, +145)];
        
        UIColor *yel = [[UIColor alloc]initWithRed:0.8 green:0.8 blue:0 alpha:1];
        NSString *p, *pos1, *pos2;
        NSString *l, *lap1, *lap2, *lap3;
        NSString *n, *n1, *n2;
        NSString *genText;
        
        p = @"P";
        pos1 = @"0";
        pos2 = @"1";
        
        l = @"L";
        lap1 = @"1";
        lap2 = @"2";
        lap3 = @"3";
        
        n = @"N";
        n1 = @"0";
        n2 = @"0";
        
        genText = @"CRASH!";
        
        _letterP = [[SKLabelNode alloc]initWithFontNamed:@"ChalkboardSE-Bold"];
        [_letterP setText:p];
        [_letterP setPosition:CGPointMake(-33, 58)];
        [_letterP setFontColor:yel];
        [_letterP setFontSize:30];
        
        _letterP1 = _letterP.copy;
        [_letterP1 setText:pos1];
        [_letterP1 setPosition:CGPointMake(-05, 58)];

        _letterP2 = _letterP.copy;
        [_letterP2 setText:pos2];
        [_letterP2 setPosition:CGPointMake(15, 58)];
        
        
        
        _letterL = _letterP.copy;
        [_letterL setText:l];
        [_letterL setPosition:CGPointMake(-33, 15)];

        _letterL1 = _letterP.copy;
        [_letterL1 setText:lap1];
        [_letterL1 setPosition:CGPointMake(-5, 15)];

        _letterL2 = _letterP.copy;
        [_letterL2 setText:lap2];
        [_letterL2 setPosition:CGPointMake(16, 15)];

        _letterL3 = _letterP.copy;
        [_letterL3 setText:lap3];
        [_letterL3 setPosition:CGPointMake(35, 15)];
        
        
        _letterN = _letterP.copy;
        [_letterN setText:n];
        [_letterN setPosition:CGPointMake(-33, -38)];
        
        _letterN1 = _letterP.copy;
        [_letterN1 setText:n1];
        [_letterN1 setPosition:CGPointMake(-5, -38)];
        
        _letterN2 = _letterP.copy;
        [_letterN2 setText:n2];
        [_letterN2 setPosition:CGPointMake(16, -38)];


        
        [self addChild:_letterP];
        [self addChild:_letterP1];
        [self addChild:_letterP2];
        [self addChild:_letterL];
        [self addChild:_letterL1];
        [self addChild:_letterL2];
        [self addChild:_letterL3];
        [self addChild:_letterN];
        [self addChild:_letterN1];
        [self addChild:_letterN2];

        return self;
    }
    return nil;
}

-(void) playerNumber:(int)num {
    NSString *pos1 = @"0";
    NSString *pos2;
    NSString *numS = [[NSNumber numberWithInt:num]stringValue];

    if(numS.length == 2)
        pos1 = [numS substringToIndex:0];
    pos2 = [numS substringFromIndex:0];
    
    [_letterP1 setText:pos1];
    [_letterP2 setText:pos2];
}

-(void) lapsRemain:(int)laps {
    NSString *lap1, *lap2, *lap3;
    
    lap1 = @" ";
    lap2 = @" ";
    NSString *lapStr = [[NSNumber numberWithInt:laps]stringValue];
    
    switch (lapStr.length) {
        case 3:
            lap1 = [lapStr substringToIndex:1];
            lap2 = [lapStr substringWithRange:NSMakeRange(1, 1)];
            lap3 = [lapStr substringFromIndex:2];
            break;
        case 2:
            lap2 = [lapStr substringToIndex:1];
            lap3 = [lapStr substringFromIndex:1];
            break;
        case 1:
            lap3 = [lapStr substringToIndex:1];
    }

    [_letterL1 setText:lap1];
    [_letterL2 setText:lap2];
    [_letterL3 setText:lap3];
}


@end
