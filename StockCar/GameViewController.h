//
//  GameViewController.h
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "DriverDeckDefs.h"
#import "TrackDefs.h"

typedef struct  {
    NSMutableArray *DisplayedHand;
    NSMutableArray *Discards;
} PLAYERSPECIFICITEMS;

@class StockCarPlayer;

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *StartButton;
@property (weak, nonatomic) IBOutlet SKView *MainMenuView;
@property (atomic) NSMutableArray* LeadDraftNodes;
//@property (atomic) StockCarPlayer* actionPlayer;
@property (atomic) SEL confirmationSelector;
@property (atomic,readonly) PLAYERSPECIFICITEMS CurrentPlayerItems;

-(void) UpdateDriverDeckRemaining:(int)count;
-(void) UpdateTrackDeckRemaining:(int)count;
-(void) ClearPlayerHandFromTableWithHand:(NSMutableArray *)hand andDiscards:(NSMutableArray *)discards;

-(void) PlaceTrackDeck;
-(void) PlaceInTrackDiscard:(NSMutableArray*)theseCards;

-(void) PlaceDriverDeck;
-(void) PlaceCardsInDriverDiscard:(NSMutableArray*)toDiscard;
-(void) PlaceCardInDriverDiscard:(DriverCard*)c;
-(void) DisplayHandOfPlayer:(NSMutableArray*)hand;

-(void) DisplayNonPlayerDiscardsForPlayer:(StockCarPlayer*)p Cards:(NSMutableArray*)crds;

-(void) ShowQualificationPrompt:(bool)show;
-(void) ShowRespondPrompt:(bool)show Text:(NSString*)str;
-(void) ShowTakeActionPrompt:(bool)show;

-(void) AllowMultipleSelectedCards:(bool)b;
-(void) HideConfirmationBtn:(bool)t;
-(void) SetConfirmBtnText:(NSString *)txt;
-(void) HideContinueBtn:(bool)t;
-(void) SetContinueBtnText:(NSString *)txt;

-(void) UpdateLeadDraftDisplay;
-(void) AddToLeadDraftEvent:(TrackCard*)e;

-(void) InsertEvent:(TrackCard*)E;

-(void) AddToScene:(SKSpriteNode*)node;
@end
