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
    NSURL *soundFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menu"
                                                                                 ofType:@"mp3"]];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"menu"
                                         ofType:@"mp3"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer setNumberOfLoops:-1];//Infinite
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

    
    if  ([dest isKindOfClass:([GameViewController class])]) {
        GameViewController *gvc = dest;
        
        UIView *button= sender;
        gvc.gameMode=[button tag];
        [audioPlayer stop];
        


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
