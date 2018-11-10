//
//  GameViewController.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "StockCarController.h"
//#import "StockCarPlayer+AI.h"
#import "StockCarController+QualificationPhase.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarController+ActionPhase.h"

#define TRACK_DRAW_X -380.0
#define TRACK_DRAW_Y 300.00
#define SC_OTHERPLAYER_X 300
#define SC_OTHERPLAYER_Y 300

@implementation GameViewController
StockCarController *gameControl;
GKScene *scene;
SKView *skView;
GameScene *sceneNode;
SKSpriteNode *confBtn, *contBtn, *tCardDeck, *dCardDeck, *trackBackground;
NSMutableArray *playerCars;
UIColor *colRed, *colBlk, *colWht;
NSMutableArray *trackDiscard, *driverDiscard, *otherPlayerDiscards, *displayedHand, *tempNodes, *trackEvents;
SKLabelNode *tCardCount, *dCardCount;
bool SingleCardSelectionOnly;


-(void) UpdateDriverDeckRemaining:(int)count {
    if(_actionPlayer.Kind != HUMAN)
        return;
    [dCardCount setText:[NSString stringWithFormat:@"%i", count]];
}

-(void) UpdateTrackDeckRemaining:(int)count {
    if(_actionPlayer.Kind != HUMAN)
        return;
    [tCardCount setText:[NSString stringWithFormat:@"%i", count]];
}

-(void) AllowMultipleSelectedCards:(bool)b {
    SingleCardSelectionOnly = !b;
}

-(void) PlaceDriverDeck {
// This stuff is here because it should ordinarily only be called once - as players change, we only need to update the displayed card count
    if(_actionPlayer.Kind != HUMAN)
        return;
    dCardCount = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
    [dCardCount setFontColor:colWht];
    [dCardCount setFontSize:DCARD_ACTIONTEXT_SIZE+40];
    [dCardCount setPosition:CGPointMake(0.0, -20)];

    [dCardDeck setPosition:CGPointMake(DRIVER_DECK_X, DRIVER_DECK_Y)];
    [dCardDeck scaleToSize:CGSizeMake(DCARD_STD_WIDTH, DCARD_STD_HEIGHT)];
    [dCardDeck addChild:dCardCount];
    [sceneNode addChild:dCardDeck];
}


-(void) PlaceTrackDeck {
    // This stuff is here because it should ordinarily only be called once (per Game)
    if(_actionPlayer.Kind != HUMAN)
        return;
    NSString *trackType;
    switch([gameControl TrackType]) {
        case SHORT:
            trackType = [NSString stringWithFormat:@"Short\nTrack"];
            break;
        case ONE_MILE_OVAL:
            trackType = [NSString stringWithFormat:@"One Mile\n     Oval"];
            break;
        case SUPER_SPEEDWAY:
            trackType = [NSString stringWithFormat:@"     Super\nSpeedway"];
            break;
    }
    
    [tCardDeck setPosition:CGPointMake(TRACK_DRAW_X, TRACK_DRAW_Y)];
    [tCardDeck scaleToSize:CGSizeMake(TRACK_CARD_WIDTH, TRACK_CARD_HEIGHT)];
    tCardCount = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
    [tCardCount setFontSize:DCARD_ACTIONTEXT_SIZE+10];
    [tCardCount setPosition:CGPointMake(+200, 110)];
    [tCardCount setFontColor:colWht];
    
    SKLabelNode *trackName = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
    [trackName setFontSize:DCARD_ACTIONTEXT_SIZE];
    [trackName setText:trackType];
    [trackName setPosition:CGPointMake(0, -170)];
    [trackName setFontColor:colWht];
    [trackName setNumberOfLines:2];
    [tCardDeck addChild:trackName];
    
    [tCardDeck addChild:tCardCount];
    [self UpdateTrackDeckRemaining:[gameControl TrackDeckCount]];
    [sceneNode addChild:tCardDeck];
}

-(void) PlaceInTrackDiscard:(NSMutableArray*)theseCards {
    //maybe more than one card in trackphase.
    
    for( TrackCard *t in trackDiscard)
        [t removeFromParent];
    
    trackDiscard = theseCards;
    int n = 0;
    for (TrackCard *t in trackDiscard) {
        [t setPosition:CGPointMake(TRACK_DRAW_X+TRACK_CARD_WIDTH+30+(TRACK_CARD_WIDTH*n++), TRACK_DRAW_Y)];
        [sceneNode addChild:t];
    }
}

-(void) PlaceCardsInDriverDiscard:(NSMutableArray*)toDiscard {
    if(_actionPlayer.Kind != HUMAN)
        return;
    int n = 0;
    [sceneNode removeChildrenInArray:toDiscard];
    for(DriverCard*c in toDiscard) {
        [c removeFromParent];
        [c setPosition:CGPointMake(DRIVER_DISCARD_X + (n++*40), DRIVER_DISCARD_Y)];
        [sceneNode addChild:c];
    }
}

-(void) PlaceCardInDriverDiscard:(DriverCard*)c {
    if(_actionPlayer.Kind != HUMAN)
        return;
    
    [c setPosition:CGPointMake(DRIVER_DISCARD_X+20, DRIVER_DISCARD_Y)];
    [displayedHand removeObjectsInArray:driverDiscard];
}

-(void) DisplayNonPlayerDiscardsForPlayer:(StockCarPlayer*)p Cards:(NSMutableArray*)crds {
    if(p.Kind != AI)
        return;
    int offset = p.Number;
    int n = 0;
    for (DriverCard* d in crds) {
        [d removeFromParent];
        [d setPosition:CGPointMake(100 + (offset*100) + DCARD_STD_WIDTH,300-n*20)];
        n++;
        [sceneNode addChild:d];
    }
}

-(void) DisplayNonPlayerDiscardForPlayer:(int)p Card:(DriverCard*)crd {
    [otherPlayerDiscards addObject:crd];
    //[self DisplayNonPlayerDiscards:otherPlayerDiscards];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gameControl = [[StockCarController alloc]initWithGameViewController:(GameViewController*)self];
    [gameControl AddPlayerWithID:0];
    [gameControl AddPlayerWithID:1];
    [gameControl AddPlayerWithID:2];
    [gameControl TrackInUse:SHORT];
    
    colRed = [[UIColor alloc]initWithRed:100.0f green:0.0f blue:0.0f alpha:1];
    colBlk = [[UIColor alloc]initWithRed:0.0f green:0.0f blue:0.0f alpha:1];
    colWht = [[UIColor alloc]initWithRed:100.0f green:100.0f blue:100.0f alpha:1];
    
    confBtn = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"RedButton"]];
    [confBtn scaleToSize:CGSizeMake(100.0f, 50.0f)];
    [confBtn setPosition:CGPointMake(450.0f, -50.0f)];
    
    
    contBtn = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"RedButton"]];
    [contBtn scaleToSize:CGSizeMake(100.0f, 50.0f)];
    [contBtn setPosition:CGPointMake(450.0f, 20.0f)];
    

    tCardDeck = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"SCTrackCardBack"]];
    dCardDeck = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"SCDriverCardBack"]];
    tempNodes = [[NSMutableArray alloc]init];
    trackEvents = [[NSMutableArray alloc]init];
    self.LeadDraftNodes = [[NSMutableArray alloc]init];
    
    SKLabelNode* confButtonTxt = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];

    NSString *BtnText = [NSString stringWithFormat:@"Confirm..."];
    [confButtonTxt setText:BtnText];
    [confButtonTxt setFontColor:colWht];
    [confButtonTxt setFontSize:30];
    [confBtn addChild:confButtonTxt];
    [confBtn setHidden:NO];

    
    SKLabelNode* contButtonTxt = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];

    NSString *ContBtnText = [NSString stringWithFormat:@"CONTINUE"];
    [contButtonTxt setText:ContBtnText];
    [contButtonTxt setFontColor:colWht];
    [contButtonTxt setFontSize:30];
    [contBtn addChild:contButtonTxt];
    [contBtn setHidden:NO];

    
    SingleCardSelectionOnly = YES;

    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    scene = [GKScene sceneWithFileNamed:@"GameScene"];
    
    // Get the SKScene from the loaded GKScene
    sceneNode = (GameScene *)scene.rootNode;

    // Copy gameplay related content over to the scene
    sceneNode.entities = [scene.entities mutableCopy];
    sceneNode.graphs = [scene.graphs mutableCopy];
    
    // Set the scale mode to scale to fit the window
    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
    
    skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:sceneNode];
    [sceneNode addChild:confBtn];
    [sceneNode addChild:contBtn];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)StartButton_pressed:(id)sender {
    [_MainMenuView setHidden:YES];
    [gameControl StartQualificationPhase];
}

-(void) ShowQualificationPrompt:(bool)show {
    if(tempNodes && !show) {
        [sceneNode removeChildrenInArray:tempNodes];
        [tempNodes removeAllObjects];
    }
    else {
    NSString *qText = [NSString stringWithFormat:@"QUALIFICATION PHASE!"];
    
    SKLabelNode *qPrompt = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
    [qPrompt setText:qText];
    [qPrompt setNumberOfLines:2];
    [qPrompt setFontSize:40.0f];
    [qPrompt setFontColor:colRed];
    [qPrompt setPosition:CGPointMake(0.0f, 50)];
    [sceneNode addChild:qPrompt];
    [tempNodes addObject:qPrompt];
    }
}

-(void) ShowRespondPrompt:(bool)show Text:(NSString*)str {
    if(tempNodes && !show) {
        [sceneNode removeChildrenInArray:tempNodes];
        [tempNodes removeAllObjects];
    }
    else {
        
        SKLabelNode *qPrompt = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        [qPrompt setText:str];
        [qPrompt setNumberOfLines:2];
        [qPrompt setFontSize:30.0f];
        [qPrompt setFontColor:colRed];
        [qPrompt setPosition:CGPointMake(0.0f, -100)];
        [sceneNode addChild:qPrompt];
        [tempNodes addObject:qPrompt];
    }
}

-(void) ShowTakeActionPrompt:(bool)show {
    if(tempNodes && !show) {
        [sceneNode removeChildrenInArray:tempNodes];
        [tempNodes removeAllObjects];
    }
    else {
        NSString *qText = [NSString stringWithFormat:@"Play action card, or pass..."];
        
        SKLabelNode *qPrompt = [[SKLabelNode alloc]initWithFontNamed:SC_DEFAULT_FONT];
        [qPrompt setText:qText];
        [qPrompt setNumberOfLines:2];
        [qPrompt setFontSize:40.0f];
        [qPrompt setFontColor:colRed];
        [qPrompt setPosition:CGPointMake(0.0f, 50)];
        [sceneNode addChild:qPrompt];
        [tempNodes addObject:qPrompt];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {  // TO DO : Add a switch based on Game control Phase in here to order the click responses
    NSMutableArray *selectedCards = [[NSMutableArray alloc]init];
    if(touches.count == 1)
    {
        for(UITouch *t in touches) {
            CGPoint p = [t locationInNode:sceneNode];
            SKNode *n = [sceneNode nodeAtPoint:p];
            if(n==contBtn)
                [_actionPlayer Continue];
            if(n == confBtn && ![confBtn isHidden]) {
                // Confirm Button is shown and user pressed it - find which card is selected and call suitable routing
                for (SKNode *h in _actionPlayer.hand) {
                    if(h.position.y > DRIVER_DECK_Y) //is this one selected?
                        [selectedCards addObject:h];
                }
                //if(selectedCards.count)
                    [_actionPlayer Confirm:selectedCards];
                return;
            }
            if ([_actionPlayer.hand containsObject:n]){
                if(n.position.y > DRIVER_DECK_Y) { //Check if already selected, and put down
                    [n setPosition:CGPointMake(n.position.x, n.position.y - 50)];
                    return;
                }
                for(SKNode *h in _actionPlayer.hand) {
                    if(h == n)
                        [n setPosition:CGPointMake(n.position.x, n.position.y + 50)];
                    else
                        if(SingleCardSelectionOnly)
                            [h setPosition:CGPointMake(h.position.x, DRIVER_DECK_Y)];
                }
            }
        }
    }
}

-(void) HideConfirmationBtn:(bool)t {
    [confBtn setHidden:t];
}

-(void) HideContinueBtn:(bool)t {
    [contBtn setHidden:t];
}

-(void) UpdateLeadDraftDisplay {
    NSSortDescriptor *LDPos = [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
    if(_LeadDraftNodes.count > 0) {
        [sceneNode removeChildrenInArray:_LeadDraftNodes];
        [_LeadDraftNodes removeAllObjects];
    }
    [_LeadDraftNodes addObjectsFromArray:[gameControl players]];
    [_LeadDraftNodes sortUsingDescriptors:@[LDPos]];
    
    int n = 0;
    for(StockCarPlayer* car in _LeadDraftNodes){
        [car removeFromParent];
        [car scaleToSize:CGSizeMake(SC_CAR_WIDTH, SC_CAR_HEIGHT)];
        [car setPosition:CGPointMake(SC_LEADCAR_X + 90*n++, SC_LEADCAR_Y)];
        [sceneNode addChild:car];
    }
}


-(void) DisplayHandOfPlayer:(NSMutableArray*)hand {
//    if(!displayedHand)
//        displayedHand = [[NSMutableArray alloc]init];
//    else
//        [sceneNode removeChildrenInArray:displayedHand];
    [sceneNode removeChildrenInArray:hand];
    int n = 0;
    for(DriverCard* c in hand) {
        float xPos = DRIVER_HAND_SPACING;
        xPos *= (float)n + 1;
        xPos += DRIVER_DECK_X;
        n++;
        [displayedHand addObject:c];
        [sceneNode addChild:c];
        SKAction *m = [SKAction moveTo:CGPointMake(xPos, DRIVER_DECK_Y) duration:2.0f];
        [c runAction:m];
    }
}

-(void) InsertEvent:(TrackCard*) E{
    StockCarPlayer *NewEvent = [[StockCarPlayer alloc]init];
    [NewEvent setTexture:[E texture]];
    [NewEvent setLeadDraftPosition:0];
    if(_LeadDraftNodes.count > 0) {
        for (StockCarPlayer *p in _LeadDraftNodes)
            [p setLeadDraftPosition:[p LeadDraftPosition]+1];
    }
    [_LeadDraftNodes addObject:NewEvent];
    [NewEvent setZRotation:M_PI+M_PI/2];
    [NewEvent scaleToSize:CGSizeMake(SC_CAR_WIDTH, SC_CAR_HEIGHT)];
    
    [self UpdateLeadDraftDisplay];
}

-(void) AddToScene:(SKSpriteNode*)node {
    [sceneNode addChild:node];
}











@end
