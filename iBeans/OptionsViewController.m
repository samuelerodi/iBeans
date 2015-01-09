//
//  OptionsViewController.m
//  iBeans
//
//  Created by Sam on 1/7/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController()
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSArray *pickerData;

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sound = [self.defaults boolForKey:(@"sounds")];
    [self.soundSwitch setOn:sound];
    
    NSString *player1 = [self.defaults stringForKey:(@"player1Name")];
    [self.player1box setText:player1];
    self.player1box.delegate = self;
    
    NSString *player2 = [self.defaults stringForKey:(@"player2Name")];
    [self.player2box setText:player2];
    self.player2box.delegate = self;
    
    float speed= [self.defaults floatForKey:(@"animationSpeed")];
    [self.speedSlider setValue:(speed)];
    
    
    //initialize picker view
    self.pickerData=@[@"Theme1", @"Theme2"];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    NSString *val=[self.defaults stringForKey:(@"theme")];
    
    int row;
    for (int i=0; i<self.pickerData.count; i++) {
        if(![val compare:self.pickerData[i]]) {
            row=i;
            break;
        }
    }

    [self.picker selectRow:row inComponent:0 animated:0];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *playerNum;
    switch ([textField tag]) {
        case 2:
            playerNum=@"player1Name";
            break;
        case 3:
            playerNum=@"player2Name";
            break;
        default:
            break;
    }
    [self.defaults setObject:[NSString stringWithString:[textField text]] forKey:playerNum];
    return NO;
}

- (IBAction)speedSlider:(UISlider *)sender {
    float val=[sender value];
    [self.defaults setFloat:(val) forKey:(@"animationSpeed")];

}

- (IBAction)soundSwitch:(UISwitch *)sender {
    BOOL sound=[sender isOn];
    [self.defaults setBool:sound forKey:(@"sounds")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PickerView DataSource

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component	{
    [self.defaults setValue:self.pickerData[row] forKey:(@"theme")];

}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
