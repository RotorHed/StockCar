//
//  StockCarPlayer+AI.h
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#ifndef StockCarPlayer_AI_h
#define StockCarPlayer_AI_h

#import <Foundation/Foundation.h>
#import "StockCarPlayer.h"

@interface StockCarPlayer (StockCarPlayerWithAI)
-(void) PlaySimulation:(TrackCard *)l Response:(DRIVERCARDACTIONS)a;
-(NSMutableArray *) RespondedToCrashAhead;
-(bool) DraftsPullAway;
-(void) RespondToPass;
-(void) HideTopDiscard:(bool)f;
@end

#endif /* StockCarPlayer_AI_h */
