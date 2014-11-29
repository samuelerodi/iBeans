//
//  ViewController.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#define NUM_BOWLS (int) 6

#import "Player.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) Game  *myGame;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myGame=[[Game alloc] initGameWithMode:0];
     _myGame.mainView=self;
    [_myGame gameController: 1];

    self.buttonCount=[[self.myGame.players[0] containers] count]+ [[self.myGame.players[1] containers] count];
    [self updateButtonLabels];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) updateButtonLabels{
    int round=[self.myGame round];
    
    for (int i=1; i <=[self buttonCount]; i++) {

        UIButton *button=[self.view viewWithTag: i];
        int player= ((i-1)/(NUM_BOWLS+1));
        int container= (i-1)%(NUM_BOWLS+1);
        NSString *title=[NSString stringWithFormat:@"%d", [[self.myGame.players[player] containers][container] numOfSeeds]];
        [button setTitle:title forState:UIControlStateNormal];
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
    };
           

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restart:(id)sender {
    _myGame=[[Game alloc] initGameWithMode:0];
    _myGame.mainView=self;
    [_myGame gameController: 1];
    
    self.buttonCount=[[self.myGame.players[0] containers] count]+ [[self.myGame.players[1] containers] count];
    [self updateButtonLabels];
}

- (IBAction)pressBowl1:(id)sender {

    int flag;
    int pos;
    pos=[sender tag];
    NSLog(@"pressed %ld button", (long)pos);
    pos=pos%(NUM_BOWLS+1);
    
    flag=[self.myGame.players[self.myGame.round] humanController: pos];
    if (flag!=-1){
        [self.myGame gameController:(flag)];

    };


}
@end

