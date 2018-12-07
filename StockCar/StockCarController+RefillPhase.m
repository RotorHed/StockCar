//
//  StockCarController+RefillPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/11/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController+RefillPhase.h"
#import "StockCarController+TrackPhase.h"

@implementation StockCarController (RefillPhase)

-(void) StartRefillPhase {
    [self setPhase:REFILL];
    for (StockCarPlayer *p in [self players])
    {
        [p refillHand];
        [p RegisterContinueSelector:@selector(StartTrackPhase)];
        [p ClearCardsFromTable];
    }
    [self.gViewCont ShowRespondPrompt:NO Text:@" "];
    [self.TrackArea DiscardTrackPhaseCards];
}

-(void) FinishRefillPhase {
    return;
}
@end
