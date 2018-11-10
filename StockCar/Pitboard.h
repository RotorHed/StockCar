//
//  Pitboard.h
//  StockCar
//
//  Created by Alan Jenkins on 10/15/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#ifndef Pitboard_h
#define Pitboard_h
#import <SpriteKit/SpriteKit.h>

@interface Pitboard : SKSpriteNode
@property (atomic) SKLabelNode *letterP;
@property (atomic) SKLabelNode *letterP1;
@property (atomic) SKLabelNode *letterP2;
@property (atomic) SKLabelNode *letterL;
@property (atomic) SKLabelNode *letterL1;
@property (atomic) SKLabelNode *letterL2;
@property (atomic) SKLabelNode *letterL3;
@property (atomic) SKLabelNode *letterN;
@property (atomic) SKLabelNode *letterN1;
@property (atomic) SKLabelNode *letterN2;
@property (atomic) SKLabelNode *genText;

-(void) playerNumber:(int)num;
-(void) lapsRemain:(int)laps;
@end

#endif /* Pitboard_h */
