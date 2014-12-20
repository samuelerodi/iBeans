//
//  Game.m
//  iBeans
//
//  Created by Sam on 11/25/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

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
        win=[self.players[0] getTrayCount]<[self.players[1] getTrayCount];
        
        self.winner=[self.players[win] name];
        [self setDate:[NSDate date]];
        
        printf ("player1:  %d       player2:  %d\n", [self.players[0] getTrayCount], [self.players[1] getTrayCount]);
        printf("Winner is player %d\n\n", win+1);
        return 1;
    }
    
    return 0;
};

- (id) initGameWithMode:(int)mode  {
    if (self =[super init]) {
        
        [self setDate:[NSDate date]];
        [self setRound:(1)];
        [self setGameMode:mode];
        self.players=[NSMutableArray new];
        switch (mode) {
            case 0:
                
                [self.players addObject:[[Human alloc] initWithPlayerNumber:0]];
                [self.players addObject:[[Human alloc] initWithPlayerNumber:1]];
                break;
            case 1:
                [self.players addObject:[[Human alloc] initWithPlayerNumber:0]];
                [self.players addObject:[[Computer alloc] initWithPlayerNumber:1]];
                break;
            case 2:
                [self.players addObject:[[Computer alloc] initWithPlayerNumber:0]];
                [self.players addObject:[[Computer alloc] initWithPlayerNumber:1]];
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

- (void) gameController: (int) flag {
    int win;
    
    //display situation
    [self printGameSituation];
    
    
    //Perform basic tasks: check if there is a winner and/or change the round
    win=[self checkWinner];
    if (!win){
        if (flag) {
            [self changeRound];
        }
        else {
            printf("great! it's still your turn!\n\n");
        };
        
        
        
        
        //if next turn is a human turn, then break execution and wait for human controller trigger
        if ([self.players[[self round]] isKindOfClass:[Human class]]) {
            return;
        }
        
        //if next turn is a computer turn, then call AI untill the turn is back to human or the game is over
        else if ([self.players[[self round]] isKindOfClass:[Computer class]]) {
            
            while (!win && [self.players[[self round]] isKindOfClass:[Computer class]]) {
                
                
                //Call computer AI controller
                printf("\n\nComputer %i chooses ", ([self round]+1));
                flag=[self.players[[self round]] aiController];
                
                //display situation
                [self printGameSituation];
                
                
                
                
                //Perform basic tasks after computer turn: check if there is a winner or change the round
                win=[self checkWinner];
                if (!win){
                    if (flag) {
                        [self changeRound];
                    }
                    else {
                        printf("sorry... still computer's turn!\n\n");
                    };
                } else  {
                    //Case there is a winner simply returns. Game gets terminated by check winner function
                    return;};
                
                
            }
            
        }
        
        else {
            NSLog(@"Error: Unknown player type. Check set of players and properties");
            return;
        };
        
        
    }
    
    //Case there is a winner simply prints and returns. Game gets terminated by check winner function.
    
    
};

- (int) setGameSituation:(int [])seedsPosition andSize:(int)arraySize {
    //Returns 1 if operation gets correctly performed, 0 otherwise.
    
    int player;
    int container;
    int temp;
    
    if (arraySize!=[[self.players[0] containers] count]+[[self.players[1] containers] count]) {
        NSLog(@"Error: Array specified of incompatible size. Check array dimensions");
        [self printGameSituation];
        return 0;
    }
    for (int i=0; i<arraySize; i++) {
        //check validity of the array
        if (seedsPosition[i]<0)
        {
            NSLog(@"Error: Array specified of incompatible type or value. Check array dimensions");
            [self printGameSituation];
            return 0;
        };
    }
    
    for (int i=0; i<arraySize; i++) {
        player=i/(NUM_BOWLS+1);
        container=i %(NUM_BOWLS+1);
        temp=seedsPosition[i];
        [[self.players[player] containers][container] setNumOfSeeds:temp];
    };
    
    NSLog(@"New configuration correctly set");
    [self printGameSituation];
    return 1;
    
};


- (void) printGameSituation {
    //Display on Log GameSituation
    printf("Player1\n");
    [self.players[0] printPlayerState];
    printf("\nPlayer2\n");
    [self.players[1] printPlayerState];
    printf("\n\n");
};

@end

