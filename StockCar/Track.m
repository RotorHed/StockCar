//
//  Track.m
//  StockCar
//
//  Created by Alan Jenkins on 9/26/17.
//  Copyright © 2017 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface Track()
- (void) ShuffleDrawPile;
@end

@implementation Track
    TrackDeckLibrary *l;

- (void) ShuffleDrawPile {
    for(int i = 0; i < 10; i++)
        for(int n=0; n <_DrawPile.count; n++){
            int swapCard = arc4random_uniform(60);
            while(swapCard == 0)
                swapCard = arc4random_uniform(60);
            [_DrawPile exchangeObjectAtIndex:n withObjectAtIndex:(swapCard)];
        }
}

-(Track*) initWithTrack:(TRACKS)t {

    l = [[TrackDeckLibrary alloc]init];
    _OneMileOval = malloc(sizeof(TRACKSETUP));
    _ShortTrack = malloc(sizeof(TRACKSETUP));
    _SuperSpeedWay = malloc(sizeof(TRACKSETUP));
    
    _SuperSpeedWay->HandSize = 7;
    _SuperSpeedWay->CardsToPlay = 3;
    _SuperSpeedWay->CardsToRefill = 3;
    _SuperSpeedWay->SizeOfDrawPile = 20;
    _SuperSpeedWay->HeatRaceLaps = 100;
    _SuperSpeedWay->FullRaceLapsMin = 160;
    _SuperSpeedWay->FullRaceLapsMax = 328;
    
    _OneMileOval->HandSize = 8;
    _OneMileOval->CardsToPlay = 4;
    _OneMileOval->CardsToRefill = 4;
    _OneMileOval->SizeOfDrawPile = 25;
    _OneMileOval->HeatRaceLaps = 125;
    _OneMileOval->FullRaceLapsMin = 250;
    _OneMileOval->FullRaceLapsMax = 400;
    
    _ShortTrack->HandSize = 9;
    _ShortTrack->CardsToPlay = 5;
    _ShortTrack->CardsToRefill = 5;
    _ShortTrack->SizeOfDrawPile = 30;
    _ShortTrack->HeatRaceLaps = 150;
    _ShortTrack->FullRaceLapsMin = 300;
    _ShortTrack->FullRaceLapsMax = 500;
    
    
    switch(t){
        case SHORT:
            _DrawPile = [[NSMutableArray alloc]initWithArray:l.ShortTrack];
            break;
        case ONE_MILE_OVAL:
        case SUPER_SPEEDWAY:
        default:
            _DrawPile = [[NSMutableArray alloc]initWithArray:l.ShortTrack];
    }
    _DiscardPile = [[NSMutableArray alloc]init];
    _trackPhasePile = [[NSMutableArray alloc]init];
    [self ShuffleDrawPile];
    return self;
}
    
-(SKSpriteNode*) TurnOverTrackCard {
    [_DiscardPile addObject:[_DrawPile lastObject]];
    [_DrawPile removeLastObject];
    return (SKSpriteNode*) _DrawPile.lastObject;
}

-(void) TrackPhaseDraw {
    [_trackPhasePile removeAllObjects];
    [_trackPhasePile addObject:[_DrawPile lastObject]];
    [_DiscardPile addObject:[_DrawPile lastObject]];
    [_DrawPile removeLastObject];
    while([[_trackPhasePile lastObject]lapsRequired] == 0) {
        [_trackPhasePile addObject:[_DrawPile lastObject]];
        [_DiscardPile addObject:[_DrawPile lastObject]];
        [_DrawPile removeLastObject];
    }
}

-(void) DiscardTrackPhaseCards {
    [_DiscardPile addObjectsFromArray:_trackPhasePile];
    [_trackPhasePile removeAllObjects];
}

-(NSMutableArray*) TrackPhaseCards {
    return _trackPhasePile;
}

-(int) LapsRequiredInCurrentPhase {
    return (int)[[_trackPhasePile lastObject]lapsRequired];
}
@end
