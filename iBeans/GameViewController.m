//
//  ViewController.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#define NUM_BOWLS (int) 6

#import "Player.h"
#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) Game  *myGame;
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) NSString *themeUrl;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTheme];
    [self startGame];
    
    [self saveStatsWinner:@"win" withLoser: @"lose" andScore:@"3"];
   

    // Do any additional setup after loading the view, typically from a nib.
}

- (void) loadTheme {
    self.defaults = [NSUserDefaults standardUserDefaults];
    NSString *theme=[self.defaults objectForKey:@"theme"];
    BOOL sound=[self.defaults boolForKey:@"sounds"];
    
    //set Background
    if ([theme isEqualToString:@"Worms"])
    {   self.themeUrl=@"worms_";
    }
    else if ([theme isEqualToString:@"Beans"]) {
        self.themeUrl=@"beans_";
    }
    else if ([theme isEqualToString:@"Piranha"]) {
        self.themeUrl=@"piranha_";
    }

    if (sound) {
        
        NSString *soundpath=[self.themeUrl stringByAppendingString:@"background"];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:soundpath
                                             ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer prepareToPlay];
        [audioPlayer setNumberOfLoops:-1];//Infinite
    }
    
    
    NSString *background=[self.themeUrl stringByAppendingString:@"background.png"];
    UIImage *image = [UIImage imageNamed:background];
    [self.background setImage:image];
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskLandscape);
}

- (void) viewDidAppear:(BOOL)animated   {
}

- (void)startGame{
    self.myGame=[[Game alloc] initGameWithMode:self.gameMode];
    
    [self deactivateButtons];
    [self.myGame gameController: 1];
    
    self.buttonCount=[[self.myGame.players[0] containers] count]+ [[self.myGame.players[1] containers] count];
    
    [self initButtonLabels];
    [self activateButtons];
    [audioPlayer play];
    
}



- (void) initButtonLabels{
    UIButton *button;
    int player;
    int container;
    int seeds;
    
    for (int i=1; i <=[self buttonCount]; i++) {
        
        button=[self.view viewWithTag: i];
        player= ((i-1)/(NUM_BOWLS+1));
        container= (i-1)%(NUM_BOWLS+1);

        
        [[self.myGame.players[player] containers] [container]  addObserver:self forKeyPath:@"numOfSeeds" options:NSKeyValueObservingOptionNew context:nil];
        
        seeds=[[self.myGame.players[player] containers][container] numOfSeeds];
        NSString *title=[NSString stringWithFormat:@"%d", seeds];
        [button setTitle:title forState:UIControlStateNormal];
        
        
        if (seeds>6) {
            seeds=6;
        }
        NSString *path=[self.themeUrl stringByAppendingString:[NSString stringWithFormat:@"%d.png", seeds]];
        UIImage *image = [UIImage imageNamed:path];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
    };
    
    
}
- (void) stopButtonsObservation {
    UIButton *button;
    int player;
    int container;
    
    for (int i=1; i <=[self buttonCount]; i++) {
        
        button=[self.view viewWithTag: i];
        player= ((i-1)/(NUM_BOWLS+1));
        container= (i-1)%(NUM_BOWLS+1);
        
        [[self.myGame.players[player] containers] [container] removeObserver:self forKeyPath:@"numOfSeeds"];
        
        
    };
    
}

- (void) deactivateButtons {
    //Hide and init Level sliders
    UISlider *slider;
    switch (self.gameMode) {
        case 0:
            slider=[self.view viewWithTag: 50];
            [slider setHidden: true];
            [slider setEnabled:false];
            slider=[self.view viewWithTag: 51];
            [slider setHidden: true];
            [slider setEnabled:false];
            break;
        case 1:
            slider=[self.view viewWithTag: 50];
            [slider setHidden: true];
            [slider setEnabled:false];
            slider=[self.view viewWithTag: 51];
            slider.value=0;
        case 2:
            slider=[self.view viewWithTag: 50];
            slider.value=0;
            slider=[self.view viewWithTag: 51];
            slider.value=0;
            break;
    }
    

    
    UIButton *button;
    for (int i=1; i <=[self buttonCount]; i++) {
        
        button=[self.view viewWithTag: i];
        [button setEnabled:false];
        
    }
}


- (void) activateButtons {
    
    int round=[self.myGame round];
    UIButton *button;
    int player;
    int container;
    
    for (int i=1; i <=[self buttonCount]; i++) {
        
        button=[self.view viewWithTag: i];
        player= ((i-1)/(NUM_BOWLS+1));
        container= (i-1)%(NUM_BOWLS+1);
        if (round!=player) {
            [button setEnabled:false];
        }
        else if ([self.myGame.players[player] isKindOfClass:([Computer class])] ||
                 [[self.myGame.players[player] containers][container] isKindOfClass:([Tray class])]) {
            [button setEnabled:false];}
        else if ([[self.myGame.players[player] containers][container] numOfSeeds]==0) {
            [button setEnabled:false];
        }
        else {
            [button setEnabled:true];
        };
    }
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)value context:(void *)context  {
    
    
    if ([object isKindOfClass:[Container class]]) {
        if ([keyPath isEqualToString:@"numOfSeeds"]) {
            
            Container *container=object;
            int pos= [container position];
            int seeds=container.numOfSeeds;
            
            UIButton *button=[self.view viewWithTag: pos];
            NSString *title=[NSString stringWithFormat:@"%d", seeds];
            [button setTitle:title forState:UIControlStateNormal];

            if (seeds>5) {
                seeds=6;
            }
            NSString *path=[self.themeUrl stringByAppendingString:[NSString stringWithFormat:@"%d.png", seeds]];
            UIImage *image = [UIImage imageNamed:path];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            [self.view setNeedsDisplay];

            
        }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) exitGame {
    [self stopButtonsObservation];
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
    
}

- (IBAction)restart:(id)sender {
    
    [self exitGame];
    [self startGame];
}

- (IBAction)changeAILevel:(UISlider*)sender {

    switch ([sender tag]) {
        case 50:
            if ([self.myGame.players[0] isKindOfClass:([Computer class])]) {
                [self.myGame.players[0] setAiLevel:([sender value])];
            }
            else
            { NSLog(@"Human is not a Computer! Can't assign AI Level");}
            break;
            
        case 51:
            if ([self.myGame.players[1] isKindOfClass:([Computer class])]) {
                [self.myGame.players[1] setAiLevel:([sender value])];
            }
            else
            { NSLog(@"Human is not a Computer! Can't assign AI Level");}
            break;
    }
    
}

- (IBAction)pressBowl:(id)sender {
    
    [self deactivateButtons];
    int flag;
    long pos;
    pos=[sender tag];
    NSLog(@"pressed %ld button", (long)pos);
    pos=pos%(NUM_BOWLS+1);
    
    flag=[self.myGame.players[self.myGame.round] humanController: pos];
    if (flag!=-1){
        [self.myGame gameController:(flag)];
        
    };
    [self activateButtons];
    
}

- (void) saveStatsWinner: (NSString*) winner withLoser: (NSString*) loser andScore: (NSString*) score {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *stats=[defaults mutableArrayValueForKey:@"stats"];
    NSDictionary *result=@{@"winner": winner, @"loser":loser, @"score":score};
    int maxStats=10;
    
    
    if ([stats count]<maxStats) {
        [stats addObject:result];
        
    }
    else {
        long worst;
        worst=[[stats[(maxStats-1)] objectForKey:@"score"] integerValue];
        
        long n;
        n=[score integerValue];
        
        if (n>=worst) {
            [stats removeObjectAtIndex:(maxStats-1)];
            [stats addObject:result];
        }
        
    }
    
    //sort array and save results
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [stats sortedArrayUsingDescriptors:sortDescriptors];

    
    
    [defaults setObject:sortedArray forKey:@"stats"];
    [defaults synchronize];
    
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [audioPlayer stop];
}

@end


