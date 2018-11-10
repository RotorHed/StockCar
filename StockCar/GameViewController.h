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

@class StockCarPlayer;

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *StartButton;
@property (weak, nonatomic) IBOutlet SKView *MainMenuView;
@property (atomic) NSMutableArray* LeadDraftNodes;
@property (atomic) StockCarPlayer* actionPlayer;
@property (atomic) SEL confirmationSelector;

-(void) UpdateDriverDeckRemaining:(int)count;
-(void) UpdateTrackDeckRemaining:(int)count;

-(void) PlaceTrackDeck;
-(void) PlaceInTrackDiscard:(NSMutableArray*)theseCards;

-(void) PlaceDriverDeck;
-(void) PlaceCardsInDriverDiscard:(NSMutableArray*)toDiscard;
-(void) PlaceCardInDriverDiscard:(DriverCard*)c;
-(void) DisplayHandOfPlayer:(NSMutableArray*)hand;

-(void) DisplayNonPlayerDiscardsForPlayer:(StockCarPlayer*)p Cards:(NSMutableArray*)crds;
//-(void) DisplayNonPlayerDiscardForPlayer:(int)p Card:(DriverCard*)crd;

-(void) ShowQualificationPrompt:(bool)show;
-(void) ShowRespondPrompt:(bool)show Text:(NSString*)str;
-(void) ShowTakeActionPrompt:(bool)show;

-(void) AllowMultipleSelectedCards:(bool)b;
-(void) HideConfirmationBtn:(bool)t;
-(void) HideContinueBtn:(bool)t;

-(void) UpdateLeadDraftDisplay;
-(void) AddToLeadDraftEvent:(TrackCard*)e;

-(void) InsertEvent:(TrackCard*)E;

-(void) AddToScene:(SKSpriteNode*)node;
@end
