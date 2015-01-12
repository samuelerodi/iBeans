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
#import <AVFoundation/AVFoundation.h>

@interface GameViewController : UIViewController
{
    
    AVAudioPlayer *audioPlayer;
    
}
@property (nonatomic) int gameMode;
@property (nonatomic) NSInteger buttonCount;
@property (weak, nonatomic) IBOutlet UIImageView *background;


- (void)startGame;
- (IBAction)pressBowl:(id)sender;

@end
