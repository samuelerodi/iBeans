//
//  Player.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//


#import "Player.h"



@implementation Player

- (id) initWithBowls {
    // instanciate an array of Bowls plus Tray within the Player  set
    if (self =[super init]) {
        
        self.name=[NSString alloc];
        if ([self isKindOfClass:[Computer class]]){
            [self setName:@"Computer"];
                            }
        else if ([self isKindOfClass:[Human class]]) {
            //NSLog(@"Insert player's name:");
            //scanf("%f", _name);
            self.name=@"human";
        };
        
        self.containers=[NSMutableArray new];
        for (int i = 1; i <= NUM_BOWLS; i++)
        {   [self.containers addObject: [[Bowl alloc] initWithPosition:i ]];
            //NSLog(@"Bowl %i of %@ has %i seeds", [self.containers[i-1] position], [self name], [self.containers[i-1] numOfSeeds]);
        };
        
        [self.containers addObject: [[Tray alloc] initWithPosition:(int) NUM_BOWLS+1 ]];
        //NSLog(@"Tray %i of %@ has %i seeds", [self.containers[NUM_BOWLS] position], [self name], [self.containers[NUM_BOWLS] numOfSeeds]);

        return self;
    }

    else return nil;
};


- (int) move:(int)pos {
    int last;
    int n_seeds;
    int currentPos;
    int nContainers;
    int opponentPos;
    
    
    
    //check for wrong input
    if (pos>NUM_BOWLS-1 || pos<0) {
        NSLog(@"Error: bowl to move from cannot be identified");
        return -1;
    };
    
    if ([self.containers[pos] numOfSeeds]==0 || [self.containers isKindOfClass:([Tray   class])]) {
        NSLog(@"Error: bowl selected contains no seeds");
        return -1;
    };
    
    
    //get number of seeds and empty selected bowl
    n_seeds=[self.containers[pos] empty];
    
    //initialize for iteration
    currentPos=pos+1;
    nContainers=(NUM_BOWLS+1)*2;
    last=0;
    for (int i = n_seeds; i>0; i--) {
        
        if (currentPos<=NUM_BOWLS) {
            //add incrementally
            [self.containers[currentPos] increment];
            
            //Display on Log current state of the game for player
            //if ([self.containers[currentPos] isKindOfClass:[Bowl class]]) {
              
                //NSLog(@"Bowl %i of %@ %i seeds", [self.containers[currentPos] position], [self name], [self.containers[currentPos] numOfSeeds]);}
            //else {
               
                //NSLog(@"Tray of %@s %i seeds", [self name], [self.containers[currentPos] numOfSeeds]);
            //};
            
                
        } else {
            //Drop in opponents'Bowls
            opponentPos=currentPos % (nContainers/2);
            [self.opponent.containers[opponentPos] increment];
            
            
            //Display on Log current state of the game for opponent
            //if ([self.opponent.containers[opponentPos] isKindOfClass:[Bowl class]]) {
                //NSLog(@"Bowl %i of %@s %i seeds", [self.opponent.containers[opponentPos] position], [self.opponent name], [self.opponent.containers[opponentPos] numOfSeeds]);}
            //else {
                //NSLog(@"Tray of %@s %i seeds", [self.opponent  name], [self.opponent.containers[opponentPos] numOfSeeds]);
            //};
        };
        last=currentPos;
        currentPos=(currentPos+1) % (nContainers);
    };
    

    return last;
};


- (int) checkBowl {
    //return 0 if it finds a non empty bowl, 1 if they are all empty and the game is over
    
    for (int i=0; i<NUM_BOWLS; i++) {
        if ([self.containers[i] numOfSeeds]!=0) {
            return 0;
        };
    };
    
    return 1;
};


- (void) computeEndMove {
    //move all the seeds of the opponents player in player's tray
    printf("\nWinner! Final move\n\n");
    
    int seeds;
    seeds=0;
    for (int i=0; i<NUM_BOWLS; i++) {
        seeds=seeds + [self.opponent.containers[i] empty];
        

    };
    [self.opponent.containers[NUM_BOWLS] addSeeds: (seeds)];


};


- (void) captureSeeds:(int)last {
    
    int opponentBowl;
    int seeds;
    
    if (last<NUM_BOWLS && [self.containers[last] isKindOfClass:[Bowl class]]) {
        opponentBowl=NUM_BOWLS-last-1;
        seeds=[self.opponent.containers[opponentBowl] empty] + [self.containers[last] empty];
        [self.containers[NUM_BOWLS] addSeeds:seeds];
        
        
        printf("capture seeds \n");

    }
    else
    {NSLog(@"Warning: Can't pick from opponent's tray");};

};




- (int) playerController: (int) choice {
    int last;
    
    //make the moke
    last=[self move:(choice)];
    
    
    //check if last seed ended in player own's bowl or tray
    if (last<=NUM_BOWLS) {
    
        //check if it ended up in one's own tray
        if ([self.containers[last] isKindOfClass:([Tray class])]) {
            return 0;
        }
        
        //check if it ended up in one's own empty bowl
        else if ([self.containers[last] isKindOfClass:([Bowl class])] && [self.containers[last] numOfSeeds]== 1) {
            [self captureSeeds:(last)];
        }
    }
    
    //flag to change round
    return 1;
};





- (int) getTrayCount {
    int count;
    
    count=[self.containers[NUM_BOWLS] numOfSeeds];
    return count;
};





- (void) printPlayerState {
    
    int i;
    for (i=0; i<=NUM_BOWLS; i++) {
        printf("%i    ", [self.containers[i] numOfSeeds] );
    }
};

@end





@implementation Human
- (int) humanController: (int) choice {
    //Get a valid input from user

    int flag;
    

    
    printf("\nHuman %s chooses bowl %li: \n", [[self name] UTF8String], (long)choice);
    
    if ((choice<1 || choice>NUM_BOWLS)|| ([self.containers[choice-1] numOfSeeds]==0)){
        printf("\nINVALID BOWL SELECTED. Choose a different bowl. ");
        return -1;
    };

    
    flag=[self playerController:(choice-1)];
    
    //flag for round change (1 - change) (0 - don't change)
    return flag;
};
@end




@implementation Computer
- (int) aiController{
    int flag;
    int choice;
    //Implement AI control
    
    choice=arc4random_uniform(NUM_BOWLS)+1;
    
    
    while ((choice<1 || choice>NUM_BOWLS)|| ([self.containers[choice-1] numOfSeeds]==0)){
        choice=arc4random_uniform(NUM_BOWLS)+1;
    };
    printf(" %d\n", choice);

    
    flag=[self playerController:(choice-1)];
    
    //flag for round change
    return flag;
};
@end
