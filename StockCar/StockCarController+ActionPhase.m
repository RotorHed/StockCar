//
//  StockCarController+ActionPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController+ActionPhase.h"
#import "StockCarPlayer.h"
#import "StockCarController+RefillPhase.h"
#import "StockCarPlayer+AI.h"
#import "StockCarPlayer+ActionPhase.h"

@implementation StockCarController (ActionPhase)

-(void) StartActionPhase {
    [self SetPhaseForAllPlayersTo:WAITING];
    [self.gViewCont AllowMultipleSelectedCards:NO];
    [self.gViewCont HideConfirmationBtn:YES];
    
    self.actionPlayer = nil;
    
    for(StockCarPlayer *p in self.players) {
        [p StartPlayerActionPhase];
        [p RegisterContinueSelector:@selector(ContinueActionPhase)];
    }
        

    self.actionPlayer = [self NextPlayer];
    [self.actionPlayer setPhase:ACTION];

    //Choose players in the right order. Top Quali card value I think
    // They get control of the UI and choose action(s) or pass
    
//    if(self.actionPlayer.Kind == AI)
//        [self HandleActionPlayWithCard:[self.actionPlayer PlaySimulation:self.phase Laps:0 Response:PASS_INSIDE]];
    
    // Scoot through lead draft until we hit the human player
    // Each AI player will just pass for now
    // Start with driver with highest time on top discard
    // Each player only gets one action phase...
    
    // while!Player Passed/No action cards remain/No more actions available
    // Player chooses ACTION card or pass
    // While !Actions all handled
    // Assess effect of action - who is being "attacked"
    // Attacked player may choose RESPONSE or pass
    // Apply response logic if reponse selected
    // Carry out original action if it succeeded
    // Do next action if multiple actions on card
}

-(void) ContinueActionPhase {
        [self.actionPlayer MakeActionSelection:nil Response:PASS_INSIDE];
}


-(void) ActionPhaseDoneBy:(StockCarPlayer *)p {
    [p setActionRoundComplete:YES];
    self.actionPlayer = [self NextPlayer];
    if(!self.actionPlayer)
        [self FinishActionPhase]; //Everybody done
    else {
        [self.actionPlayer setPhase:ACTION];
        [self.actionPlayer RegisterContinueSelector:@selector(ContinueActionPhase)];
        [self.actionPlayer StartPlayerActionPhase];
    }
}

-(void) SortPlayersByLeadDraft {
    NSSortDescriptor *LeadSort =  [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
    [self.players sortUsingDescriptors:@[LeadSort]];
}

-(void) TrimTrailingEvents {
    // Cleans up any slow car or Gap cards that get to the end of the lead draft
    [self SortPlayersByLeadDraft]; // belt and braces to make sure we don't accidently delete wrong thing
    StockCarPlayer *lastPlayer = [self.players lastObject];
    while (lastPlayer.Kind != AI && lastPlayer.Kind != HUMAN) {
        [self.players removeObject:lastPlayer];
        lastPlayer = [self.players lastObject];
    }
}

-(void) PullAwayPlayedBy:(StockCarPlayer *)p {
    //Pull away can only be played by leading driver or driver with GAP ahead
    // if Gap ahead - pass it, otherwise create a new gap
    StockCarPlayer *inFront = [self PlayerAheadOf:p];
    if(inFront.Kind == GAP)
    { [p setLeadDraftPosition:p.LeadDraftPosition - 1];
        [inFront setLeadDraftPosition:p.LeadDraftPosition +1];
        [self SortPlayersByLeadDraft];
        [self TrimTrailingEvents];
    }
    else
        [self InsertGapAfter:p];
        
    // First pull away always work in that situation. Create a "GAP" card
    // recurse players behind for Draft card play.
    // Set Confirm button for Human.
    // Draft card played is simple overtake of GAP by the player.
    // If GAP is last on the player list, trim it off.
}

-(void) RespondToPullAwayBy:(StockCarPlayer *)p withCard:(DriverCard *)c {
    
}

-(void) InsertGapAfter:(StockCarPlayer *)targetCar {
    StockCarPlayer *gap = [[StockCarPlayer alloc]initWithPlayer:5 andTable:self.gViewCont andController:self];
    [gap setKind:GAP];
    [gap setLeadDraftPosition:[targetCar PositionInLeadDraft]+1];
    SKTexture *gapCar = [SKTexture textureWithImageNamed:@"nascarBlue46.png"];
    [gap setTexture:gapCar];
    [gap setZRotation:2*M_PI];
    [gap scaleToSize:CGSizeMake(SC_CAR_WIDTH, SC_CAR_HEIGHT)];
//    NSSortDescriptor *LDPos = [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:YES];
    for(StockCarPlayer *p in self.players)
        if ([p LeadDraftPosition] >= [gap LeadDraftPosition])
            [p setLeadDraftPosition:[p LeadDraftPosition]+1];
    [self.players addObject:gap];
    [self.gViewCont AddToScene:gap];
}


-(StockCarPlayer*)PlayerAheadOf:(StockCarPlayer *)p {
    // Sort players into LeadDraft Order, find the player, and return the thing in front
    [self SortPlayersByLeadDraft];
    StockCarPlayer *prev = Nil;
    for (StockCarPlayer *c in self.players)
        if(c == p)
            return prev;
        else
            prev = c;
    return nil;
}

-(StockCarPlayer*)PlayerTrailing:(StockCarPlayer *)p {
    // Sort players into LeadDraft Order, find the player, and return the thing in front
    NSSortDescriptor *LeadSort =  [[NSSortDescriptor alloc]initWithKey:@"LeadDraftPosition" ascending:NO];
    [self.players sortUsingDescriptors:@[LeadSort]];
    StockCarPlayer *prev = Nil;
    for (StockCarPlayer *c in self.players)
        if(c == p)
            return prev;
        else
            prev = c;
    return nil;
}

-(void) AttemptOverTake:(StockCarPlayer *)p withCard:(DriverCard *)c {
    StockCarPlayer *target = [self PlayerAheadOf:p];

    if(target.Kind == SLOW_CAR || target.Kind == CRASH)
    {   target.LeadDraftPosition--;
        p.LeadDraftPosition++;
        [self TrimTrailingEvents]; // Clear off Gaps and Crashes that are cleared
        [self.gViewCont UpdateLeadDraftDisplay];
        return;
    }
    [target setPhase:RESPOND];
    [target RespondToPass];
    self.actionPlayer = p; //This should already be set but just in case
}

-(void) ResponseToOvertake:(StockCarPlayer *)t WithCard:(DriverCard*)c {
    [t setPhase:WAITING];
    [self CompleteOvertakeBy:self.actionPlayer on:t withResponseCard:c];
}

-(void) CompleteOvertakeBy:(StockCarPlayer *)p on:(StockCarPlayer *)t withResponseCard:(DriverCard*)response {

    if(response) //Target played a response card
        switch (response.Action) {
            case BLOCK:
                return;
            case CHALLENGE: {
                [p DrawCardToDiscard];
                [t DrawCardToDiscard];
                while ([p TopDiscardQTime] == [t TopDiscardQTime]) {
                    [p DrawCardToDiscard];
                    [t DrawCardToDiscard];
                }
                
                if([p TopDiscardQTime] < [t TopDiscardQTime]) {
                    return; // otherwise we drop out of here and do the overtake
                }
                break;
            }
            default:
                break;
        }
    // No response played or failed challenge by blocker - auto overtake
    t.LeadDraftPosition++;
    p.LeadDraftPosition--;
    [self.gViewCont UpdateLeadDraftDisplay];
}

-(void) AttemptPullAwayBy:(StockCarPlayer *)p {
    bool drafts = [[self PlayerTrailing:p]DraftsPullAway];
    if(drafts)
        [self AttemptPullAwayBy:[self PlayerTrailing:p]];
}

            
-(void) FinishActionPhase {
    [self.gViewCont HideConfirmationBtn:YES];
    [self.gViewCont HideContinueBtn:NO];
    for (StockCarPlayer *p in self.players)
        [p RegisterContinueSelector:@selector(StartRefillPhase)];
}



@end
