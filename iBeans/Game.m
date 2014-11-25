//
//  Game.m
//  iBeans
//
//  Created by Sam on 11/25/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#import "Player.h"
#import "Game.h"

@implementation Game

- (void) changeRound {
    self.round++;
    self.round=self.round % 2;
};

- (int) checkWinner {
    //returns 1 if there us a winner, 0 otherwise.
    
    int player1flag;
    int player2flag;
    int win;
 //   NSString *myString;
    
    player1flag=[self.players[0] checkBowl];
    player2flag=[self.players[1] checkBowl];
    
    if (player1flag || player2flag) {
        //Game over
        win=[self.players[0] getTrayCount]>=[self.players[1] getTrayCount];
  
        
        //     myString=[self.players[win] name];
 //       [self setWinner:(NSString @myString)];

        
        [self setDate:[NSDate date]];
        
        
        
        return 1;
    }
    
    return 0;
};

@end
