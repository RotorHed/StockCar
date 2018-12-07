//
//  StockCarPlayer.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCarPlayer.h"
#import "StockCarPlayer+QualiPhase.h"
#import "StockCarPlayer+TrackPhase.h"
#import "StockCarController.h"
#import "StockCarController+TrackPhase.h"
#import "TrackDefs.h"

@interface StockCarPlayer()
- (void) ShuffleDrawPile;
@end

@implementation StockCarPlayer

-(StockCarPlayer*)initWithPlayer:(int)p andTable:(GameViewController*) t andController:(StockCarController*)c {
    DriverDeckLibrary *l;
    l = [[DriverDeckLibrary alloc]init:p];
    _drawPile = [[NSMutableArray alloc]initWithArray:l.deck];
    _discardPile = [[NSMutableArray alloc]init];
    _hand = [[NSMutableArray alloc]init];
    [self ShuffleDrawPile];
    
    NSString *carTex;
    switch(p) {
        case 0 :
            carTex = @"nascarYellow46";
            _Kind = HUMAN;
            break;
        case 1:
            carTex = @"nascarRed46";
            _Kind = HUMAN;
            break;
        case 2:
            carTex = @"nascarBlue46";
            _Kind = HUMAN;
            break;
    }
    
    // THIS IS A BIG DEBUG LINE - ALL PLAYERS HUMAN!!!
    _Kind = HUMAN;
    // AND THATS IT

    _Number = p;
    _LeadDraftPosition = 0;
    _InPit = NO;
    _Lapped = NO;
    _SecondsBehindLeadDraft = 0;
    _QualificationCardValue = 0;
    _CrashAhead = NO;
    
    _dde_GoodCarSetup =NO; //Increase hand size
    _dde_LearnTheTrack=NO;//Play one extra card
    _dde_GoodEngineSetting=NO; //Draw one extra card
    _dde_TwoWide=NO; //Pass outside required to pass
    
    _tde_HighInTurn=NO; //Car to right. Free pass to cars behind
    _tde_EngineTrouble=NO;//One less action per turn
    _tde_CarTooTight=NO;//Hand size reduced (next refill)
    _tde_BodyDamage=NO;//draw one less card
    _tde_TiresWorn=NO;
    
    _Controller = c;
    _GameTable = t;
    return [super initWithTexture:[SKTexture textureWithImageNamed:carTex]];
}

-(int) PositionInLeadDraft{
    return _LeadDraftPosition;
}

- (void) ShuffleDrawPile {
    for (int n=0; n<10;n++)
        for (int i = 0; i < _drawPile.count;i++) {
            int swapCard = arc4random_uniform(60);
            while(!swapCard)
                swapCard = arc4random_uniform(60);
            [_drawPile exchangeObjectAtIndex:n withObjectAtIndex:swapCard];
        }
}

- (NSMutableArray*) DrawCards {
    for(int n = 0; n < _MaxHandSize; n++) {
        int cardsToDraw = _RefillMax;
        if(!cardsToDraw)
            break;
        [_hand addObject:[_drawPile lastObject]];
        [_drawPile removeLastObject];
    }
    return _hand;
}



-(NSMutableArray*) FillHand {
    if(_drawPile.count > 0) // If not something went wrong...
        for(int n=0; n <_MaxHandSize && _hand.count < _MaxHandSize; n++) {
            [_hand addObject:[_drawPile lastObject]];
            [_drawPile removeLastObject];
        }
    return _hand;
}

-(int) countOfDrawPile {
    return (int)_drawPile.count;
}

-(DriverCard*) TopOfDiscard {
    return [_discardPile lastObject];
}

-(void) PlayCard:(DriverCard*) Card {
    [_discardPile addObject:Card];
    [_hand removeObject:Card];
}

-(void) CardsDiscarded:(NSMutableArray*)Cards {
    [_discardPile addObjectsFromArray:Cards];
    [_hand removeObjectsInArray:Cards];
}

-(void) CardDiscarded:(DriverCard*)Card {
    if(Card) {
        [_discardPile addObject:Card];
        [_hand removeObject:Card];
    }
}

-(void) DrawSingleCard {
    if(_hand.count < _MaxHandSize) {
        [_hand addObject:[_drawPile lastObject]];
        [_drawPile removeLastObject];
    }
}

-(void) DrawCardToDiscard {
    [_discardPile addObject:[_drawPile lastObject]];
    [_drawPile removeLastObject];
}

-(NSMutableArray*) PlayerHand {
    return _hand;
}

-(void) OverTakeDriver:(StockCarPlayer *)p{
    // Not using a setter, but self moves forward (closer to 1) and p drops back
    p.LeadDraftPosition++;
    self.LeadDraftPosition--;
}


-(bool) DiscardQTimeLessThan:(int)minimumTime {
    if([[_discardPile lastObject]QualiTime] < minimumTime)
        return YES;
    return NO;
}

-(int) TopDiscardQTime {
    return [[_discardPile lastObject]QualiTime];
}

// Here's where the SKSpritenode related moves go
-(void) MoveInside {
    [self setPosition:CGPointMake(self.position.x, self.position.y-80)];
}

-(void) MoveOutside {
    [self setPosition:CGPointMake(self.position.x, self.position.y+80)];
}

-(void) ClearCardsFromTable {
    [_GameTable ClearPlayerHandFromTableWithHand:self.hand andDiscards:self.discardPile];
    [_dash setHidden:YES];
}

-(void) UpdatePlayDisplay {
    if(_Kind == HUMAN) {
        //[_GameTable setActionPlayer:self];
        [_GameTable PlaceCardsInDriverDiscard:_discardPile];
        [_GameTable DisplayHandOfPlayer:_hand];
        [_GameTable UpdateDriverDeckRemaining:(int)_drawPile.count];
        
        [_Controller.pitBoard playerNumber:self.Number+1];
        [_dash SetActionUsed:self.actionsTakenThisRound Of:self.MaxActions];
        [_dash SetHandCount:(int)[self.hand count] Of:self.MaxHandSize];
        [_dash SetRefillCount:self.RefillMax];
        [_dash setHidden:NO];
    }
    //else if(_Kind == AI)
//    {
//        [_GameTable DisplayNonPlayerDiscardsForPlayer:self Cards:self.discardPile];
//    }
}

-(void) DNF {
    [self removeFromParent];
    [_GameTable UpdateLeadDraftDisplay];
}

-(void) SortHandByQTime {
        NSSortDescriptor *qualSrt = [[NSSortDescriptor alloc]initWithKey:@"QualiTime" ascending:YES];
    [_hand sortUsingDescriptors:@[qualSrt]];
    [self UpdatePlayDisplay];
}

-(void) SortHandByLaps {
    NSSortDescriptor *lapSrt = [[NSSortDescriptor alloc]initWithKey:@"lapsCompleted" ascending:YES];
    [_hand sortUsingDescriptors:@[lapSrt]];
}

-(void) SortHandByType {
    NSSortDescriptor *typSrt = [[NSSortDescriptor alloc]initWithKey:@"Type" ascending:YES];
    [_hand sortUsingDescriptors:@[typSrt]];
}

-(void) refillHand {  
    int CardsToDraw = _RefillMax;
    while(CardsToDraw-- > 0)
        [self DrawSingleCard]; // Note the DrawSingleCard functions wont draw above _MaxHandSize
    // Clear the discard pile - just to clean up the UI. May have to makes this better...
    [[self discardPile]removeAllObjects];
}

-(void) setDde_GoodCarSetup:(bool)dde_GoodCarSetup {
    _dde_GoodCarSetup = dde_GoodCarSetup;
    [_dash GoodCarSetup:dde_GoodCarSetup];
    _MaxHandSize++;
    [_dash SetHandCount:(int)_hand.count Of:_MaxHandSize];
}

-(void)setDde_LearnTheTrack:(bool)dde_LearnTheTrack {
    _dde_LearnTheTrack = dde_LearnTheTrack;
    [_dash LearnTheTrackOn:dde_LearnTheTrack];
    _MaxActions++;
    [_dash SetActionUsed:_actionsTakenThisRound Of:_MaxActions];
}

-(void) setDde_GoodEngineSetting:(bool)dde_GoodEngineSetting {
    _dde_GoodEngineSetting = dde_GoodEngineSetting;
    [_dash GoodEngineSetting:dde_GoodEngineSetting];
    _RefillMax++;
    [_dash SetRefillCount:_RefillMax];
}

-(void) setTde_CarTooTight:(bool)tde_CarTooTight {
    _tde_CarTooTight = tde_CarTooTight;
    [_dash CarTooTight:tde_CarTooTight];
    _MaxHandSize--;
    [_dash SetHandCount:(int)_hand.count Of:_MaxHandSize];
}

-(void) setTde_EngineTrouble:(bool)tde_EngineTrouble {
    _tde_EngineTrouble = tde_EngineTrouble;
    [_dash EngineTrouble:tde_EngineTrouble];
    _MaxActions--;
    [_dash SetActionUsed:_actionsTakenThisRound Of:_MaxActions];
}

-(void) setTde_BodyDamage:(bool)tde_BodyDamage {
    _tde_BodyDamage = tde_BodyDamage;
    [_dash BodyDamaged:tde_BodyDamage];
    _RefillMax--;
    [_dash SetRefillCount:_RefillMax];
}

-(void) RegisterConfirmSelector:(SEL)sel {
    [self setConfirmButtonSel:sel];
}

-(void) Confirm:(NSMutableArray *)data
{
    // Check whether its Track Phase or not.
    // Track phase = multiple cards,
    // rest are card at a time.
    if(_confirmButtonSel) {
        NSMethodSignature *sig = [self methodSignatureForSelector:_confirmButtonSel];
        if(sig == nil)
            [self performSelector:_confirmButtonSel];
        else
        {
            if(self.phase == TRACK)
                [self performSelector:_confirmButtonSel withObject:data];
            else
                [self performSelector:_confirmButtonSel withObject:[data firstObject]];
        }
    }
}

-(void) RegisterContinueSelector:(SEL)sel {
    [self setContinueButtonSel:sel];
}

-(void)Continue {
    //This is called when the continue button is pressed
    // This button should be used to have the game move to the next action.
    if(_continueButtonSel) {
        NSMethodSignature *sig = [self.Controller methodSignatureForSelector:_continueButtonSel];
        if(sig == nil)
            [_Controller performSelector:_continueButtonSel];
        else
            [_Controller performSelector:_continueButtonSel withObject:self];
    }
}
@end

