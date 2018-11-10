//
//  StockCarController.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCarPlayer+AI.h"
#import "StockCarPlayer+ActionPhase.h"
#import "StockCarController.h"
#import "StockCarController+QualificationPhase.h"
#import "StockCarController+TrackPhase.h"
#import "StockCarController+ActionPhase.h"


@implementation StockCarController

- (StockCarController*) init {
    _players = [[NSMutableArray alloc]init];
    _pitBoard = [[Pitboard alloc]init];
    _phase = SETUP;
    _YellowFlag = NO;
    return self;
}

- (StockCarController*) initWithGameViewController:(GameViewController*)g {
    _gViewCont = g;
    return self.init;
}

-(void) TrackInUse:(TRACKS)t{
    _TrackTypeInUse = t;
    _TrackArea = [[Track alloc]initWithTrack:t];
    [self SetPlayerRules];
}

-(int) TrackDeckCount {
    return (int)_TrackArea.DrawPile.count;
}

-(TRACKS) TrackType {
    return _TrackTypeInUse;
}

-(void) AddPlayerWithID:(int)p {
    // ONLY ONE HUMAN PLAYER SUPPORTED.... CHANGE
    // Use mulitple scenes or views or something for different players?
    [_players addObject:[[StockCarPlayer alloc]initWithPlayer:p andTable:self.gViewCont andController:self]];
    if(p==0)
        [_gViewCont setActionPlayer:_players[p]];
}

-(void) SetPlayerRules {
    // Go through the players and initialise them with Hand constraints based on selected track
    TRACKSETUP *tData;
    switch(_TrackTypeInUse){
        case SHORT:
            tData = _TrackArea.ShortTrack;
            break;
        case ONE_MILE_OVAL:
            tData = _TrackArea.OneMileOval;
            break;
        case SUPER_SPEEDWAY:
            tData = _TrackArea.SuperSpeedWay;
            break;
        default:
            tData = _TrackArea.ShortTrack;
    }
    
    for (int n = 0; n < _players.count; n++){
        [_players[n] setMaxHandSize:tData->HandSize];
        [_players[n] setMaxActions:tData->CardsToPlay];
        [_players[n] setRefillMax:tData->CardsToRefill];
    }
}


-(GAME_PHASE) CurrentGamePhase {
    return _phase;
}

-(SKSpriteNode*) GetNextTrackCard {
    return (SKSpriteNode*) _TrackArea.TurnOverTrackCard;
}

-(void) PlayerInteractionWithSelectedCard:(DriverCard*)selection {
    
    bool flag;
    
    switch(_phase) {
        case SETUP:
            break;
        case QUALI: // All players call this function - we only want to proceed when all players have chosen

           break;
            
        case TRACK:
            if([[self.TrackArea.trackPhasePile lastObject] flag] == YELLOW)
                [self ProcessTrackCards:[self DrawTrackCards]];
            else
                [self FinishTrackPhase];
            // Check cards submitted meet track requirement - no more than one extra card. Reduce Maxactions as required.
            break;
        case ACTION: 
            break;
        case REFILL: // Cards are refilled already by the time we get here - any click returns us to track phase
            [self StartTrackPhase];
            break;
        case RESET:
            break;
    }
}



-(void) DNF_ForPlayer:(StockCarPlayer*)p {
    // remove car from grid (leave gap i guess
    [_players removeObject:p];
    [_gViewCont UpdateLeadDraftDisplay];
}

-(StockCarPlayer*) LowestQTimeTurnover {
    NSMutableArray *ord = [[NSMutableArray alloc]init];
    NSSortDescriptor *QualSort =  [[NSSortDescriptor alloc]initWithKey:@"QualiTime" ascending:YES];
    for(StockCarPlayer* p in self.players) {
        [p DrawCardToDiscard];
        [ord addObject:[p TopOfDiscard]];
    }
    
    [ord sortUsingDescriptors:@[QualSort]];
    int lowestQTime = [[ord firstObject]QualiTime];
    NSMutableArray *playersTemp = [[NSMutableArray alloc]init];
    [playersTemp addObjectsFromArray:_players];
    
    for(StockCarPlayer *p in playersTemp)
    {
        if([p TopDiscardQTime]==lowestQTime)
            return p;
    }

    return [playersTemp firstObject];
}

-(StockCarPlayer*)NextPlayer {
    
    NSMutableArray *lst = [[NSMutableArray alloc]init];
    for(StockCarPlayer* p in self.players)
        if([p actionRoundComplete] == NO)
            [lst addObject:p];
    
    if(lst.count == 0)
        return nil;
    
    int HighestQTime = 0;
    StockCarPlayer *nextPlayer = [lst firstObject];
    for(StockCarPlayer *p in lst)
        if([p TopDiscardQTime] > HighestQTime) {
            HighestQTime = [p TopDiscardQTime];
            nextPlayer = p;
        }
    // probably should consdier ties in this search
    return nextPlayer;
}

-(void) SetPhaseForAllPlayersTo:(GAME_PHASE)ph {
    self.phase = ph;
    for (StockCarPlayer *p in _players)
        [p setPhase:ph];
}

@end
