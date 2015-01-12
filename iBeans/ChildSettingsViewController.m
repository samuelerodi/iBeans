//
//  ChildSettingsViewController.m
//  iBeans
//
//  Created by Sam on 1/12/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

#import "ChildSettingsViewController.h"
#import "GameViewController.h"

@interface ChildSettingsViewController ()
@property (nonatomic, weak) GameViewController *parentView;
@property (weak, nonatomic) IBOutlet UISlider *sliderPlayer2;
@property (weak, nonatomic) IBOutlet UISlider *sliderPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer1;
@property (weak, nonatomic) IBOutlet UITextField *player1Name;
@property (weak, nonatomic) IBOutlet UITextField *player2Name;
@end

@implementation ChildSettingsViewController





- (void)viewDidLoad {
        [super viewDidLoad];
    
    self.player1Name.delegate=self;
    self.player2Name.delegate=self;
    // Do any additional setup after loading the view.
}

-  (void) viewDidAppear:(BOOL)animated {
            self.parentView=self.parentViewController;
    
    
    switch (self.parentView.gameMode) {
        case 0:
            [self.sliderPlayer1 setHidden: true];
            [self.sliderPlayer1 setEnabled:false];
            [self.labelPlayer1 setHidden:true];
            [self.sliderPlayer2 setHidden: true];
            [self.sliderPlayer2 setEnabled:false];
            [self.labelPlayer2 setHidden:true];
            break;
        case 1:
            
            [self.sliderPlayer1 setHidden: true];
            [self.sliderPlayer1 setEnabled:false];
            [self.labelPlayer1 setHidden:true];
            self.sliderPlayer2.value=0;
        case 2:
            self.sliderPlayer2.value=0;
            self.sliderPlayer1.value=0;
            break;
    }
    [self refreshPlayerNames];
    
    
}

- (void) refreshPlayerNames {
    
    NSString *player1=[self.parentView.myGame.players[0] name];
    NSString *player2=[self.parentView.myGame.players[1] name];
    [self.player1Name setText:player1];
    [self.player2Name setText:player2];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    long playerNum=[textField tag]-1;
    [self.parentView.myGame.players[playerNum] setName:[textField text]];
    [self.parentView refreshNames];
    
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonPressed:(UIButton *)sender {

    [self.parentView.containerView setHidden: true];
}
- (IBAction)changeAILevel:(UISlider*)sender {
    
    switch ([sender tag]) {
        case 50:
            if ([self.parentView.myGame.players[0] isKindOfClass:([Computer class])]) {
                [self.parentView.myGame.players[0] setAiLevel:([sender value])];
            }
            else
            { NSLog(@"Human is not a Computer! Can't assign AI Level");}
            break;
            
        case 51:
            if ([self.parentView.myGame.players[1] isKindOfClass:([Computer class])]) {
                [self.parentView.myGame.players[1] setAiLevel:([sender value])];
            }
            else
            { NSLog(@"Human is not a Computer! Can't assign AI Level");}
            break;
    }
    
}
- (IBAction)restart:(id)sender {
    [self.parentView restart];
    [self.parentView.containerView setHidden: true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
