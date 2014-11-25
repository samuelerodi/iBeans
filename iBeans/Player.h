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


@end

@interface Human : Player
@end

@interface Computer : Player
@end