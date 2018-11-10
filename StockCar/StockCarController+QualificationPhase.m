//
//  StockCarController+QualificationPhase.m
//  StockCar
//
//  Created by Alan Jenkins on 10/8/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import "StockCarController+QualificationPhase.h"
#import "StockCarController.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarPlayer+AI.h"
#import "StockCarPlayer+QualiPhase.h"

@implementation StockCarController (QualificationPhase)

- (void) StartQualificationPhase {
    // Move to Quali Phase
    [self SetPhaseForAllPlayersTo:QUALI];
    [self.gViewCont AddToScene:self.pitBoard];
    self.actionPlayer = self.players.firstObject;

    [self.pitBoard playerNumber:self.actionPlayer.Number];
    [self.pitBoard lapsRemain:300];
    [self.actionPlayer StartQualificationPhase];


    // The follwing places the track deck on the table - this doesnt seem like the right place to do that....
    [self.gViewCont PlaceTrackDeck];
    [self.gViewCont UpdateTrackDeckRemaining:(int)[self.TrackArea DrawPile].count];
    

    [self.gViewCont ShowQualificationPrompt:YES];
    [self.gViewCont AllowMultipleSelectedCards:NO];
    [self.gViewCont HideConfirmationBtn:NO];

}


-(void) PlayerSubmitsQualCard {
    
    // 10 NOV 2018 REFACTOR -  Trying to remove AI/Auto play for now. Need to decide how to show players hands - crash due to not clearing down the cards from the GameViewController node list before disaplying different cards.
    
    // This function is called by each player object to register the card is played
    // Function will only call the Finish Phase function when all players submitted a card
    
    bool flag = YES; //has everyone played a quali card? Assume yes
    // In order to get the AI to choose cards after the player, the following loop will call AI players for quali cards
    for(StockCarPlayer *p in self.players)
        if(p.QualificationCardValue==0) {
            flag = NO; //Still wiaitng for someone
            self.actionPlayer = p;
            [self.pitBoard playerNumber:self.actionPlayer.Number];
            [self.pitBoard lapsRemain:300];
            [self.gViewCont PlaceDriverDeck];
            [self.gViewCont UpdateDriverDeckRemaining:(int)[self.actionPlayer drawPile].count];
            [self.gViewCont DisplayHandOfPlayer:[self.actionPlayer PlayerHand]];
            
            [self.actionPlayer StartQualificationPhase];
        }
    
    if(flag) { //everyone played a card
        [self.gViewCont HideConfirmationBtn:YES];
        [self FinishQualificationPhase];
    }
}

-(void) FinishQualificationPhase {

    [self GridOrder];
    
    [self.gViewCont ShowQualificationPrompt:NO];
    
    for (StockCarPlayer *p in self.players) {
        if(p.Kind == AI)
            [p HideTopDiscard:NO];
        [p RegisterContinueSelector:@selector(StartTrackPhase)];
    }
}

-(void) GridOrder {
    //Need to handle the situation of 2 similar speed values being played...Properly!
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc]initWithKey:@"QualificationCardValue" ascending:NO];
    [self.players sortUsingDescriptors:@[sortDes]];
    bool tied = NO;
    for(int n = 0;n < self.players.count - 1; n++) {
            while([self.players[n] QualificationCardValue] ==
                  [self.players[n+1] QualificationCardValue])
            {
                [self.players[n] DrawCardToDiscard];
                [self.players[n] setQualificationCardValue:[[self.players[n] TopOfDiscard] QualiTime]];
                [self.players[n+1] DrawCardToDiscard];
                [self.players[n+1] setQualificationCardValue:[[self.players[n+1] TopOfDiscard] QualiTime]];
                tied = YES;
            }
    }
    if(tied)
          [self.players sortUsingDescriptors:@[sortDes]];
    
    for(StockCarPlayer *p in self.players)
        [p setLeadDraftPosition:(int)[self.players indexOfObject:p]+1];
    
    [self setActionPlayer:[self NextPlayer]];
    [self.gViewCont UpdateLeadDraftDisplay];
}
@end
