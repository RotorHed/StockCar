//
//  StockCarController.h
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//
#import "Track.h"
#import "StockCarPlayer.h"
#import "GameViewController.h"
#import "Pitboard.h"

#ifndef StockCarController_h
#define StockCarController_h

#define SC_DEFAULT_FONT @"Times"

@interface StockCarController : NSObject
@property (atomic) Track *TrackArea;
@property (atomic) TRACKS TrackTypeInUse;
@property (atomic) NSMutableArray *players;
@property (atomic) GAME_PHASE phase;
@property GameViewController* gViewCont;
@property (atomic) int LapsCompleted;
@property (atomic) StockCarPlayer* actionPlayer;
@property (atomic) bool actionPlayerStillTakingTurn;
@property (atomic) bool YellowFlag;
@property (atomic) bool grooveOutside;
@property (atomic) Pitboard *pitBoard;
-(StockCarController*) initWithGameViewController:(GameViewController*)g;
-(void) AddPlayerWithID:(int)p; // Populate players first! (Max 12)
-(void) TrackInUse:(TRACKS)t; // Then call this to say which track is in use
-(SKSpriteNode *) GetNextTrackCard;
-(int) TrackDeckCount;
-(TRACKS) TrackType;
-(GAME_PHASE)CurrentGamePhase;
-(DriverCard*) TopDiscardForPlayer:(int)p;
-(void) PlayerInteractionWithSelectedCard:(DriverCard*)selection;
-(void) DNF_ForPlayer:(StockCarPlayer*)p;
-(StockCarPlayer*) LowestQTimeTurnover;
//-(StockCarPlayer*)NextPlayer;
-(void) SetPhaseForAllPlayersTo:(GAME_PHASE)ph;
@end

#endif /* StockCarController_h */
