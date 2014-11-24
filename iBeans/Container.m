//
//  Container.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#define NUM_SEEDS ((int) 3)
#define TRAY_NUM ((int) 7)

#import "Container.h"

@implementation Container

- (void) increment {
    self.numOfSeeds=self.numOfSeeds + 1;
};

- (void) addSeeds:(int)seeds {
    self.numOfSeeds=self.numOfSeeds + seeds;
};

- (int) empty {
    int nSeeds;
    nSeeds=self.numOfSeeds;
    self.numOfSeeds=0;
    return nSeeds;
};

- (id) initWithPosition: (int) pos	{
    if (self =[super init])
    {   [self setPosition: (pos)];
        
        if (pos==TRAY_NUM) {
            [self setNumOfSeeds: 0];
        }
        else
            [self setNumOfSeeds: (NUM_SEEDS)];

        return self;}
    else return nil;
};

@end
