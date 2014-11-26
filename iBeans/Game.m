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
    //returns 1 if there is a winner, 0 otherwise.
    
    int player1flag;
    int player2flag;
    int win;
 //   NSString *myString;
    
    player1flag=[self.players[0] checkBowl];
    player2flag=[self.players[1] checkBowl];
    
    if (player1flag || player2flag) {
        //Game over
        [self.players[player2flag] computeEndMove];
        win=[self.players[0] getTrayCount]>=[self.players[1] getTrayCount];
  
        self.winner=[self.players[win] name];
        [self setDate:[NSDate date]];
        
        return 1;
    }
    
    return 0;
};

- (id) initGameWithMode:(int)mode  {
    if (self =[super init]) {
        
        [self setDate:[NSDate date]];
        [self setRound:(0)];

        switch (mode) {
            case 0:
                [self.players addObject:[[Human alloc] initWithBowls]];
                [self.players addObject:[[Human alloc] initWithBowls]];
                break;
            case 1:
                 [self.players addObject:[[Human alloc] initWithBowls]];
                 [self.players addObject:[[Computer alloc] initWithBowls]];
                break;
            case 2:
                [self.players addObject:[[Computer alloc] initWithBowls]];
                [self.players addObject:[[Computer alloc] initWithBowls]];
                break;
                
            default:
                NSLog(@"Error: Game mode must be either 0 (HvsH), 1 (HvsC) or 2 (CvsC)");
                return nil;
                break;
                 };
                 
                 [self.players[0] setOpponent: self.players[1]];
                 [self.players[1] setOpponent: self.players[0]];

    return self;
    }
    else return nil;
};

- (void) gameController {
    int flag;
    
    while (![self checkWinner]) {
    
    
        if ([self.players[[self round]] isKindOfClass:[Human class]]) {
            flag=[self.players[[self round]] humanController];
        }
        else if ([self.players[[self round]] isKindOfClass:[Computer class]]) {
            flag=[self.players[[self round]] aiController];
        }
        else {
            NSLog(@"Error: Unknown player type. Check set of players and properties");
            return;
        }
    
        if (flag) {
            [self changeRound];
        };
    };
    
    
    
    
};

@end
