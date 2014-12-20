//
//  ViewController.h
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#import "Game.h"
#import "Container.h"
#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property (nonatomic) int gameMode;
@property (nonatomic) NSInteger buttonCount;
- (void)startGame;
- (IBAction)pressBowl:(id)sender;
@end