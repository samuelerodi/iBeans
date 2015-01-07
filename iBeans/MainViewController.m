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

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


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
        


    } else {
    //Display Navigation Bar
        [self.navigationController setNavigationBarHidden:NO];
    }
    

}


@end
