//
//  MainViewController.m
//  iBeans
//
//  Created by Sam on 12/20/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"



@interface MainViewController ()
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) NSString *themeUrl;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTheme];
    // Do any additional setup after loading the view.
    


}

- (void) loadTheme {
    self.defaults = [NSUserDefaults standardUserDefaults];
    BOOL sound=[self.defaults boolForKey:@"sounds"];

    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"menu"
                                         ofType:@"mp3"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer setNumberOfLoops:-1];//Infinite
    [audioPlayer setVolume:0.5];
    if (sound) {
        

        [audioPlayer play];


    }
    

}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id dest=[segue destinationViewController];
    BOOL sound=[self.defaults boolForKey:@"sounds"];

    
    if  ([dest isKindOfClass:([GameViewController class])]) {
        GameViewController *gvc = dest;
        
        UIView *button= sender;
        gvc.gameMode=[[NSNumber numberWithLong:[button tag]] integerValue];
        [audioPlayer stop];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"button"
                                             ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer prepareToPlay];
        if (sound) {
            [audioPlayer play];
            
        }
        [button setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        [self.view setNeedsDisplay];

        
        [UIView animateWithDuration:1 animations: ^{
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                
            }
            
        } ];

        
        
        

        
        


    } else if   ([dest isKindOfClass:([OptionsViewController class])])  {
            //Display Navigation Bar
        [self.navigationController setNavigationBarHidden:NO];
        OptionsViewController *ovc = dest;
        ovc.audioPlayer=audioPlayer;

    }
    else {
        
        [self.navigationController setNavigationBarHidden:NO];
    }
    

}


@end
