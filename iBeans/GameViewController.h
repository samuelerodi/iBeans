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
#import "MainViewController.h"


@interface GameViewController : UIViewController
{
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayerTouch;
    
}
@property (nonatomic) int gameMode;
@property (nonatomic) NSInteger buttonCount;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) Game  *myGame;
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) NSString *themeUrl;
@property (weak, nonatomic) IBOutlet UILabel *player2Name;
@property (weak, nonatomic) IBOutlet UILabel *player1Name;

- (void)startGame;
- (IBAction)pressBowl:(id)sender;
- (void)restart;
- (void) refreshNames;
- (void) saveStatsWinner: (NSString*) winner withLoser: (NSString*) loser andScore: (NSString*) score andDate: (NSDate*) date;

@end
