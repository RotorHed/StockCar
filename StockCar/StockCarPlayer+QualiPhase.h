//
//  StockCarPlayer+QualiPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/13/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer.h"
#import "StockCarController.h"
#import "StockCarController+QualificationPhase.h"

@interface StockCarPlayer (QualiPhase)
- (void) StartQualificationPhase;
- (void) FinishQualificationPhaseWithCard:(DriverCard *)c;
@end
