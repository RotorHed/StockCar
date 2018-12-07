//
//  GameTable.h
//  StockCar
//
//  Created by Alan Jenkins on 12/1/18.
//  Copyright © 2018 Alan Jenkins. All rights reserved.
//

#ifndef GameTable_h
#define GameTable_h
#import "GameViewController.h"


#endif /* GameTable_h */

// Static class to represent the game table
// Expose protocols for communal area of table and player parts of table
// This class will interface with view controller as required to show data


@interface GameTable : NSObject
@property (readonly) UIViewController *gView;

@end
