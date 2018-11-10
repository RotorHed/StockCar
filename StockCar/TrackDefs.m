//
//  Track.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackDefs.h"

#define TCARD_SLAP_X 150.0f
#define TCARD_SLAP_Y -70.0f

@implementation TrackCard
- (TrackCard*) initWithRef:(int)r Laps:(int)l Event:(EVENTS)e Flag:(FLAGS)f Texture:(SKTexture *)ct {
    self = [super initWithTexture:ct];
    if(self)
    {
        [self scaleToSize:CGSizeMake(TRACK_CARD_WIDTH, TRACK_CARD_HEIGHT)];
        [self setPosition:CGPointMake(TRACK_DISCARD_X, TRACK_DISCARD_Y)];

        NSString *lStr = [NSString stringWithFormat:@"  %i\nLaps", l];
        NSString *eStr;
        UIColor *blk = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:1];
        SKLabelNode *laps = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        [laps setFontSize:25];
        SKLabelNode *eventNode = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        [eventNode setFontSize:34];
        [eventNode setPosition:CGPointMake(75.0, 70.0)];
        [eventNode setFontColor:blk];

        if(l>0) {
            [laps setText:lStr];
            UIColor *wht = [[UIColor alloc]initWithRed:100 green:100 blue:100 alpha:1];
            [laps setFontColor:wht];
            [laps setNumberOfLines:2];
        }

       if (e==NONE) {
           [laps setFontSize:50];
           [laps setPosition:CGPointMake(0, -50)];
           [self addChild:laps];
        }
        else {
            switch (e){
                case GROOVE_OUT:
                    eStr = @"Groove Outside";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
                case HIGH_IN_TURN:
                    eStr = @"High In Turn";
                    break;
                case SLOW_TRAFFIC:
                    eStr = @"Slow Traffic";
                    break;
                case LOSE_TRACTION_2s:
                    eStr = @"Lose Traction 2secs";
                    break;
                case LOSE_TRACTION_4s:
                    eStr = @"Lose Traction 4secs";
                    break;
                case BODY_DMG:
                    eStr = @"Body Damage";
                    break;
                case TIRES_WORN:
                    eStr = @"Tires Worn";
                    break;
                case ENGINE_TROUBLE:
                    eStr = @"Engine Trouble";
                    break;
                case CAR_TOO_TIGHT:
                    eStr = @"Car Too Tight";
                    break;
                case CRASH:
                    eStr = @"CRASH AHEAD!";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
                case BLOWN_ENG:
                    eStr = @"BLOWN ENGINE!";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
                case OVERHEAT:
                    eStr = @"OVERHEAT!";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
                case BRAKES:
                    eStr = @"BRAKES!";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
                case TRANSMISSION:
                    eStr = @"TRANSMISSION!";
                    [laps setPosition:CGPointMake(TCARD_SLAP_X, TCARD_SLAP_Y)];
                    [self addChild:laps];
                    break;
            }
            [eventNode setText:eStr];
            [self addChild:eventNode];
        }
        self.cardReference = r;
        self.lapsRequired = l;
        self.event = e;
        self.flag = f;
        return self;
    }
    return nil;
}
@end

@implementation TrackDeckLibrary
- (TrackDeckLibrary*) init {


    
    _ShortTrack = [[NSMutableArray alloc]init];
    int cardID = 1, cardOfThisType = 1;
    
    // 1 x 3 Laps, Green flag, Groove Outside
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:3 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    // 2x3 Laps, Green flag, no event
    cardOfThisType=2;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:3 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }
    
    // 2x6 Laps, Green flag, groove outside
    cardOfThisType=2;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:6 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    //7x6 lap, Green flag, no event
    cardOfThisType=7;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:6 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }
    
    //2x12 laps, green flag, groove outside
    cardOfThisType=2;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:12 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    //7x12 laps, green flag, no event
    cardOfThisType=7;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:12 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }
    
    //2x15 laps, green flag, groove outside
    cardOfThisType=2;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:15 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    //5x15 laps, green flag, no event
    cardOfThisType=5;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:15 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }

    //1x24 laps, green flag, groove outside
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:24 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    //4x24 laps, green flag, no event
    cardOfThisType=4;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:24 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }

    //1x30 laps, green flag, groove outside
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:30 Event:GROOVE_OUT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreenLaps"]]];
        cardID++;
    }
    
    //1x30 laps, green flag, no event
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:30 Event:NONE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontGreen"]]];
        cardID++;
    }
    
    //5x6 laps, yellow flag, Crash Ahead
    cardOfThisType=5;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:6 Event:CRASH Flag:YELLOW Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventYellow"]]];
        cardID++;
    }
    
    //1x4 laps, yellow flag, Blown engine
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:4 Event:BLOWN_ENG Flag:YELLOW Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventYellow"]]];
        cardID++;
    }
    
    //1x4 laps, yellow flag, Overheat
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:4 Event:OVERHEAT Flag:YELLOW Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventYellow"]]];
        cardID++;
    }

    //1x4 laps, yellow flag, Transmission
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:4 Event:TRANSMISSION Flag:YELLOW Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventYellow"]]];
        cardID++;
    }
    
    //1x4 laps, yellow flag, Brakes
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:4 Event:BRAKES Flag:YELLOW Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventYellow"]]];
        cardID++;
    }
    
    //8x0 lap, green flag, Slow Traffic
    cardOfThisType=8;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:SLOW_TRAFFIC Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //2x0 lap, green flag, high in turn
    cardOfThisType=2;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:HIGH_IN_TURN Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //1x0 lap, green flag, lose traction 2sec
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:LOSE_TRACTION_2s Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //1x0 lap, green flag, lose traction 4sec
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:LOSE_TRACTION_4s Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //1x0 lap, green flag, engine trouble
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:ENGINE_TROUBLE Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //1x0 lap, green flag, tires worm
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:TIRES_WORN Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    //1x0 lap, green flag, body damage
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:BODY_DMG Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    
    //1x0 lap, green flag, car too tight
    cardOfThisType=1;
    for(int n = 1; n <= cardOfThisType; n++ ) {
        [_ShortTrack addObject:[[TrackCard alloc]initWithRef:cardID Laps:0 Event:CAR_TOO_TIGHT Flag:GREEN Texture:[SKTexture textureWithImageNamed:@"SCTrackCardFrontEventGreen"]]];
        cardID++;
    }
    
    return self;
}
@end
