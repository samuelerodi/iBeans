//
//  ViewController.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//
#import "Container.h"
#import "Player.h"
#import "Game.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) Game  *myGame;
@property (nonatomic) NSInteger buttonCount;

- (IBAction)pressBowl1:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myGame=[[Game alloc] initGameWithMode:1];
    [_myGame gameController: 1];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.buttonCount=[[self.myGame.players[0] containers] count]+ [[self.myGame.players[1] containers] count];
    [self updateButtonLabels];

}

- (void) updateButtonLabels{
    
    for (int i=1; i <=[self buttonCount]; i++) {

        UIButton *button=[self.view viewWithTag: i];
        int player= ((i-1)/7);
        int container= (i-1)%7;
        NSString *title=[NSString stringWithFormat:@"%d", [[self.myGame.players[player] containers][container] numOfSeeds]];
        [button setTitle:title forState:UIControlStateNormal];
        if ([self.myGame.players[player] isKindOfClass:([Computer class])] ||
            [[self.myGame.players[player] containers][container] isKindOfClass:([Tray class])]) {
            [button setEnabled:false];}
        else if ([[self.myGame.players[player] containers][container] numOfSeeds]==0) {
                 [button setEnabled:false];
        }
        else {
            [button setEnabled:true];
        };
    };
            //[[self.myGame.players[0] containers]	[0] numOfSeeds];]

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressBowl1:(id)sender {

    int flag;
    int pos;
    pos=[sender tag];
    NSLog(@"pressed %ld button", (long)pos);
    
    flag=[self.myGame.players[0] humanController: pos];
    if (flag!=-1){
        [self.myGame gameController:(flag)];
        [self updateButtonLabels];
    };


}
@end

