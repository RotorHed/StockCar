//
//  StockCarPlayer+ActionPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/14/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer.h"

@interface StockCarPlayer (ActionPhase)
-(void) StartPlayerActionPhase;
-(void) HandleActionSelection:(DriverCard *)c;
-(void) PassRestOfTurn;
-(void) MakeActionSelection:(TrackCard *)l Response:(DRIVERCARDACTIONS)a;
-(void) Response:(NSMutableArray *)resp;
@end
