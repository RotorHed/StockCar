//
//  GameTableCommunal.h
//  StockCar
//
//  Created by Alan Jenkins on 12/1/18.
//  Copyright © 2018 Alan Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GameTableCommunal <NSObject>
-(void) UpdateLeadDraftDisplay;
-(void) DiscardTrackCards;
-(void) PlaceEventCardOnTrack;
-(void) DrawLapCard;
@end

NS_ASSUME_NONNULL_END
