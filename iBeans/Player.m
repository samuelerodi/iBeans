//
//  Player.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#define NUM_BOWLS (int) 6
#import "Container.h"
#import "Player.h"

@implementation Player

- (id) initWithBowlsAndOpponent: (Player*) user {
    // instanciate an array of Bowls plus Tray within the Player  set
    if (self =[super init]) {
    
        for (int i = 1; i <= NUM_BOWLS; i++)
        {   [self.containers addObject: [[Bowl alloc] initWithPosition:(int) i ]];
        };
        
        [self.containers addObject: [[Tray alloc] initWithPosition:(int) NUM_BOWLS+1 ]];
        self.opponent=user;
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
    
    last=0;
    
    //check for wrong input
    if (pos>NUM_BOWLS-1) {
        NSLog(@"Error: bowl to move from cannot be identified");
        return 0;
    };
    
    
    //get number of seeds and empty selected bowl
    n_seeds=[self.containers[pos] empty];
    
    //initialize for iteration
    currentPos=pos;
    nContainers=(NUM_BOWLS+1)*2;
    
    for (int i = n_seeds; i>0; i--) {
        
        if (self.containers[currentPos]) {
            
            //add incrementally 
            [self.containers[currentPos] increment];
        } else {
            //Drop in opponents'Bowls
            opponentPos=currentPos % (nContainers/2);
            [self.opponent.containers[opponentPos] increment];
        };
        last=currentPos;
        currentPos=(currentPos+1) % (nContainers);
    };

    return last;
};



- (int) checkBowl {
    //return 0 if it finds a non empty bowl, 1 if they are all empty and the game is over
    
    for (int i=0; i<NUM_BOWLS; i++) {
        if (![self.containers[i] numOfSeeds]) {
            return 0;
        };
    };
    
    return 1;
};


- (void) computeEndMove {
    //move all the seeds to the opponents player in player's tray
    int seeds;
    seeds=0;
    for (int i=0; i<NUM_BOWLS; i++) {
        seeds=seeds + [self.opponent.containers[i] empty];
    };
    [self.containers[NUM_BOWLS] addSeeds: (seeds)];

};


@end

@implementation Human
- (void) initWithName {
    self.name=@"Human";
};
@end

@implementation Computer
- (void) initWithName {
    self.name=@"Computer";
};
@end
