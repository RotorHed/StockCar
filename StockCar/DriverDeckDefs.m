//
//  DriverDeckDefs.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverDeckDefs.h"

@implementation DriverCard
- (DriverCard*) initWithAction:(DRIVERCARDACTIONS)a Type:(DRIVERCARDTYPES)t Texture:(SKTexture *)ct Laps:(int)l Speed:(int)s Pit:(float)pit {
    self = [super initWithTexture:ct];
    if(self){
        [self scaleToSize:CGSizeMake(DCARD_STD_WIDTH,DCARD_STD_HEIGHT)];
        [self setPosition:CGPointMake((DRIVER_DECK_X), DRIVER_DECK_Y)];

        // Set Text Labels on sides
        SKLabelNode* cardActionText_R = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardActionText_L = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardMainText_T = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
//        SKLabelNode* cardMainText_B = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardLapText_T = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardLapText_B = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardQText_T = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardQText_B = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardPText_T = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        SKLabelNode* cardPText_B = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];

        UIColor *blk = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1];
        UIColor *wht = [[UIColor alloc]initWithRed:256 green:256 blue:256 alpha:1];
        NSString *cardAText, *cardMainText;
        
        switch(t) {
        case ACTION_ONLY:
            cardAText = @"Action";
            break;
        case RESPONSE_ONLY:
                cardAText = @"Response";
                break;
        case ACT_AND_RESP:
                cardAText = @"Act / Resp";
                break;
        }
        
        switch(a){
            case FAST_PIT:
                cardMainText = @"Fast Pit";
                break;
            case GOOD_CAR_SETUP:
                cardMainText = @"    Good\nCar Setup";
                break;
            case LEARN_THE_TRACK:
                cardMainText = @"     Learn\nThe Track";
                break;
            case GOOD_ENGINE_SETTING:
                cardMainText = @"       Good\nEngine Setting";
                break;
            case INSIDE_ADVANTAGE:
                cardMainText = @"    Inside\nAdvantage";
                break;
            case TWO_WIDE:
                cardMainText = @"Two Wide";
                break;
            case PASS_INSIDE:
                cardMainText = @"Pass Inside";
                break;
            case PASS_OUTSIDE:
                cardMainText = @"Pass Outside";
                break;
            case PASS_TWO:
                cardMainText = @"Pass Two";
                break;
            case PULL_AWAY:
                cardMainText = @"Pull Away";
                break;
            case BLOCK:
                cardMainText = @"Block";
                break;
            case CHALLENGE:
                cardMainText = @"Challenge";
                break;
            case DRAFT:
                cardMainText = @"Draft";
        }
        
        NSString *lStr = [NSString stringWithFormat:@"  %i\nLaps", l];
        NSString *qStr = [NSString stringWithFormat:@"xxx.%i", s];
        NSString *pStr = [NSString stringWithFormat:@"%.01f", pit];
        

        [cardActionText_R setText:cardAText];
        [cardActionText_R setFontSize:DCARD_ACTIONTEXT_SIZE];
        [cardActionText_R setZRotation:M_PI/2+M_PI];
        [cardActionText_R setFontColor:blk];
        [cardActionText_R setPosition:CGPointMake(DCARD_ACTIONTEXT_OFFSET, 0)];
        [cardActionText_R setUserInteractionEnabled:NO];

        cardActionText_L = cardActionText_R.copy;
        [cardActionText_L setZRotation:M_PI/2];
        [cardActionText_L setPosition:CGPointMake(0-DCARD_ACTIONTEXT_OFFSET, 0)];

        
        [cardMainText_T setText:cardMainText];
        [cardMainText_T setNumberOfLines:2];
        [cardMainText_T setFontSize:DCARD_ACTIONTEXT_SIZE];
        [cardMainText_T setPosition:CGPointMake(0, -20.0)];
        [cardMainText_T setZRotation:(M_PI/4)];
        [cardMainText_T setFontColor:blk];
        [cardMainText_T setUserInteractionEnabled:NO];
        
        [cardLapText_T setText:lStr];
        [cardLapText_T setNumberOfLines:2];
        [cardLapText_T setFontSize:DCARD_ACTIONTEXT_SIZE];
        [cardLapText_T setFontColor:wht];
        [cardLapText_T setPosition:CGPointMake(-120.0, 140.0)];
        [cardLapText_T setUserInteractionEnabled:NO];
        cardLapText_B = cardLapText_T.copy;
        [cardLapText_B setNumberOfLines:2];
        [cardLapText_B setZRotation:M_PI];
        [cardLapText_B setPosition:CGPointMake(120.0, -140.0)];
        
        [cardQText_T setText:qStr];
        [cardQText_T setFontSize:DCARD_ACTIONTEXT_SIZE];
        [cardQText_T setFontColor:blk];
        [cardQText_T setPosition:CGPointMake(20.0, 200.0)];
        [cardQText_T setUserInteractionEnabled:NO];
        cardQText_B = cardQText_T.copy;
        [cardQText_B setZRotation:M_PI];
        [cardQText_B setPosition:CGPointMake(-20.0, -200.0)];

        [cardPText_T setText:pStr];
        [cardPText_T setFontSize:DCARD_ACTIONTEXT_SIZE-15];
        [cardPText_T setFontColor:blk];
        [cardPText_T setPosition:CGPointMake(130, 180.0)];
        [cardPText_T setUserInteractionEnabled:NO];
        cardPText_B = cardPText_T.copy;
        [cardPText_B setZRotation:M_PI];
        [cardPText_B setPosition:CGPointMake(-130.0, -175.0)];
        
        [self addChild:cardActionText_R];
        [self addChild:cardActionText_L];
        [self addChild:cardMainText_T];
// Ugly?        [self addChild:cardMainText_B];
        [self addChild:cardLapText_T];
        [self addChild:cardLapText_B];
        [self addChild:cardQText_T];
        [self addChild:cardQText_B];
        [self addChild:cardPText_T];
        [self addChild:cardPText_B];
        
    self.Action = a;
    self.Type = t;
    self.lapsCompleted = l;
    self.QualiTime = s;
    self.PitStopTime = pit;
    }
    return self;
}
@end

@implementation DriverDeckLibrary

-(DriverDeckLibrary*) init:(int)p {
    _deck = [[NSMutableArray alloc]init];
    
    NSString *texName;
    switch(p){
        case 0:
            texName =  @"SCDriverCardFront_Yel";
            break;
        case 1:
            texName =  @"SCDriverCardFront_Red";
            break;
        case 2:
            texName =  @"SCDriverCardFront_LtBlue";
            break;
    }
    
    int laps[60], pTime[60];
    float qTime[60];
    for (int i=0; i < 60; i++) {
        qTime[i] = DCARD_SPEEDRATE_MIN + (i * DCARD_SPEEDRATE_INC);
        pTime[i] = DCARD_PIT_MIN + (i * DCARD_PIT_INC);
    }
    for (int i = 0; i < 20; i++)
        laps[i] = 3;
    for (int i = 20; i < 40; i++)
        laps[i] = 6;
    for (int i = 40; i < 50; i++)
        laps[i] = 12;
    for (int i = 50; i < 60; i++)
        laps[i] = 15;
    
    for(int i=0; i < 60; i++) {
        int n = arc4random_uniform(60);
        int a = qTime[i];
        qTime[i] = qTime[n];
        qTime[n] = a;
        
        n = arc4random_uniform(60);
        float b = pTime[i];
        pTime[i] = pTime[n];
        pTime[n] = b;
        
        n = arc4random_uniform(60);
        a = laps[i];
        laps[i] = laps[n];
        laps[n] = a;
    }
    
    
    int s = 0;
    
    [_deck addObject:[[DriverCard alloc] initWithAction:FAST_PIT Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName] Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    [_deck addObject:[[DriverCard alloc] initWithAction:GOOD_CAR_SETUP Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    [_deck addObject:[[DriverCard alloc] initWithAction:LEARN_THE_TRACK Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    [_deck addObject:[[DriverCard alloc] initWithAction:GOOD_ENGINE_SETTING Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    int cardsOfThisType = 4;
    
    //4x Inside Advantage Action Card
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:INSIDE_ADVANTAGE Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];

    // 4x Two Wide Action
    cardsOfThisType = 4;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:TWO_WIDE Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];

    // 8x Pass Inside Action
    cardsOfThisType = 8;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:PASS_INSIDE Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    // 4x Pass Outdisde Action
    cardsOfThisType = 4;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:PASS_OUTSIDE Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];

    // 4x Pass Two Action
    cardsOfThisType = 4;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:PASS_TWO Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    // 8x Pull Away Action
    cardsOfThisType = 8;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:PULL_AWAY Type:ACTION_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    // 4x BLOCK Response
    cardsOfThisType = 4;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:BLOCK Type:RESPONSE_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    // 10x Challenge Response
    cardsOfThisType = 10;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:CHALLENGE Type:RESPONSE_ONLY Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    
    // 10x Draft Action & Response
    cardsOfThisType = 10;
    for(int n=1; n <= cardsOfThisType; n++)
        [_deck addObject:[[DriverCard alloc] initWithAction:DRAFT Type:ACT_AND_RESP Texture:[SKTexture textureWithImageNamed:texName]Laps:laps[s] Speed:qTime[s] Pit:pTime[s++]]];
    return self;
}

@end

