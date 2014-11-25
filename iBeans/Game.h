//
//  Game.h
//  iBeans
//
//  Created by Sam on 11/25/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#import "Player.h"
#import <Foundation/Foundation.h>

@interface Game : NSObject
@property (nonatomic) NSMutableArray *players;
@property (nonatomic) int round;
@property (nonatomic) NSString *winner;
@property (nonatomic) NSDate *date;

- (id) initGameWithMode: (int) mode;
- (int) checkWinner;
- (void) changeRound;
- (void) gameController;

@end
