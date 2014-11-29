//
//  Container.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#define NUM_SEEDS 3


#import "Container.h"

@implementation Container

- (void) increment {
    self.numOfSeeds=self.numOfSeeds + 1;
};

- (void) addSeeds:(int)seeds {
    self.numOfSeeds=self.numOfSeeds + seeds;
};
- (id) initWithPosition: (int) pos	{
    self =[super init];
    if (self)
    {   [self setPosition: pos];
        if ([self isKindOfClass:([Bowl class])]) {
            [self setNumOfSeeds: (NUM_SEEDS)];
        } else if ([self isKindOfClass:([Tray class])]) {
            [self setNumOfSeeds: (0)];
        }
        else {
            [self setNumOfSeeds: (0)];
        }
        return self;}
    else return nil;
};

@end

@implementation Bowl

- (int) empty {
    int nSeeds;
    nSeeds=self.numOfSeeds;
    self.numOfSeeds=0;
    return nSeeds;
};


@end

@implementation Tray

@end


