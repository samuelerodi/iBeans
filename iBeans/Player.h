//
//  Player.h
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import "Game.h"
#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic, strong) NSMutableArray *containers;
@property (nonatomic, weak) Player *opponent;

- (id) initWithBowlsAndOpponent: (Player*) user ;
- (int) move: (int) pos;
- (int) checkBowl;
- (void) computeEndMove;
- (void) captureSeeds: (int) last;
- (int) getTrayCount;

//player controller returns 1 if change round is necessary, or 0 if it is not
- (int) playerController: (int) choice;


@end

@interface Human : Player
- (int) humanController;
@end

@interface Computer : Player
@property (nonatomic) int level;
- (int) aiController;
@end