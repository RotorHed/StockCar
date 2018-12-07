//
//  StockCarPlayer+TrackPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/13/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer+TrackPhase.h"
#import "StockCarController.h"
#import "StockCarController+TrackPhase.h"

@implementation StockCarPlayer (TrackPhase)
-(void) StartTrackPhase {
    // self.phase = TRACK; DEPRECATED
    self.actionsTakenThisRound = 0;
    self.actionsTakenThisRound = NO;
    self.playedLapCards = NO;
    [self RegisterConfirmSelector:@selector(SelectedLapCards:)];
    [self.GameTable HideConfirmationBtn:NO];
    [self.GameTable HideContinueBtn:YES];
    
    if (self.Kind==HUMAN)
        [self SortHandByLaps];
    [self.GameTable SetConfirmBtnText:@"DNF..."];
    //Human players wait for buttons.
}

-(void) SelectedLapCards:(NSMutableArray *)selection {
    TrackCard *topTrack = [[self.Controller.TrackArea trackPhasePile]lastObject];
    
    switch (topTrack.flag) {
        case YELLOW:
            if([self YellowFlagChecks:selection])
                [self setPlayedLapCards:YES];
            else
            {
                [self.Controller DNF_ForPlayer:self];
                return; // PLAYER DNF - Probably display a prompt and button press
            }
        break;
        case GREEN:
            if ([self TrackPhaseRuleCheck:selection])
            {
                [self CardsDiscarded:selection];
                [self setPlayedLapCards:YES];
            }
            else
            {
                [self.Controller DNF_ForPlayer:self];
                return;// PLAYER DNF - Probably display a prompt and button press
            }
    }
    // Next line moved to TrackPhaseRuleCheck for DRAFT card special case
    // [self setActionsTakenThisRound:(int)selection.count];
    if(self.Kind == HUMAN) {
        [self.GameTable HideConfirmationBtn:YES];
        [self.GameTable HideContinueBtn:NO];
        [self.GameTable ShowRespondPrompt:NO Text:@" "];
        
    }
    [self ClearCardsFromTable];
    [self.Controller PlayerSubmittedLapCards];

}

-(void) ProcessLapCard:(TrackCard*)crd {
    
    [self UpdatePlayDisplay];
    if(self.Kind == AI)
        [self PlaySimulation:crd Response:PASS_INSIDE];
    else
        if(self.Kind == HUMAN) {
            NSString *prompt;
            if (crd.event == CRASH) {
                self.CrashAhead = YES;
                [self.GameTable AllowMultipleSelectedCards:NO];
                prompt = @"CRASH AHEAD! Play any PASS or INSIDE ADVANTAGE card";
            }
            else {
                self.CrashAhead = NO;
                [self.GameTable AllowMultipleSelectedCards:YES];
                prompt = @"Play cards to meet Lap requirement or single Draft card";
            }
                [[self GameTable]ShowRespondPrompt:YES Text:prompt];
        }
}

-(bool) YellowFlagChecks:(NSMutableArray *)playerCards {
    DriverCard *c;
    c = [playerCards firstObject];
    switch (c.Action) {
        case PASS_INSIDE:
        case PASS_TWO:
        case PASS_OUTSIDE:
        case INSIDE_ADVANTAGE:
            [self CardsDiscarded:playerCards];
            return YES;
        default:
            break;
    }
    return NO;
}

-(bool) TrackPhaseRuleCheck:(NSMutableArray*)selectedCards {
    int targetLaps = (int)[self.Controller.TrackArea LapsRequiredInCurrentPhase];
    int lapsPlayed = 0, n = 0;
    //Check for Draft card special case
    if(selectedCards.count == 1 && [[selectedCards firstObject]lapsCompleted] < targetLaps)
    { // First if player uses draft card with equal or more laps - its not counted as draft
        if([[selectedCards firstObject] Action] == DRAFT)
        {
            //DRAFT CARD SPECIAL CASE _ PLAYER LOSES ACTION PHASE
            [self setActionsTakenThisRound:[self MaxActions]];
            return YES;
        }
    }
    for (DriverCard *c in selectedCards) {
        lapsPlayed += [c lapsCompleted];
        n++;
        if(lapsPlayed >= targetLaps)
            break;
    }
    
    if(n != selectedCards.count) // Checking no more cards than necessary used to meet target
        return NO;
    
    if(lapsPlayed < targetLaps)
        return NO;
    [self setActionsTakenThisRound:(int)selectedCards.count];
    return YES;
}
@end
