//
//  DriverDeckDefs.h
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#ifndef DriverDeckDefs_h
#define DriverDeckDefs_h

#import <SpriteKit/SpriteKit.h>

#define DCARD_STD_WIDTH 90
#define DCARD_STD_HEIGHT 140.0
#define DRIVER_DECK_X -430
#define DRIVER_DECK_Y -300
#define DRIVER_DISCARD_X -430
#define DRIVER_DISCARD_Y -150
#define DRIVER_HAND_SPACING 95.0
#define DRIVER_DRAW_SPACING 1.0
#define DCARD_ACTIONTEXT_OFFSET 140
#define DCARD_ACTIONTEXT_SIZE 40.0
#define DCARD_SPEEDRATE_MIN 105
#define DCARD_SPEEDRATE_MAX 990
#define DCARD_SPEEDRATE_INC 15
#define DCARD_PIT_MIN 13.9
#define DCARD_PIT_MAX 19.9
#define DCARD_PIT_INC 0.1
#define SC_DEFAULT_FONT @"Times"


typedef enum {
    FAST_PIT,
    GOOD_CAR_SETUP,
    LEARN_THE_TRACK,
    GOOD_ENGINE_SETTING,
    INSIDE_ADVANTAGE,
    TWO_WIDE,
    PASS_INSIDE,
    PASS_OUTSIDE,
    PASS_TWO,
    PULL_AWAY,
    BLOCK,
    CHALLENGE,
    DRAFT
} DRIVERCARDACTIONS;

typedef enum {
    ACTION_ONLY,
    RESPONSE_ONLY,
    ACT_AND_RESP
} DRIVERCARDTYPES;

@interface DriverCard : SKSpriteNode
@property (atomic) DRIVERCARDACTIONS Action;
@property (atomic) DRIVERCARDTYPES Type;
@property (atomic) int QualiTime;
@property (atomic) int PitStopTime;
@property (atomic) int lapsCompleted;
@property (atomic) int TimeModifier;
@end

@interface DriverDeckLibrary : NSObject
@property (atomic) NSMutableArray *deck;
-(DriverDeckLibrary*)init:(int)p;
@end
#endif /* DriverDeckDefs_h */
