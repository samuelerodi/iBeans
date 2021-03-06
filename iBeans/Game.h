//
//  Game.h
//  iBeans
//
//  Created by Sam on 11/25/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#import "Player.h"
#import <Foundation/Foundation.h>
#define NUM_BOWLS (int) 6


@interface Game : NSObject
@property (nonatomic) NSMutableArray *players;
@property (nonatomic) int round;
@property (nonatomic) NSString *winner;
@property (nonatomic) NSString *loser;
@property (nonatomic) NSDate *date;
@property (nonatomic) int win;
@property (nonatomic) int gameMode;
@property (nonatomic) int finalScore;
@property (nonatomic) BOOL hasWinner;
@property (nonatomic,weak) NSUserDefaults *defaults;
@property (nonatomic) int stillYourTurn;
@property (nonatomic) int captureSeeds;

- (id) initGameWithMode: (int) mode;
- (int) checkWinner;
- (void) changeRound: (BOOL) flag;
- (void) gameController: (int) flag;
- (int) setGameSituation: (int[]) seedsPosition andSize: (int) arraySize;
- (void) printGameSituation;

@end
