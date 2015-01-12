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
    

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadStats {
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.stats=[self.defaults arrayForKey:@"stats"];

}
- (IBAction)resetStats:(UIButton *)sender {
    NSMutableArray *newStats=[[NSMutableArray alloc] initWithCapacity:0];
    [self.defaults setObject:newStats forKey:@"stats"];
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
    
    NSString* resultString= [NSString stringWithFormat:@"%-5ld %-10s vs %-10s %-2s",indexPath.row + 1,
                             [[self.stats[indexPath.row] objectForKey:@"winner"] UTF8String],
                             [[self.stats[indexPath.row] objectForKey:@"loser"] UTF8String],
                             [[self.stats[indexPath.row] objectForKey:@"score"] UTF8String]];
    cell.textLabel.text = resultString;
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
