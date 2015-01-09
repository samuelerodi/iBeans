//
//  StatsViewController.h
//  iBeans
//
//  Created by Sam on 1/9/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UITableView *statsTable;

@end
