//
//  OptionsViewController.h
//  iBeans
//
//  Created by Sam on 1/7/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITextField *player1box;
@property (weak, nonatomic) IBOutlet UITextField *player2box;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

@end
