//
//  StockCarController+TrackPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCarController+TrackPhase.h"
#import "StockCarPlayer+AI.h"
#import "StockCarController+QualificationPhase.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarController+ActionPhase.h"
#import "StockCarPlayer+TrackPhase.h"
#import "StockCarController+RefillPhase.h"

@implementation StockCarController (TrackPhase)
NSMutableArray *TrackPhasePlayQ, *TrackCardsInPlay;

-(void) StartTrackPhase {
    
    [self SetPhaseForAllPlayersTo:TRACK];
    [self setGrooveOutside:NO];
    if([self raceFinished]) //check whether the race is over
        return; // TODO: Call end of game screen and clean up

    [self.gViewCont HideConfirmationBtn:NO];
    [self.gViewCont SetConfirmBtnText:@"DNF"];
    [self.gViewCont HideContinueBtn:YES];
    [self.gViewCont AllowMultipleSelectedCards:YES];
    
// Select track cards first
    // This could be 1 or more depending on event cards
    TrackCardsInPlay = [[NSMutableArray alloc]initWithArray:[self DrawTrackCards]];
    
    // For each track card now in play, cycle through each player to let them respond to the card - event, laps etc
     [self ProcessTrackCards:TrackCardsInPlay];
}

-(NSMutableArray*) DrawTrackCards {
    [self.TrackArea TrackPhaseDraw]; //Draws until a card is found with lap count
    NSMutableArray *lapCards = [self.TrackArea TrackPhaseCards];
    //[[self.TrackArea TrackPhaseCards]removeAllObjects];
    self.LapsCompleted += (int)[[lapCards lastObject]lapsRequired];
    [self.gViewCont PlaceInTrackDiscard:lapCards];
    [self.gViewCont UpdateTrackDeckRemaining:(int)[self.TrackArea DrawPile].count];
    return lapCards;
}


-(void) DNFCheckPlayers {
    bool dnf_Happened = YES;
    while(dnf_Happened){
        dnf_Happened = NO;
        for(StockCarPlayer* p in self.players) {
            [p DrawCardToDiscard];
            if([p DiscardQTimeLessThan:SC_MINTIME]) {
                [self DNF_ForPlayer:p];
                dnf_Happened = YES;
                break;
            }
        }
    }
}

-(void) LoseTraction:(StockCarPlayer*)p {
    //This block seems like it does nothing...
//    NSMutableArray* leadDraft = [[NSMutableArray alloc]init];
//        NSSortDescriptor *QualSort =  [[NSSortDescriptor /alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
 //   [leadDraft sortedArrayUsingDescriptors:@[QualSort]];
    
    
    NSSortDescriptor *LeadSort =  [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
    [self.players sortUsingDescriptors:@[LeadSort]];
    int posModifier = 0;
    for(StockCarPlayer *n in self.players)
    {
        [p setLeadDraftPosition:(n.LeadDraftPosition - posModifier)]; //No change until finding the affected player
        if(n == p)
        {
            [p setLeadDraftPosition:(int)[self.players count]];
            posModifier = 1;
        }
    }
    [self.players sortUsingDescriptors:@[LeadSort]];
}

-(void) AddSlowTraffic:(TrackCard*)E {
    StockCarPlayer *slowT = [[StockCarPlayer alloc] init];
    SKTexture *tex = [SKTexture textureWithImageNamed:@"RedButton"];
    [slowT setTexture:tex];
    [slowT setLeadDraftPosition:1];
    [slowT setKind:SLOW_CAR];
    //[slowT setZRotation:M_PI+M_PI/2];
    [slowT scaleToSize:CGSizeMake(SC_CAR_WIDTH, SC_CAR_HEIGHT)];
    for (StockCarPlayer *p in self.players)
        [p setLeadDraftPosition:p.LeadDraftPosition+1];
    [self.players addObject:slowT];
    
    [slowT setHidden:NO];
    [self.gViewCont UpdateLeadDraftDisplay];
}

-(void) ProcessTrackCards:(NSMutableArray*)cards {
    
    StockCarPlayer* affected_Player;
    [self setYellowFlag:NO];
    
    //Following code deals with track effects that potentially affect player's by card draw
    // Lap cards and the yellow flag crash card are handled by the player objects themselves
    while([[TrackCardsInPlay firstObject]event] != CRASH &&
          [[TrackCardsInPlay firstObject]event] != NONE  &&
          [[TrackCardsInPlay firstObject]event] != GROOVE_OUT)
    {
        TrackCard * c = [TrackCardsInPlay firstObject];
        [TrackCardsInPlay removeObject:c];
        
        switch([c event])
        {
            case BRAKES:
                for (StockCarPlayer* p in self.players)
                {
                    [p DrawCardToDiscard];
                    if([p DiscardQTimeLessThan:SC_MINTIME])
                        [self DNF_ForPlayer:p];
                }
                break;
            case SLOW_TRAFFIC:
                [self AddSlowTraffic:c];
                break;
            case HIGH_IN_TURN:
                affected_Player = [self LowestQTimeTurnover];
                [affected_Player setTde_HighInTurn:YES];
                break;
            case LOSE_TRACTION_2s:
            case LOSE_TRACTION_4s:
                affected_Player = [self LowestQTimeTurnover];
                [self LoseTraction:affected_Player];
                break;
            case ENGINE_TROUBLE:
                affected_Player = [self LowestQTimeTurnover];
                [affected_Player setTde_EngineTrouble:YES];
                break;
            case TIRES_WORN:
                affected_Player = [self LowestQTimeTurnover];
                [affected_Player setTde_TiresWorn:YES];
                break;
            case BODY_DMG:
                affected_Player = [self LowestQTimeTurnover];
                [affected_Player setTde_BodyDamage:YES];
                break;
            case CAR_TOO_TIGHT:
                affected_Player = [self LowestQTimeTurnover];
                [affected_Player setTde_CarTooTight:YES];
                break;
                // Cars behind get to overtake with no card
            case NONE:
                break;
            case TRANSMISSION:
            case BLOWN_ENG:
            case OVERHEAT:
                [self DNFCheckPlayers];
                self.YellowFlag = YES;
                break;
        }
    }
    
    // Following are LAP cards - they end the track phase.
    if(self.YellowFlag) // It was a yellow flag event but not crash
    {// in this case there is no action phase - players all made the lap count and we start a new track phase
        [self FinishTrackPhase];
        return;
    }
    
    if([[TrackCardsInPlay firstObject]event] == GROOVE_OUT)
        [self setGrooveOutside:YES];
    
    if([[TrackCardsInPlay firstObject]event] == CRASH) {
            [self CrashOnTrack:[TrackCardsInPlay firstObject]];
        }
    
    if(!self.YellowFlag) // Not a transmission, Blown Eng or Overheat
    {
        TrackPhasePlayQ = [[NSMutableArray alloc]initWithArray:self.players];
        for (StockCarPlayer *p in TrackPhasePlayQ)
            if(p.Kind == SLOW_CAR || p.Kind == SHUNT)
                [TrackPhasePlayQ removeObject:p];
        [self PlayerSubmittedLapCards]; //This just kicks off the the player wait for anser loop
    }
}

-(void) CrashOnTrack:(TrackCard*)c {
    // Move crash card to lead draft position
    // Texture copy?
    StockCarPlayer *crashCard = [[StockCarPlayer alloc]init];
    SKTexture *tex = c.texture.copy;
    [crashCard setTexture:tex];
    [crashCard scaleToSize:CGSizeMake(SC_CAR_HEIGHT, SC_CAR_WIDTH)];
    [crashCard setZRotation:M_PI + M_PI/2];
    [crashCard setPosition:CGPointMake(SC_LEADCAR_X, SC_LEADCAR_Y)];
    [crashCard setLeadDraftPosition:0];
    [crashCard setKind:SHUNT];
    [[self players]addObject:crashCard];
    self.YellowFlag = TRUE; // this is also a yellow flag event
//    [self.gViewCont AddToScene:crashCard];
    [self.gViewCont UpdateLeadDraftDisplay];
    // Each player in lead draft order should play a pass card.
}

-(void) PlayerSubmittedLapCards {
    if ([TrackPhasePlayQ count] != 0)
    {
        do {
        self.actionPlayer = [TrackPhasePlayQ firstObject];
        [TrackPhasePlayQ removeObject:self.actionPlayer];
        } while (self.actionPlayer.Kind != HUMAN &&
                 self.actionPlayer.Kind != AI);
        
        [self.pitBoard playerNumber:(self.actionPlayer.Number+1)];
        [self.actionPlayer StartTrackPhase];
        [self.actionPlayer ProcessLapCard:[TrackCardsInPlay firstObject]];
    }
    else
        [self FinishTrackPhase];
}


-(void) FinishTrackPhase {
    [self.gViewCont ShowRespondPrompt:NO Text:@" "];
    
    if(self.YellowFlag)
    {
        [self.gViewCont SetContinueBtnText:@"YELLOW FLAG!"];
        for(StockCarPlayer *p in self.players)
            [p RegisterContinueSelector:@selector(StartRefillPhase)];
    }
    else
        for(StockCarPlayer *p in self.players)
            [p RegisterContinueSelector:@selector(StartActionPhase)];
    
    [self.gViewCont HideContinueBtn:NO];
    [self.gViewCont HideConfirmationBtn:YES];

    [self.pitBoard lapsRemain:[self.TrackArea FullRaceLapsRequirement] -
      self.LapsCompleted];
}


-(bool) raceFinished {
    // TODO - Complete the proper rac length checks for each track type
    return self.LapsCompleted >= 150; //Short track min limit/2
}
@end
