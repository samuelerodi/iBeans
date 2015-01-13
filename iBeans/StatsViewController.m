//
//  StatsViewController.m
//  iBeans
//
//  Created by Sam on 1/9/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()
@property (weak, nonatomic) NSArray* stats;
@property (weak, nonatomic) NSUserDefaults* defaults;
@property (weak, nonatomic) IBOutlet UILabel *humanLabel;
@property (weak, nonatomic) IBOutlet UILabel *computerLabel;


@end

@implementation StatsViewController
{
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStats];
    self.statsTable.dataSource=self;
    self.statsTable.delegate=self;
    
    self.statsTable.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadStats {
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.stats=[self.defaults arrayForKey:@"stats"];
    NSMutableArray* victory=[self.defaults mutableArrayValueForKey:@"victory"];
    if ([victory count]>0) {
        self.humanLabel.text=[NSString stringWithFormat:@"%ld", (long)[victory[0] integerValue]];
        self.computerLabel.text=[NSString stringWithFormat:@"%ld", (long)[victory[1] integerValue]];
    }
    else {
        self.humanLabel.text=@"0";
        self.computerLabel.text=@"0";
    }
}
- (IBAction)resetStats:(UIButton *)sender {
    NSMutableArray *newStats=[[NSMutableArray alloc] initWithCapacity:0];
    [self.defaults setObject:newStats forKey:@"stats"];
    NSMutableArray *victory=[[NSMutableArray alloc] initWithCapacity:0];
    [self.defaults setObject:victory forKey:@"stats"];
    [self.defaults synchronize];
    [self loadStats];
    [self.statsTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stats count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm dd-MM"];
    
    NSString *temp = [NSString stringWithFormat:@"%-2s \t%@ \t     %@",
                              [[self.stats[indexPath.row] objectForKey:@"score"] UTF8String],
                              [[self.stats[indexPath.row] objectForKey:@"winner"] stringByPaddingToLength:15 withString:@" " startingAtIndex:0],
                              [[self.stats[indexPath.row] objectForKey:@"loser"] stringByPaddingToLength:12 withString:@" " startingAtIndex:0]];
    
    NSString* resultString= [NSString stringWithFormat:@"%@\t%@", temp,
                             [dateFormatter stringFromDate:([self.stats[indexPath.row] objectForKey:@"date"])]];
    cell.textLabel.text = resultString;
    cell.textLabel.font = [UIFont systemFontOfSize:11.0];
    cell.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.8];
    return cell;
    
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
