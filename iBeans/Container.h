//
//  Container.h
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Container : NSObject

@property (nonatomic) int numOfSeeds;
@property (nonatomic) int position;

- (void) increment;
- (void) addSeeds: (int) seeds;
@end


@interface Bowl : Container
- (int) empty;
- (id) initWithPosition: (int) pos;
@end


@interface Tray : Container
- (id) initWithPosition: (int) pos;
@end