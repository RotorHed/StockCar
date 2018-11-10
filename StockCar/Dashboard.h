//
//  SKSpriteNode+Dashboard.h
//  StockCar
//
//  Created by Alan Jenkins on 10/12/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#define SC_DASH_X -380
#define SC_DASH_Y -10
#define SC_DASH_WIDTH 200
#define SC_DASH_HEIGHT 100
#define SC_DASH_FONT @"Times"
#define SC_DASH_TEXTSIZE 20.0f

#define SC_DASH_LEARN_X 0
#define SC_DASH_LEARN_Y 25
#define SC_DASH_GOODENG_X 150
#define SC_DASH_GOODENG_Y 25
#define SC_DASH_GOODSET_X -150
#define SC_DASH_GOODSET_Y 25
//
#define SC_DASH_BADENG_X 0
#define SC_DASH_BADENG_Y -73
#define SC_DASH_BODYDMG_X 150
#define SC_DASH_BODYDMG_Y -73
#define SC_DASH_CARTIGHT_X -150
#define SC_DASH_CARTIGHT_Y -73
//
//#define SC_DASH_HAND_X 1
//#define SC_DASH_HAND_Y 1
//#define SC_DASH_ACTIONS_X 1
//#define SC_DASH_ACTIONS_X 1
//#define SC_DASH_REFILL_X 1
//#define SC_DASH_REFILL_Y 1


@interface Dashboard : SKSpriteNode
-(Dashboard*) init;
-(void) LearnTheTrackOn:(bool)on;
-(void) GoodEngineSetting:(bool)on;
-(void) GoodCarSetup:(bool)on;

-(void) EngineTrouble:(bool)on;
-(void) BodyDamaged:(bool)on;
-(void) CarTooTight:(bool)on;

-(void) TiresAreWorn:(bool)on;

-(void) SetHandCount:(int)c Of:(int)max;
-(void) SetActionUsed:(int)used Of:(int)max;
-(void) SetRefillCount:(int)refill;
@end
