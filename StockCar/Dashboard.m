//
//  SKSpriteNode+Dashboard.m
//  StockCar
//
//  Created by Alan Jenkins on 10/12/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "Dashboard.h"

@implementation Dashboard {
    SKLabelNode *learnTheTrack, *goodEngineSetup, *goodCarSetup;
    SKLabelNode *tiresWorn, *bodyDamage, *carTooTight, *engineTrouble;
    SKLabelNode *hand, *actions, *refill;
    UIColor *green, *yellow, *blue, *grey;
}

-(Dashboard*) init {
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"SCDashboard.png"]];
    if(self) {
        //SKTexture *dashTex = [SKTexture textureWithImageNamed:@"SCDashboard.png"];
        grey = [[UIColor alloc]initWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        green = [[UIColor alloc]initWithRed:0 green:1 blue:0 alpha:1];
        yellow = [[UIColor alloc]initWithRed:1 green:1 blue:0 alpha:1];
        blue = [[UIColor alloc]initWithRed:0.7 green:0.7 blue:1 alpha:1];
        
        
        learnTheTrack = [[SKLabelNode alloc] initWithFontNamed:SC_DASH_FONT];
        [learnTheTrack setFontSize:SC_DASH_TEXTSIZE];
        [learnTheTrack setNumberOfLines:2];
        [learnTheTrack setPosition:CGPointMake(SC_DASH_LEARN_X,SC_DASH_LEARN_Y)];
        [learnTheTrack setFontColor:grey];
        [learnTheTrack setText:@"Track \nLearned"];
        [self addChild:learnTheTrack];
        
        goodCarSetup = learnTheTrack.copy;
        [goodCarSetup setNumberOfLines:2];
        [goodCarSetup setText:@"Good \nSetup"];
        [goodCarSetup setPosition:CGPointMake(SC_DASH_GOODSET_X,SC_DASH_GOODSET_Y)];
        [self addChild:goodCarSetup];
        
        goodEngineSetup = learnTheTrack.copy;
        [goodEngineSetup setNumberOfLines:2];
        [goodEngineSetup setText:@"Good \nEngine"];
        [goodEngineSetup setPosition:CGPointMake(SC_DASH_GOODENG_X,SC_DASH_GOODENG_Y)];
        [self addChild:goodEngineSetup];
        
  
        
        bodyDamage = learnTheTrack.copy;
        [bodyDamage setNumberOfLines:2];
        [bodyDamage setPosition:CGPointMake(SC_DASH_BODYDMG_X, SC_DASH_BODYDMG_Y)];
        [bodyDamage setText:@"Body\nDamaged"];
        [self addChild:bodyDamage];
        
        engineTrouble = learnTheTrack.copy;
        [engineTrouble setNumberOfLines:2];
        [engineTrouble setPosition:CGPointMake(SC_DASH_BADENG_X, SC_DASH_BADENG_Y)];
        [engineTrouble setText:@"Engine\nDamaged"];
        [self addChild:engineTrouble];
        
        carTooTight = learnTheTrack.copy;
        [carTooTight setNumberOfLines:2];
        [carTooTight setPosition:CGPointMake(SC_DASH_CARTIGHT_X, SC_DASH_CARTIGHT_Y)];
        [carTooTight setText:@"Car\nTight"];
        [self addChild:carTooTight];
        
        
//        tiresWorn = learnTheTrack.copy;
//        [tiresWorn setText:@"Tires\nWorn"];
//        [self addChild:tiresWorn];
        
        
        hand = learnTheTrack.copy;
        [hand setPosition:CGPointMake(SC_DASH_GOODSET_X, -5)];
        [hand setFontColor:blue];
        [hand setText:@"H : 0"];
        [self addChild:hand];
        
        actions = hand.copy;
        [actions setPosition:CGPointMake(0, -5)];
        [actions setText:@"A : 0/0"];
        [self addChild:actions];
        
        refill = hand.copy;
        [refill setPosition:CGPointMake(SC_DASH_GOODENG_X,-5)];
        [refill setText:@"R : 0"];
        [self addChild:refill];

        
        [self setPosition:CGPointMake(SC_DASH_X, SC_DASH_Y)];
        [self scaleToSize:CGSizeMake(SC_DASH_WIDTH, SC_DASH_HEIGHT)];
    }
    return self;
}

-(void) LearnTheTrackOn:(bool)on{
    if(on)
        [learnTheTrack setFontColor:green];
    else
        [learnTheTrack setFontColor:grey];
}

-(void) GoodEngineSetting:(bool)on
{
    if(on)
        [goodEngineSetup setFontColor:green];
    else
        [goodEngineSetup setFontColor:grey];

}

-(void) GoodCarSetup:(bool)on{
    if(on)
        [goodCarSetup setFontColor:green];
    else
        [goodCarSetup setFontColor:grey];

}

-(void) TiresAreWorn:(bool)on{
    if(on)
        [tiresWorn setFontColor:yellow];
    else
        [tiresWorn setFontColor:grey];
}

-(void) BodyDamaged:(bool)on{
    if(on)
        [bodyDamage setFontColor:yellow];
    else
        [bodyDamage setFontColor:grey];

}

-(void)EngineTrouble:(bool)on {
    if(on)
        [engineTrouble setFontColor:yellow];
    else
        [engineTrouble setFontColor:grey];
    
}

-(void) CarTooTight:(bool)on{
    if(on)
        [carTooTight setFontColor:yellow];
    else
        [carTooTight setFontColor:grey];

}

-(void) SetHandCount:(int)c Of:(int)max{
    NSString *s = [NSString stringWithFormat:@"H : %i/%i", c,max];
    [hand setText:s];
}

-(void) SetActionUsed:(int)used Of:(int)max{
    NSString *s = [NSString stringWithFormat:@"A : %i / %i", used, max];
    [actions setText:s];
}

-(void) SetRefillCount:(int)r{
    NSString *s = [NSString stringWithFormat:@"R : %i", r];
    [refill setText:s];
}
@end
