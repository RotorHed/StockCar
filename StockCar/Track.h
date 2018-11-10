//
//  Track.h
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "TrackDefs.h"
#ifndef Track_h
#define Track_h

typedef struct {
    int HandSize;
    int CardsToPlay;
    int CardsToRefill;
    int SizeOfDrawPile;
    int HeatRaceLaps;
    int FullRaceLapsMin;
    int FullRaceLapsMax;
} TRACKSETUP;

@interface Track : NSObject
@property NSMutableArray *DrawPile;
@property NSMutableArray *DiscardPile;
@property NSMutableArray *trackPhasePile;
@property (atomic,readonly) TRACKSETUP *OneMileOval;
@property (atomic,readonly) TRACKSETUP *ShortTrack;
@property (atomic,readonly) TRACKSETUP *SuperSpeedWay;
-(Track*) initWithTrack:(TRACKS)t;
-(NSMutableArray*) TrackPhaseCards;
-(void) TrackPhaseDraw;
-(void) DiscardTrackPhaseCards;
-(SKSpriteNode*) TurnOverTrackCard;
-(int) LapsRequiredInCurrentPhase;
@end

#endif /* Track_h */
