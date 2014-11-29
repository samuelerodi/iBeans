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

@interface ViewController : UIViewController

@property (nonatomic) NSInteger buttonCount;
- (void) updateButtonLabels;
- (IBAction)pressBowl1:(id)sender;
@end

