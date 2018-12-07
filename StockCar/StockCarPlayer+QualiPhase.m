//
//  StockCarPlayer+QualiPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/13/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarPlayer.h"
#import "StockCarPlayer+AI.h"
#import "StockCarPlayer+QualiPhase.h"


@implementation StockCarPlayer (QualiPhase)
- (void) StartQualificationPhase {
    
    [self FillHand];
    [self SortHandByQTime];
    [self RegisterConfirmSelector:@selector(FinishQualificationPhaseWithCard:)];
    self.dash = [[Dashboard alloc]init];
    [self.dash SetHandCount:(int)self.hand.count Of:self.MaxHandSize];
    [self.dash SetActionUsed:0 Of:self.MaxActions];
    [self.dash SetRefillCount:self.RefillMax];
    [self.GameTable AddToScene:(SKSpriteNode*)self.dash];
    [self UpdatePlayDisplay];
    
    [self.GameTable AllowMultipleSelectedCards:NO];
    [self.GameTable HideConfirmationBtn:NO];
    
    // Now wait for user card selection - FinishQualificationPhaseWithCard
}

-(void) FinishQualificationPhaseWithCard:(DriverCard *)c {
    if(!c)
        return; // No card selected so wait here
    [self setQualificationCardValue:c.QualiTime];
    [self CardDiscarded:c];
    [self DrawSingleCard]; // replace the quali card
    [self ClearCardsFromTable];
    [self.Controller PlayerSubmitsQualCard];
}
@end
