//
//  TrackDefs.h
//  StockCar
//  (Name modified from Track.h)
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#ifndef TrackDefs_h
#define TrackDefs_h
#import <SpriteKit/SpriteKit.h>

#define TRACK_CARD_WIDTH 150.0
#define TRACK_CARD_HEIGHT 100.0
#define TRACK_DISCARD_X -150.0
#define TRACK_DISCARD_Y 255.0
#define SC_DEFAULT_FONT @"Times"


typedef enum {
    NONE,
    GROOVE_OUT,
    CRASH,
    BLOWN_ENG,
    OVERHEAT,
    TRANSMISSION,
    BRAKES,
    SLOW_TRAFFIC,
    HIGH_IN_TURN,
    LOSE_TRACTION_2s,
    LOSE_TRACTION_4s,
    ENGINE_TROUBLE,
    TIRES_WORN,
    BODY_DMG,
    CAR_TOO_TIGHT
}EVENTS;

typedef enum {
    GREEN,
    YELLOW
} FLAGS;

typedef enum {
    SHORT,
    ONE_MILE_OVAL,
    SUPER_SPEEDWAY
} TRACKS;



@interface TrackCard : SKSpriteNode
@property (atomic) int cardReference;
@property (atomic) NSInteger lapsRequired;
@property (atomic) EVENTS event;
@property (atomic) FLAGS flag;
@end


@interface TrackDeckLibrary : NSObject
@property (atomic) NSMutableArray *ShortTrack;
@end

#endif /* TrackDefs_h */
