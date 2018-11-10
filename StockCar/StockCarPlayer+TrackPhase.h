//
//  StockCarPlayer+TrackPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/13/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer.h"
#import "StockCarPlayer+AI.h"

@interface StockCarPlayer (TrackPhase)
-(void) StartTrackPhase;
-(void) ProcessLapCard:(TrackCard*)crd;
-(bool) TrackPhaseRuleCheck:(NSMutableArray*)selectedCards;
-(bool) YellowFlagChecks:(NSMutableArray *)playerCards;
@end
