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
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()
{
    float animationTime;
}
@property (weak, nonatomic) IBOutlet UIImageView *hand;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init view Item
    [self.containerView setHidden:true];
    //move hand away
    self.hand.center=CGPointMake(0.0f, 400.0f);
    
    [self loadTheme];
    [self startGame];
    
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
    
    //Activate Sounds
    if (sound) {
        
        NSString *soundpath=[self.themeUrl stringByAppendingString:@"background"];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:soundpath
                                             ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer prepareToPlay];
        [audioPlayer setNumberOfLoops:-1];//Infinite
         [audioPlayer setVolume:0.6];
    }
    
    //Set Backgroun Image
    NSString *background=[self.themeUrl stringByAppendingString:@"background.png"];
    UIImage *image = [UIImage imageNamed:background];
    [self.background setImage:image];
    
    //Set AnimationSpeed
    animationTime=(1.1-[[self.defaults valueForKey:@"animationSpeed"] floatValue]);
    
    
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
    
    
    //Set labels
    [self.player1Name setText:[self.myGame.players[0] name]];
    [self.player2Name setText:[self.myGame.players[1] name]];
    self.player1Name.layer.borderColor = [UIColor grayColor].CGColor;
    self.player1Name.layer.borderWidth = 2.0;
    self.player2Name.layer.borderColor = [UIColor grayColor].CGColor;
    self.player2Name.layer.borderWidth = 2.0;
    
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
    
    [self.myGame addObserver:self forKeyPath:@"hasWinner" options:NSKeyValueObservingOptionNew context:nil];
    [self.myGame addObserver:self forKeyPath:@"round" options:NSKeyValueObservingOptionNew context:nil];
    
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
    [self.myGame removeObserver:self forKeyPath:@"hasWinner"];
    [self.myGame removeObserver:self forKeyPath:@"round"];
}

- (void) deactivateButtons {
    //Hide and init Level sliders
        

    
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self restart];
    }
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)value context:(void *)context  {
    
    if ([object isKindOfClass:[Game class]] && [keyPath isEqualToString:@"round"]) {
        
        NSString *path=[NSString stringWithFormat:@"hand_%d.png", self.myGame.round];
        UIImage *image = [UIImage imageNamed:path];
        [self.hand setImage:image];
        if (self.myGame.round) {
//            [UIView animateWithDuration:animationTime delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                self.hand.center=CGPointMake(285.0f,-80.0f );
//                
//            } completion:^(BOOL finished){}];
            
        } else {
            
//            [UIView animateWithDuration:animationTime delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                self.hand.center=CGPointMake(285.0f,410.0f );
//            } completion:^(BOOL finished){}];
            
        }
        
        
        return;
    }
    
    
    
    if ([object isKindOfClass:[Game class]] && [keyPath isEqualToString:@"hasWinner"]) {
        //perform here final game code
        if ([self.myGame hasWinner]) {
            NSString* score=[NSString stringWithFormat:@"%d", self.myGame.finalScore];
            [self saveStatsWinner:self.myGame.winner withLoser: self.myGame.loser  andScore:score andDate:self.myGame.date];
            if (self.gameMode==1) {
                [self victoryCount];
            }
            
            
            NSString* message=[NSString stringWithFormat:@"%@ won! %@ points!\nRestart?", self.myGame.winner,score];
            //Create UIAlertView alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message: message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            return;
        }
    
    }
    
    
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
            
            
            //prepare for animation
            NSString *path=[self.themeUrl stringByAppendingString:[NSString stringWithFormat:@"%d.png", seeds]];
            UIImage *image = [UIImage imageNamed:path];
            [button setBackgroundImage:image forState:UIControlStateNormal];
//            //Animations go here
//            [UIView animateWithDuration:animationTime
//                             animations:^{
//                                 self.hand.center=button.center;
//                             }
//             
//                             completion:^(BOOL finished){
//                                 if (finished) {
//                                     // Do your method here after your animation.
//                                     
//                                     [self.view setNeedsDisplay];
//                                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//                                         
//                                         //Your code goes in here
//                                         
//                                         //CGRect myFrame = [button frame];
//                                         //[button drawRect:myFrame];
//                                         [NSThread sleepForTimeInterval:animationTime];
//                                     }];
//                                     
//                                 }
//                             }];
//                    [UIView commitAnimations];

            


            return;
        }
    }
    
    
}

- (IBAction)settingsButtonPressed:(UIButton *)sender {
    [self.containerView setHidden:false];
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
- (void) victoryCount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *victoryCount=[defaults mutableArrayValueForKey:@"victory"];
    if ([victoryCount count]==0)
    {[victoryCount addObject:[[NSNumber alloc] initWithInt:0]];
        [victoryCount addObject:[[NSNumber alloc] initWithInt:0]];
    }
    NSNumber* temp=victoryCount[self.myGame.win];
    victoryCount[self.myGame.win]= [NSNumber numberWithLong:[temp integerValue]+1];
    NSArray* victory=[NSArray arrayWithArray:victoryCount];
    [defaults setObject:victory   forKey:@"victory"];
    [defaults synchronize];
    
}

- (void)restart {
    [self exitGame];
    [self startGame];
}



- (IBAction)pressBowl:(id)sender {
    UIButton* button=sender;
    
    
    //play sounds
    BOOL sound=[self.defaults boolForKey:@"sounds"];
    if (sound) {

        NSString *soundpath=@"touch";
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:soundpath
                                             ofType:@"mp3"]];
        NSError *error;
        audioPlayerTouch = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayerTouch prepareToPlay];
        [audioPlayerTouch play];
    }
    //here goes animation
    self.hand.center=CGPointMake(button.center.x, 400.0f);
    

    
    [UIView animateWithDuration:animationTime animations:^{
        self.hand.center=button.center;
    
    } completion:^(BOOL finished){}];

//    [UIView animateWithDuration:animationTime animations:^{
//        self.hand.center=button.center;
//    }];
    [self.view setNeedsDisplay];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {

        [NSThread sleepForTimeInterval:1.0f];
    }];
    
    
    
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

- (void) saveStatsWinner: (NSString*) winner withLoser: (NSString*) loser andScore: (NSString*) score andDate: (NSDate*) date {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *stats=[defaults mutableArrayValueForKey:@"stats"];
    NSDictionary *result=@{@"winner": winner, @"loser":loser, @"score":score, @"date":date};
    int maxStats=10;
    
    
    if ([stats count]==0) {
        [stats addObject:result];
    } else {
        
        //sort array and save results
        int i=0;
        if ([score integerValue]>[[[stats objectAtIndex:i] objectForKey:@"score"] integerValue]) {
            [stats insertObject:result atIndex:i];
            
        } else {
            BOOL stopCycle=true;
            
            while (i<[stats count] && stopCycle)
            {
                if ([[[stats objectAtIndex:i] objectForKey:@"score"] integerValue]>[score integerValue]) {
                    i++;
                }
                else {
                    stopCycle=false;}
            }
            [stats insertObject:result atIndex:i];
        }
        if ([stats count]>maxStats) {
            [stats removeObjectAtIndex:(maxStats-1)];
        }
    }

    NSArray *sortedArray=[NSArray arrayWithArray:stats];
    
    [defaults setObject:sortedArray forKey:@"stats"];
    [defaults synchronize];
    
}
- (void) refreshNames {
    NSString *player1=[self.myGame.players[0] name];
    NSString *player2=[self.myGame.players[1] name];
    [self.player1Name setText:player1];
    [self.player2Name setText:player2];
}



#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self exitGame];
    [audioPlayer stop];
}

@end


