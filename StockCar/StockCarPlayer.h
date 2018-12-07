//
//  StockCarPlayer.h
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#ifndef StockCarPlayer_h
#define StockCarPlayer_h

#import "DriverDeckDefs.h"
#import "GameViewController.h"
#import "Dashboard.h"

#define SC_CAR_WIDTH 80
#define SC_CAR_HEIGHT 30
#define SC_LEADCAR_X -180
#define SC_LEADCAR_Y 150
#define SC_MINTIME 200

typedef enum {
    SETUP,
    QUALI,
    TRACK,
    ACTION,
    WAITING,
    ACTION_DONE,
    RESPOND,
    REFILL,
    RESET
} GAME_PHASE;

typedef enum {
    HUMAN,
    AI,
    SLOW_CAR,
    SHUNT,
    GAP
} PLAYER_TYPE;

@class StockCarController;

// Car and driver in symbiotic harmony :D
@interface StockCarPlayer : SKSpriteNode
@property (atomic) int Number;
@property (atomic) PLAYER_TYPE Kind;
@property (atomic) bool actionRoundComplete;
@property (atomic) int LeadDraftPosition;
@property (atomic) bool InPit;
@property (atomic) bool Lapped;
@property (atomic) int SecondsBehindLeadDraft;
@property (atomic) int MaxHandSize;
@property (atomic) int MaxActions;
@property (atomic) int RefillMax;
@property (atomic) int QualificationCardValue;
@property (atomic) int actionsTakenThisRound;
@property (atomic) bool playedLapCards;
@property (atomic) GAME_PHASE phase;
@property (atomic) GameViewController *GameTable;
@property (atomic) StockCarController *Controller;
@property (atomic) Dashboard *dash;
@property (atomic) bool CrashAhead; // flag used to check user response if crash ahead or normal lap card
//Effects on player follow
// dde = events from driver cards
//tde = events from track deck
@property (atomic) bool dde_GoodCarSetup; //Increase hand size
@property (atomic) bool dde_LearnTheTrack; //Play one extra card
@property (atomic) bool dde_GoodEngineSetting; //Draw one extra card
@property (atomic) bool dde_TwoWide; //Pass outside required to pass

@property (atomic) bool tde_HighInTurn; //Car to right. Free pass to cars behind
@property (atomic) bool tde_EngineTrouble;//One less action per turn
@property (atomic) bool tde_CarTooTight;//Hand size reduced (next refill)
@property (atomic) bool tde_BodyDamage;//draw one less card
@property (atomic) bool tde_TiresWorn;//cannot play or respond to Challenge card
@property (atomic) SEL continueButtonSel;
@property (atomic) SEL confirmButtonSel;

@property (atomic) NSMutableArray *drawPile;
@property (atomic) NSMutableArray *discardPile;
@property (atomic) NSMutableArray *hand;

-(StockCarPlayer*)initWithPlayer:(int)p andTable:(UIViewController*)t andController:(StockCarController*)c;
-(NSMutableArray*) DrawCards;
-(NSMutableArray*) FillHand;
-(void) PlayCard:(DriverCard*)Card;
-(NSMutableArray*) PlayerHand;
-(void) DrawSingleCard;
-(void) DrawCardToDiscard;
-(bool) DiscardQTimeLessThan:(int)minimumTime;
-(int) TopDiscardQTime;
-(void) CardsDiscarded:(NSMutableArray*)Cards;
-(void) CardDiscarded:(DriverCard*)Card;
-(DriverCard*) TopOfDiscard;
-(int)countOfDrawPile;
-(int) PositionInLeadDraft;
-(void) MoveInside;
-(void) MoveOutside;
-(void) OverTakeDriver:(StockCarPlayer*)p;
-(void) DNF;
-(void) SortHandByQTime;
-(void) SortHandByLaps;
-(void) SortHandByType;
-(void) UpdatePlayDisplay;
-(void) refillHand;
-(void) ButtonPressedWithCards:(NSMutableArray*)selection;
-(void) RegisterContinueSelector:(SEL)sel;
-(void) Continue;
-(void) RegisterConfirmSelector:(SEL)sel;
-(void) Confirm:(NSMutableArray *)data;
-(void) ClearCardsFromTable;
//-(NSMutableArray*) PlaySimulation:(GAME_PHASE)phase Laps:(int)l Response:(DRIVERCARDACTIONS)a;
@end
#endif /* StockCarPlayer_h */
