//
//  StockCarController+TrackPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController+TrackPhase.h"
#import "StockCarPlayer+AI.h"
#import "StockCarController+QualificationPhase.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarController+ActionPhase.h"
#import "StockCarPlayer+TrackPhase.h"
#import "StockCarController+RefillPhase.h"

@implementation StockCarController (TrackPhase)
-(void) StartTrackPhase {
    
    [self SetPhaseForAllPlayersTo:TRACK];
    [self setGrooveOutside:NO];
    if([self raceFinished]) //check whether the race is over
        return; // TODO: Call end of game screen and clean up

    for(StockCarPlayer* p in self.players)
        [p StartTrackPhase];
    
    // TO DO : Decide how to deal with track cards - select then call each player to respond?
    // AI players can be automatic - human must wait for input again
     [self ProcessTrackCards:[self DrawTrackCards]];
}

-(NSMutableArray*) DrawTrackCards {
    [self.TrackArea TrackPhaseDraw];
    NSMutableArray *lapCards = [self.TrackArea TrackPhaseCards];
    //[[self.TrackArea TrackPhaseCards]removeAllObjects];
    self.LapsCompleted += (int)[[lapCards lastObject]lapsRequired];
    [self.gViewCont PlaceInTrackDiscard:lapCards];
    [self.gViewCont UpdateTrackDeckRemaining:(int)[self.TrackArea DrawPile].count];
    
    [self.gViewCont HideConfirmationBtn:NO];
    [self.gViewCont HideContinueBtn:YES];
    [self.gViewCont AllowMultipleSelectedCards:YES];
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
    NSMutableArray* leadDraft = [[NSMutableArray alloc]init];
        NSSortDescriptor *QualSort =  [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
    [leadDraft sortedArrayUsingDescriptors:@[QualSort]];
    [self.players removeObject:p];
    [self.players addObject:p]; //just remove and re-add affected player to end of lead draft
    int n = 1;
    for(StockCarPlayer *c in self.players) //reorder based on new players order
        [c setLeadDraftPosition:n++];
}

-(void) AddSlowTraffic:(TrackCard*)E {
    StockCarPlayer *slowT = [[StockCarPlayer alloc] init];
    SKTexture *tex = [SKTexture textureWithImageNamed:@"RedButton"];
    [slowT setTexture:tex];
    [slowT setLeadDraftPosition:1];
    [slowT setKind:SLOW_CAR];
    //[slowT setZRotation:M_PI+M_PI/2];
    //[slowT scaleToSize:CGSizeMake(SC_CAR_WIDTH, SC_CAR_HEIGHT)];
    for (StockCarPlayer *p in self.players)
        [p setLeadDraftPosition:p.LeadDraftPosition+1];
    [self.players addObject:slowT];
    
    [slowT setHidden:NO];
    [self.gViewCont UpdateLeadDraftDisplay];
}

-(void) ProcessTrackCards:(NSMutableArray*)cards {
    
    StockCarPlayer* affected_Player;
    [self setYellowFlag:NO]; // Not sure if this is important anymore ???
    
    //Following code deals with track effects that potentially affect player's by card draw
    // Lap cards and the yellow flag crash card are handled by the player objects themselves
    for(TrackCard * c in cards)
        switch([c event]) {
            case BRAKES:
                for (StockCarPlayer* p in self.players)
                {
                    [p DrawCardToDiscard];
                    if([p DiscardQTimeLessThan:SC_MINTIME])
                        [self DNF_ForPlayer:p];
                }
                for(StockCarPlayer *p in self.players)
                    [p RegisterContinueSelector:@selector(StartRefillPhase)];
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
            case CRASH:
                [self CrashOnTrack:c];
                [self setLapsCompleted:(int)c.lapsRequired];
                break;
            case GROOVE_OUT:
                [self setGrooveOutside:YES];
                // Cars behind get to overtake with no card
            case NONE:
                break;
            case TRANSMISSION:
            case BLOWN_ENG:
            case OVERHEAT:
                [self DNFCheckPlayers];
                self.YellowFlag = YES;
                for(StockCarPlayer *p in self.players)
                    [p RegisterContinueSelector:@selector(StartRefillPhase)];
                [self.gViewCont HideContinueBtn:NO];
                [self.gViewCont HideConfirmationBtn:YES];
                break;
    }
    
    // Following is default Lap card response.
    //Only Human players first
    for(StockCarPlayer *p in self.players)
    {
        if(p.Kind == HUMAN || p.Kind == AI) // avoid other event types acting
            [p ProcessLapCard:[cards lastObject]];
    }
    
    return;
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
//    [self.gViewCont AddToScene:crashCard];
    [self.gViewCont UpdateLeadDraftDisplay];
    // Each player in lead draft order should play a pass card.
}

-(void) PlayerSubmittedLapCards {
    // Called when a player submits cards through UI.
    // Player object akready checks for rules acceptance
    // Here we just invoke AI players and either Finish the track phase or
    // draw more cards if it was a yellow flag
    // Then get the AI players to choose lap cards.
    for(StockCarPlayer *p in self.players)
        if(!p.playedLapCards) // If this happens we just wait until al players done
            return; // Just stop here until all players have chosen.
    
    [self FinishTrackPhase];
}

-(void) AISubmitsLapCards {

}

-(void) FinishTrackPhase {
    [self.gViewCont ShowRespondPrompt:NO Text:@" "];
    
    if([[[self.TrackArea DiscardPile]lastObject]flag] == YELLOW)
        for(StockCarPlayer *p in self.players)
            [p RegisterContinueSelector:@selector(StartRefillPhase)];
    else
        for(StockCarPlayer *p in self.players)
            [p RegisterContinueSelector:@selector(StartActionPhase)];
    
    [self.gViewCont HideContinueBtn:NO];
    [self.gViewCont HideConfirmationBtn:YES];
    [self.pitBoard lapsRemain:self.LapsCompleted];
}


-(bool) raceFinished {
    // TODO - Complete the proper rac length checks for each track type
    return self.LapsCompleted >= 150; //Short track min limit/2
}




@end
