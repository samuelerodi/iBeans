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
        win=[self.players[0] getTrayCount]<[self.players[1] getTrayCount];
  
        self.winner=[self.players[win] name];
        [self setDate:[NSDate date]];
        
        printf ("player1:  %d       player2:  %d\n", [self.players[0] getTrayCount], [self.players[1] getTrayCount]);
        printf("Winner is player %d", win+1);
        return 1;
    }
    
    return 0;
};

- (id) initGameWithMode:(int)mode  {
    if (self =[super init]) {
        
        [self setDate:[NSDate date]];
        [self setRound:(1)];
        self.players=[NSMutableArray new];
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

- (void) gameController: (int) flag {
    int win;
    
    //display situation
    printf("Player1\n");
    [self.players[0] printPlayerState];
    printf("\nPlayer2\n");
    [self.players[1] printPlayerState];
    printf("\n");


    
    
    //Perform basic tasks: check if there is a winner and/or change the round
    win=[self checkWinner];
    if (!win){
        if (flag) {
            [self changeRound];
        }
        else {
            printf("\ngreat! it's still your turn!\n");
        };
        [self.mainView updateButtonLabels];
        

     
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
                printf("Player1\n");
                [self.players[0] printPlayerState];
                printf("\nPlayer2\n");
                [self.players[1] printPlayerState];
                printf("\n");

                

                
                //Perform basic tasks after computer turn: check if there is a winner or change the round
                win=[self checkWinner];
                if (!win){
                    if (flag) {
                        [self changeRound];
                    }
                    else {
                    printf("\nsorry... still computer's turn!\n");
                    };
                } else  {   
                    //Case there is a winner simply returns. Game gets terminated by check winner function
                    return;};
                
                [self.mainView updateButtonLabels];
            }
        
        }
        
        else {
            NSLog(@"Error: Unknown player type. Check set of players and properties");
            return;
        };
        
     
    }
    
    //Case there is a winner simply prints and returns. Game gets terminated by check winner function.
    [self.mainView updateButtonLabels];

};

@end

