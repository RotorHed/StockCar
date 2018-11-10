//
//  StockCarController+TrackPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController.h"

@interface StockCarController (TrackPhase)
-(void) StartTrackPhase;
-(NSMutableArray*) DrawTrackCards;
-(void)ProcessTrackCards:(NSMutableArray*)cards;
-(void) FinishTrackPhase;
-(void) AddSlowTraffic:(TrackCard*)E;
-(void) PlayerSubmittedLapCards;
-(void) AISubmitsLapCards;
@end
