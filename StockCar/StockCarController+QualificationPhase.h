//
//  StockCarController+QualificationPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCarController.h"


@interface StockCarController (QualificationPhase)
- (void) StartQualificationPhase;
- (void) FinishQualificationPhase;
- (void) PlayerSubmitsQualCard;
@end
