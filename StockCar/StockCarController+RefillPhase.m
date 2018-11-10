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
        [p refillHand];
    [self.TrackArea DiscardTrackPhaseCards];
    
    for (StockCarPlayer *p in self.players)
        [p RegisterContinueSelector:@selector(StartTrackPhase)];
}

-(void) FinishRefillPhase {
    return;
}
@end
