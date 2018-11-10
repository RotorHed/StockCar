//
//  StockCarPlayer+AI.m
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCarPlayer+AI.h"
#import "StockCarPlayer.h"
#import "StockCarController.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarController+ActionPhase.h"

@implementation StockCarPlayer (StockCarPlayerWithAI)

-(DriverCard*) RespondToAction:(DRIVERCARDACTIONS)a {
    DriverCard *response = nil;
    
    switch (a) {
        case PASS_INSIDE:
        case PASS_TWO:
        case PASS_OUTSIDE:
            for (DriverCard *c in self.hand)
                if([c Action]  == BLOCK || ([c Action] == CHALLENGE && !self.tde_TiresWorn)) {
                    response=c;
                    [self CardDiscarded:response];
                    break;
                }
            break;
        case INSIDE_ADVANTAGE:
            for (DriverCard *c in self.hand)
                if([c Action] == CHALLENGE && !self.tde_TiresWorn) {
                    response=c;
                    [self CardDiscarded:response];
                    break;
                }
            break;
        case PULL_AWAY:
            for (DriverCard *c in self.hand)
                if([c Action]  == DRAFT) {
                    response = c;
                    [self CardDiscarded:response];
                    break;
                }
            break;
        default:
            break;
    }
    [self UpdatePlayDisplay];
    return response;
}

-(NSMutableArray*) TakeAIAction {
    // Group Action cards
    //check if crash ahead, if so play pass card, then - HANDLED AT TRACK PHASE
    // Must handle slow card ahead - play any pass card
    // check actions left - Action increase card if available then
    // Check if gap ahead/leading race if so - play pull away if available otherwise, quit, then
    // If player card ahead - check if 2 wide or other special conditions
    // Choose pass card
    //if available play 2 wide on self
    // play "good cards" on self - learn the track etc
    NSMutableArray *acts = [[NSMutableArray alloc]init];
    NSMutableArray *selectedAction = [[NSMutableArray alloc]init];
    StockCarPlayer *pAhead = [self.Controller PlayerAheadOf:self];
    for(DriverCard *c in self.hand)
        if(c.Type == ACTION_ONLY)
            [acts addObject:c];
    
    if (pAhead == nil || pAhead.Kind == GAP) // this car is leading or gap in front - try to make gap
        for(DriverCard *c in acts)
            if(c.Action == PULL_AWAY) {
                [selectedAction addObject:c];
                return selectedAction;
            }
    
    // look for upgrade cars to play
    for (DriverCard *c in acts)
        if(c.Action == GOOD_CAR_SETUP || c.Action == GOOD_ENGINE_SETTING || c.Action == LEARN_THE_TRACK)
        {
            [selectedAction addObject:c];
            return selectedAction;
        }
            
    // Need to check if we are first player or last - maybe function on stock controller to return how players have already played action round. Play 2 wide if players left to go
    
    
    // If we get here, ahead is a slow car card or player so just try and pass it.
    // Pass insde first, then follow up with more powerful.
    for (DriverCard *c in acts)
        if (c.Action == PASS_INSIDE) {
            [selectedAction addObject:c];
            return selectedAction;
        }
            // If we got here - there wasn't a pass inside. Choose the first other pass type
    for (DriverCard *c in acts)
            if (c.Action == PASS_OUTSIDE || c.Action == PASS_TWO || c.Action == INSIDE_ADVANTAGE) {
                [selectedAction addObject:c];
                break;
            }
    return selectedAction;
}

-(void) PlaySimulation:(TrackCard *)l Response:(DRIVERCARDACTIONS)a {
    int randomCard = arc4random_uniform((uint)self.hand.count);
    NSMutableArray *selectedCrds = [[NSMutableArray alloc]init];
    DriverCard *r;
    
    switch(self.phase) {
        case SETUP:
            break;
        case QUALI:
            [selectedCrds addObject:[self.hand objectAtIndex:randomCard]];
            self.QualificationCardValue = [selectedCrds[0] QualiTime];
            [self CardsDiscarded:selectedCrds];
            [self DrawSingleCard]; // replace the quali card
            [self UpdatePlayDisplay];
            [self HideTopDiscard:YES];
            break;
        case TRACK:
            if(l.event == CRASH)
                selectedCrds = [self RespondedToCrashAhead];
            [selectedCrds addObjectsFromArray:[self FulfillLaps:(int)l.lapsRequired]];
            [self UpdatePlayDisplay];
            break;
            // Need to add up track cards to make the lap count required
        case RESPOND:
            r = [self RespondToAction:a];
            if (r)
                [self Confirm:[selectedCrds firstObject]];
            return;
        case ACTION:
            if(self.actionsTakenThisRound < self.MaxActions)
                selectedCrds = [self TakeAIAction];
            else
                [self RegisterConfirmSelector:@selector(PassRestOfTurn)];
            break;// empty - we'll catch that in action phase
        case REFILL:
            break;
        case RESET:
            break;
    }

    [self Confirm:selectedCrds];
}

-(NSMutableArray *) FulfillLaps:(int)l {
    NSSortDescriptor *lapSort =  [[NSSortDescriptor alloc]initWithKey:@"lapsCompleted" ascending:YES];
    [self.hand sortUsingDescriptors:@[lapSort]];
    NSMutableArray *lapCards = [[NSMutableArray alloc]init];
    int lapSum = 0;
    int highCards = 0;
    
    if(arc4random_uniform(10) > 5) { // Randomly decide whether to add highest available lap card first
        [lapCards addObject:[self.hand lastObject]];
        lapSum = [lapCards[0] lapsCompleted];
        highCards++;
    }
    
    int n = 0;
    while(lapSum < l && n < self.hand.count - highCards) { //Now if the previous action didnt meet lap require, starting adding lower value cards
        [lapCards addObject:self.hand[n++]];
        lapSum += [lapCards.lastObject lapsCompleted];
    }
    
    if(lapCards.count > self.MaxActions) { //OK Too Many cards used to make lap count
        // Remove current lapCard choices, and try again counting from highest to lowest
        [lapCards removeAllObjects];
        lapSum = 0;
        n =(int) self.hand.count-1;
        while(lapSum < l && n >= 0){
            [lapCards addObject:self.hand[n--]];
            lapSum += [lapCards.lastObject lapsCompleted];
        }
    }
    if(lapCards.count > self.MaxActions) // Still didn't make it counting highest cards first
    { // See if we have a draft card
        [lapCards removeAllObjects];
        for(int n=0; n < self.hand.count; n++)
            if([self.hand[n] Action] == DRAFT) {
                [lapCards addObject:self.hand[n]];
                break;
            }
    }
    
    // Final check that we only used minimum number of lapCards to achieve count required.
    DriverCard *draftCard = nil;
    if(lapCards.count > 1) { // check we actually made it to the laps required and more than one card
        lapSum = 0;
        n =(int) lapCards.count;
        [lapCards sortUsingDescriptors:@[lapSort]];
        while (lapSum < l){
            // The following is in case a draft card is chosen. Just return that card and forget the rest
            if ([lapCards[--n] Action] == DRAFT) {
                draftCard = lapCards[n];
            }
            lapSum += [lapCards[n] lapsCompleted];
        }
        
        if (n+1 < lapCards.count) // Too many cards used - trim extras
            [lapCards removeObjectsInRange:NSMakeRange(0, n)];
    }
    
    if(draftCard) {
        [lapCards removeAllObjects];
        [lapCards addObject:draftCard];
    }

    // Final final check that if we use more than one card - if we have a draft card in the list, use that card by itself.
    
    return lapCards;
}

-(NSMutableArray *) RespondedToCrashAhead {
    // Find the first pass card and discard it for now to stay in the race.
    NSMutableArray *discard = [[NSMutableArray alloc]init];
    for(DriverCard *c in self.hand)
    {
        switch(c.Action){
            case PASS_INSIDE:
            case PASS_TWO:
            case PASS_OUTSIDE:
            case INSIDE_ADVANTAGE:
                [discard addObject:c];
                [self CardsDiscarded:discard];
            default:
                break;
        }
    }
    return discard;
}

-(bool) DraftsPullAway {
    for(DriverCard *c in [self hand])
        if(c.Action == DRAFT) {
            [self CardDiscarded:c];
            return YES;
        }
    return NO;
}

-(void) HideTopDiscard:(bool)f {
        [[self.discardPile firstObject]setHidden:f];
}

-(void) LapsFulfilled {
    [self.Controller AISubmitsLapCards];
}

@end





























