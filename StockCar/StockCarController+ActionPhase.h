//
//  StockCarController+ActionPhase.h
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController.h"

@interface StockCarController (ActionPhase)
-(void) StartActionPhase;
//-(void) HandleActionPlayWithCard:(NSMutableArray*)selection;
//-(void) HandleResponseWithCard:(NSMutableArray*)selection ByPlayerInLD:(int)p;
-(void) FinishActionPhase;
-(void) InsertGapAfter:(StockCarPlayer *)LeadDraftPosition;
-(StockCarPlayer *) PlayerAheadOf:(StockCarPlayer *)p;
-(void) AttemptOverTake:(StockCarPlayer *)p withCard:(DriverCard *)c;
-(void) ActionPhaseDoneBy:(StockCarPlayer *)p;
-(void) CompleteOvertakeBy:(StockCarPlayer *)p on:(StockCarPlayer *)t withResponseCard:(DriverCard*)response;
-(void) ResponseToOvertake:(StockCarPlayer *)t WithCard:(DriverCard*)c;
-(void) ContinueActionPhase;
@end
