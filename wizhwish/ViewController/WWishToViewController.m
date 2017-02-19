//
//  WWishToViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWishToViewController.h"

@interface WWishToViewController ()

@end

@implementation WWishToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showSearBarWithColor:[UIColor getLightGrayColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showSearBarWithColor:(UIColor*)color {
    
    JKSearchBar *searchBarCode = [[JKSearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35)];
    //   searchBarCode.inputView = picker;
    searchBarCode.iconAlign = JKSearchBarIconAlignCenter;
    searchBarCode.placeholder = @"Search";
    searchBarCode.placeholderColor = [UIColor darkGrayColor];
    searchBarCode.layer.cornerRadius = searchBarCode.frame.size.height/2;
    searchBarCode.backgroundColor = color;
    searchBarCode._textField.borderStyle = UITextBorderStyleNone;
    
    searchBarCode._textField.backgroundColor = [UIColor getLightGrayColor];
    //searchBarCode.inputAccessoryView =view;
    //searchBarCode.inputView = picker;
    // [searchBarCode.cancelButton setTitle:@"X" forState:UIControlStateNormal];
    self.tableView.tableHeaderView = searchBarCode;
    //[self.view addSubview:searchBarCode];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}
#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
    return 2;
    }
    else {
        return 8;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  @"Categories";
    }
    else {
        return @"Syed;";
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,tableView.bounds.size.width,25)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    //  sectionLabel.shadowColor = [UIColor blackColor];
    sectionLabel.shadowOffset = CGSizeMake(0,2);
    sectionLabel.textColor = [UIColor navigationBarColor]; //here you can change the text color of header.
    //  sectionLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
    //  sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    
    if (section == 0) {
        sectionLabel.text =  @"Categories";
    }
    else {
        sectionLabel.text = @"Individuals";
        
    }
    [headerView addSubview:sectionLabel];
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
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
