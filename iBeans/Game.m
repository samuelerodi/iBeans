//
//  Game.m
//  iBeans
//
//  Created by Sam on 11/25/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import "Game.h"



@implementation Game

- (void) changeRound: (BOOL) flag {
    if (!flag) {
        self.round=self.round;
    }
    else {
        
        if (self.round==0) {
            self.round=1;
        } else if (self.round==1) {
            self.round=0;
        }
        else
        {NSLog(@"fatal error with round! Not recognized round integer");
        }
    }
};

- (int) checkWinner {
    //returns 1 if there is a winner, 0 otherwise.
    
    int player1flag;
    int player2flag;
    //   NSString *myString;
    
    player1flag=[self.players[0] checkBowl];
    player2flag=[self.players[1] checkBowl];
    
    if (player1flag || player2flag) {
        //Game over
        [self.players[player2flag] computeEndMove];
        self.win=[self.players[0] getTrayCount]<[self.players[1] getTrayCount];
        
        self.winner=[self.players[self.win] name];
        self.loser=[self.players[!self.win] name];
        [self setDate:[NSDate date]];
        self.finalScore=[self.players[self.win] getTrayCount];
        
        printf ("player1:  %d       player2:  %d\n", [self.players[0] getTrayCount], [self.players[1] getTrayCount]);
        printf("Winner is player %d\n\n", self.win+1);
        [self setHasWinner:true];
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
        
        
        //Set players name and AILevel
        self.defaults = [NSUserDefaults standardUserDefaults];
        if ([self.players[0] isKindOfClass:([Human class])]) {
            NSString *player1 = [self.defaults stringForKey:(@"player1Name")];
            [self.players[0] setName:player1];
        }
        if ([self.players[1] isKindOfClass:([Human class])]) {
            NSString *player2 = [self.defaults stringForKey:(@"player2Name")];
            [self.players[1] setName:player2];
        }
        if ([self.players[0] isKindOfClass:([Computer class])]) {
            NSNumber *aiLevel1 = [self.defaults objectForKey:(@"aiLevel")];
            [self.players[0] setAiLevel:[aiLevel1 doubleValue]];
        }
        if ([self.players[1] isKindOfClass:([Computer class])]) {
            NSNumber *aiLevel2 = [self.defaults objectForKey:(@"aiLevel")];
            [self.players[1] setAiLevel:[aiLevel2 doubleValue]];
        }
        
        
        [self setHasWinner:false];
        
        return self;
    }
    else return nil;
};

- (void) gameController: (int) flag {
    int win;
    
    //display situation
    [self printGameSituation];
    
    if ([self.players[self.round] captured]) {
        if ([self.players[self.round] isKindOfClass:([Human class])]) {
            self.captureSeeds=1;
        }
        else if ([self.players[self.round] isKindOfClass:([Computer class])]){
            
            self.captureSeeds=2;
        }
    }


    //Perform basic tasks: check if there is a winner and/or change the round
    win=[self checkWinner];
    if (!win){
        if (flag) {
            [self changeRound:true];
        }
        else {
            [self changeRound:false];
            self.stillYourTurn=1;
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
                
                if ([self.players[self.round] captured]) {
                    if ([self.players[self.round] isKindOfClass:([Human class])]) {
                        self.captureSeeds=1;
                    }
                    else if ([self.players[self.round] isKindOfClass:([Computer class])]){
                        
                        self.captureSeeds=2;
                    }
                }
                
                //display situation
                [self printGameSituation];
                
                
                
                
                //Perform basic tasks after computer turn: check if there is a winner or change the round
                win=[self checkWinner];
                if (!win){
                    if (flag) {
                        [self changeRound:true];
                    }
                    else {
                        [self changeRound:false];
                        self.stillYourTurn=2;
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

