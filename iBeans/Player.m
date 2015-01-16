//
//  Player.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//


#import "Player.h"



@implementation Player

- (id) initWithPlayerNumber: (int) playerNum {
    
    int start_pos;
    // instanciate an array of Bowls plus Tray within the Player  set
    if (self =[super init]) {
        
        self.name=[NSString alloc];
        if ([self isKindOfClass:[Computer class]]){
            [self setName:@"Computer"];
        }
        else if ([self isKindOfClass:[Human class]]) {

            self.name=@"Human";
        };
        
        self.containers=[NSMutableArray new];
        
        if (playerNum==0) {
            start_pos = 1;
        } else if (playerNum==1) {
            start_pos=NUM_BOWLS+2;
            
        } else
        {   return 0;
        }
        
        
        for (int i=start_pos; i < start_pos+NUM_BOWLS; i++)
        {   [self.containers addObject: [[Bowl alloc] initWithPosition:i ]];
            
        };
        
        [self.containers addObject: [[Tray alloc] initWithPosition:(int) (playerNum+1)*(NUM_BOWLS+1) ]];
        
        
        return self;
    }
    
    else return nil;
};


- (int) move:(long)pos {
    long last;
    int n_seeds;
    long currentPos;
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




- (int) playerController: (long) choice {
    int last;
    self.captured=false;
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
            self.captured=true;
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

- (int) getTrayPosition {
    int pos;
    
    pos=[self.containers[NUM_BOWLS] position];
    return pos;
};

- (Container *) getContainerAtPosition: (int) pos {

    return self.containers[(pos-1)%(NUM_BOWLS+1)] ;
};



- (void) printPlayerState {
    
    int i;
    for (i=0; i<=NUM_BOWLS; i++) {
        printf("%i    ", [self.containers[i] numOfSeeds] );
    }
};

@end





@implementation Human
- (int) humanController: (long) choice {
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
    long choice;
    //Implement AI control
    [self getPossibleMoves];
    NSArray* sameTurn=[self getSameTurnSeeds];
    NSArray* captSeeds=[self getCaptureSeeds];
    NSArray* status=[self getSystemStatus];
    long aiChoice=0;
    
    double test=self.aiLevel;
    long moves=[self.possibleMoves count];
    long randing=arc4random_uniform(moves);
    long randChoice=([[[self.possibleMoves objectAtIndex:randing] objectForKey:@"position"]integerValue])%(NUM_BOWLS+1);
    
    srand48(time(0));
    double levelDice = drand48();
    
    
    //AI decisional core: aiChoice
    

    if ([status[0] integerValue]>=[status[1] integerValue]) {
    //Defense Mode: keep your beans as much as you can
        
        if ([captSeeds count]) {
            aiChoice=[[[captSeeds objectAtIndex:0]objectForKey:@"position"]  integerValue];
        
        
        }
        else {
            //Take the furthest to the tray if can repeat the turn
            if ([sameTurn count]) {
                aiChoice=[[[sameTurn objectAtIndex:0]objectForKey:@"position"]  integerValue];}
            
            else {
                
                
                long smallest=32;
                int pos=0;
                for (int i=0; i<[self.possibleMoves count]; i++) {
                    if (smallest>[[[self.possibleMoves objectAtIndex:i] objectForKey:@"seeds"]integerValue])
                    {
                        smallest=[[[self.possibleMoves objectAtIndex:i] objectForKey:@"seeds"]integerValue];
                        pos=i;
                    }
                }
                aiChoice=[[[self.possibleMoves objectAtIndex:pos] objectForKey:@"position"] integerValue];
            }
            
            
        }

        
    } else {
    //Attack Mode: try to steal beans from the opponent
        if ([captSeeds count]) {
            
            //Get the position giving the best win from opponent
            long biggest=0;
            int pos=0;
            for (int i=0; i<[captSeeds count]; i++) {
                if (biggest<[[[captSeeds objectAtIndex:i] objectForKey:@"seedsToWin"]integerValue])
                {
                    biggest=[[[captSeeds objectAtIndex:i] objectForKey:@"seedsToWin"]integerValue];
                    pos=i;
                }
                
            }
            aiChoice=[[[captSeeds objectAtIndex:pos]objectForKey:@"position"]  integerValue];
        
        
        
        }
        else {
            //Take the closest to the tray if possible to repeat the turn
            if ([sameTurn count]) {
                aiChoice=[[[sameTurn objectAtIndex:([sameTurn count]-1)]objectForKey:@"position"]  integerValue];
            
            
            
            } else {
                //Get the furthest position with the most seeds in it
                long score=0;
                long pos=0;
                long seeds;
                long position;
                for (int i=0; i<[self.possibleMoves count]; i++) {
                    seeds=[[[self.possibleMoves objectAtIndex:i] objectForKey:@"seeds"]integerValue];
                    position=[[[self.possibleMoves objectAtIndex:i] objectForKey:@"position"]integerValue];
                    
                    if (score<seeds+position)
                    {   pos=i;
                        score=seeds+position;
                    }
                }
                aiChoice=[[[self.possibleMoves objectAtIndex:pos]objectForKey:@"position"]  integerValue];
                
                
            }
        }
    }
    
    
    
    
    if (levelDice>self.aiLevel) {
        choice=randChoice;
    } else {
        choice=aiChoice;
    }
    
    printf(" %ld\n", choice);
    
    
    flag=[self playerController:(choice)];
    
    //flag for round change
    return flag;
};

- (NSMutableArray *)getSystemStatus {
    int count=0;
    NSMutableArray* status=[[NSMutableArray alloc] init];
    
    for (int i=0; i<=NUM_BOWLS; i++) {
        count=count+[self.containers[i] numOfSeeds];
    }
    [status addObject:[NSNumber numberWithInt:count]];
    
    count=0;
    for (int i=0; i<=NUM_BOWLS; i++) {
        count=count+[self.opponent.containers[i] numOfSeeds];
    }
    
    [status addObject:[NSNumber numberWithInt:count]];
    
    return status;
}


- (NSMutableArray*) getSameTurnSeeds {
    NSMutableArray* arrayForSameTurn=[[NSMutableArray alloc] init];
    NSDictionary* itemForArray;
    
    for (int l=0; l<[self.possibleMoves count]; l++) {
        int i= [[[self.possibleMoves objectAtIndex:l] objectForKey:@"position"]integerValue];
        
        if (([self.containers[i] position]+[self.containers[i] numOfSeeds])==[self getTrayPosition]) {
            itemForArray=@{@"position": [NSNumber numberWithInt:i] ,
                           @"seeds" : [NSNumber numberWithInt:[self.containers[i] numOfSeeds]]};
            
            [arrayForSameTurn addObject:itemForArray];
        }
    }
    return arrayForSameTurn;
};

- (NSMutableArray*) getCaptureSeeds {
    NSMutableArray* arrayForCaptureSeeds=[[NSMutableArray alloc] init];
    NSDictionary* itemForArray;
    
    for (int l=0; l<[self.possibleMoves count]; l++) {
        
        int i= [[[self.possibleMoves objectAtIndex:l] objectForKey:@"position"]integerValue];
        int pos=[self.containers[i] position]+[self.containers[i] numOfSeeds] ;
        if ([self getContainerAtPosition:pos]==0) {
            itemForArray=@{@"position": [NSNumber numberWithInt:i] ,
                           @"seeds" : [NSNumber numberWithInt:[self.containers[i] numOfSeeds]],
                           @"seedsToWin": [NSNumber numberWithInt:[[self.opponent getContainerAtPosition:(((NUM_BOWLS+1)*2) - pos)] numOfSeeds]] };
            
            [arrayForCaptureSeeds addObject:itemForArray];
        }
    }
    return arrayForCaptureSeeds;
};


- (void) getPossibleMoves {
    if (!self.possibleMoves) {
        self.possibleMoves=[[NSMutableArray alloc] init];
    }
    
    
    NSMutableArray* arrayPossibleMoves=[[NSMutableArray alloc] init];
    NSDictionary* itemForArray;
    
    for (int i=0; i<NUM_BOWLS; i++) {
        
        if ([self.containers[i] numOfSeeds]!=0) {
            itemForArray=@{@"position": [NSNumber numberWithInt:i] ,
                           @"seeds" : [NSNumber numberWithInt:[self.containers[i] numOfSeeds]]};
            
            [arrayPossibleMoves addObject:itemForArray];
        }
    }
    self.possibleMoves=arrayPossibleMoves;
};


@end



