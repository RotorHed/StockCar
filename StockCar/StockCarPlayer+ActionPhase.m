//
//  StockCarPlayer+ActionPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/14/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer+ActionPhase.h"
#import "StockCarPlayer+AI.h"
#import "StockCarController.h"
#import "StockCarController+ActionPhase.h"
#import "StockCarPlayer+AI.h"

@implementation StockCarPlayer (ActionPhase)

-(void) StartPlayerActionPhase {
    [self SortHandByType];
    [self.GameTable AllowMultipleSelectedCards:NO];
    [self RegisterConfirmSelector:@selector(HandleActionSelection:)];
    [self.GameTable HideConfirmationBtn:NO];
    [self UpdatePlayDisplay];
}

-(void) PassRestOfTurn {
    [self setPhase:WAITING];
    [self setActionRoundComplete:YES];
    [self.GameTable HideConfirmationBtn:YES];
    [self.GameTable HideContinueBtn:NO];
    [self ClearCardsFromTable];
}

-(void) MakeActionSelection:(TrackCard *)l Response:(DRIVERCARDACTIONS)a {
    // In here, we will configure UI for Human player by phase of game
    // Or, if we are AI player, call the simulation.
    // Basic Structure - switch by phase to determine action required.
    switch (self.phase) {
        case ACTION: //we are taking action
            [self.GameTable HideConfirmationBtn:NO];
            [self RegisterConfirmSelector:@selector(HandleActionSelection:)];
            [self.GameTable HideContinueBtn:YES];
            if (self.Kind == AI) {
                [self PlaySimulation:l Response:a];
                return;
            }
            [self.GameTable ShowRespondPrompt:YES Text:@"Choose Action"];
            return;
        case WAITING: // We havenet taken our action phase yet
            [self.GameTable HideConfirmationBtn:YES];
            [self.GameTable HideContinueBtn:NO];
            if(self.Kind == HUMAN)
                [self.GameTable ShowRespondPrompt:YES Text:@"Opponent Actions"];
            return;
        case RESPOND: //we must reponse to pother player action
            [self.GameTable HideConfirmationBtn:NO];
            [self RegisterConfirmSelector:@selector(Response:)];
            [self.GameTable HideContinueBtn:YES];
            if (self.Kind == AI) {
                [self RespondToPass];
                return;
            }
            [self.GameTable ShowRespondPrompt:YES Text:@"Respond to Pass Attempt"];
            return;

        default:
            return; //Shouldn't get here
    }
    // Set up UI as appropirate for play phase.
    // Ensure buttons are registered as required
}

-(bool) ActionsRemaining
{
    if(self.actionsTakenThisRound >= self.MaxActions) {
        [self.GameTable HideConfirmationBtn:YES];
        [self setActionRoundComplete:YES];
        [self RegisterConfirmSelector:@selector(PassRestOfTurn)];
        [self.GameTable ShowRespondPrompt:YES Text:@"Actions Complete - Confirm to continue..."];
        return false;
    }
    return true;
}

-(void) HandleActionSelection:(DriverCard *)c {
    
    if(c == nil || ![self ActionsRemaining]) // No card or no actions left - turn passes
    {
        [self PassRestOfTurn];
        return;
    }
    //prep for overtake?
    // Get type of card ahead - Gap, Slow traf, 2 wide
    StockCarPlayer *temp = [[self Controller]PlayerAheadOf:self];
    bool AheadIsTwoWide = [temp dde_TwoWide];
    
    switch (c.Action) {
        // These actions modify ability of player - handle local, discard and count action
        case GOOD_CAR_SETUP:
            [self setDde_GoodCarSetup:YES];
            [self CardDiscarded:c];
            self.actionsTakenThisRound++;
            [self UpdatePlayDisplay];
            break;
        case LEARN_THE_TRACK:
            [self setDde_LearnTheTrack:YES];
            [self CardDiscarded:c];
            self.actionsTakenThisRound++;
            [self UpdatePlayDisplay];
            break;
        case GOOD_ENGINE_SETTING:
            [self setDde_GoodEngineSetting:YES];
            [self CardDiscarded:c];
            self.actionsTakenThisRound++;
            [self UpdatePlayDisplay];
            break;
        case TWO_WIDE:
            [self setDde_TwoWide:YES];
            [self CardDiscarded:c];
            self.actionsTakenThisRound++;
            [self UpdatePlayDisplay];
            break;
        
        case PULL_AWAY: //Check gap ahead, then this is legal to play
            if(temp == nil || temp.Kind == GAP) {
                   [self CardDiscarded:c];
                   self.actionsTakenThisRound++;
                   [self UpdatePlayDisplay];
                   // Call Pull away function
               }
        case FAST_PIT: // Not usedin base game - do later
            [self CardDiscarded:c];
            self.actionsTakenThisRound++;
            [self UpdatePlayDisplay];
            return;
        
        // Following are overtake cards - check no gap ahead
        case PASS_TWO: //Try 2 pass insides - 1st blocked = cancel move
        case PASS_INSIDE: // Blocked by 2 wide car ahead
        case INSIDE_ADVANTAGE: // Only blocked by challenge card
            if(AheadIsTwoWide)
                return;
        case PASS_OUTSIDE: // Only card that Avoids 2 wide
            if(temp == nil || temp.Kind == GAP)
                return;
            self.actionsTakenThisRound++;
            [self CardDiscarded:c];
            [self ClearCardsFromTable];
            [[self Controller]AttemptOverTake:self withCard:c];
            return; //Wait for response now
        // These 3 players as action have are not legal - just return
        case BLOCK:
        case CHALLENGE:
        case DRAFT:
            return;
    }
    
    if ([self ActionsRemaining])
        [self UpdatePlayDisplay];
}

DriverCard *passCard;

-(void) RespondToPassAttemptWithCard:(DriverCard *)c
{
    passCard = c; //this is just to store it for a rule check later
    [self RegisterConfirmSelector:@selector(Response:)];
    self.phase = RESPOND; //Wait for Human input....
    if (self.Kind == AI)
        [self PlaySimulation:nil Response:PASS_INSIDE];
    else if(self.Kind == HUMAN) {
        if(c.Action == INSIDE_ADVANTAGE)
            [self.GameTable ShowRespondPrompt:YES Text:@"Challenge Pass attempt"];
        else
            [self.GameTable ShowRespondPrompt:YES Text:@"Block or Challenge Pass attempt"];
        [self UpdatePlayDisplay];
        [self.GameTable HideContinueBtn:YES];
        [self.GameTable HideConfirmationBtn:NO];
    }
}


-(void) Response:(DriverCard *)resp {
    if(resp != nil)
    {
        if(resp.Type == ACTION_ONLY)
        {
            [self.GameTable ShowRespondPrompt:NO Text:@" "];
            [self.GameTable ShowRespondPrompt:YES Text:@" Must play Response card, or no card to allow pass..."];
            return;
        }
        if(passCard.Action == INSIDE_ADVANTAGE)
            if(resp.Action != CHALLENGE)
                return;
    }
    [self.GameTable ShowRespondPrompt:NO Text:@" "];
    [self CardDiscarded:resp];
    [self ClearCardsFromTable];
    [self.Controller ResponseToOvertake:self WithCard:resp];
}
@end
