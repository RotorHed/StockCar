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
    
    if (self.Kind==HUMAN)
        [self SortHandByLaps];
    // check if crash ahead
    //AI players respond
    //Human players wait for buttons.
}

-(void) SelectedLapCards:(NSMutableArray *)selection {
    TrackCard *topTrack = [[self.Controller.TrackArea trackPhasePile]lastObject];
    switch (topTrack.flag) {
        case YELLOW:
            if([self YellowFlagChecks:selection])
                [self setPlayedLapCards:YES];
            else
                [self.Controller DNF_ForPlayer:self];
        break;
    case GREEN:
        if ([self TrackPhaseRuleCheck:selection]) {
            [self setActionsTakenThisRound:(int)selection.count];
            [self CardsDiscarded:selection];
            [self setPlayedLapCards:YES];
        }
            else
                return;
    }
    [self.Controller PlayerSubmittedLapCards];
    if(self.Kind == HUMAN) {
        [self.GameTable HideConfirmationBtn:YES];
        [self.GameTable HideContinueBtn:NO];
        [self.GameTable ShowRespondPrompt:NO Text:@" "];
    }
}

-(void) ProcessLapCard:(TrackCard*)crd {
    if(self.Kind == AI)
        [self PlaySimulation:crd Response:PASS_INSIDE];
    else
        if(self.Kind == HUMAN) {
            NSString *prompt;
            if (crd.event == CRASH) {
                self.CrashAhead = YES;
                prompt = @"CRASH AHEAD! Play any PASS or INSIDE ADVANTAGE card";
            }
            else {
                self.CrashAhead = NO;
                prompt = @"Play cards to meet Lap requirement or single Draft card";
            }
                [[self GameTable]ShowRespondPrompt:YES Text:prompt];
        }
        return;
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
    if(selectedCards.count == 1) {
        if([[selectedCards firstObject] Action] == DRAFT)
            return YES;
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
    return YES;
}
@end
