//
//  WProfileViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WProfileViewController.h"

@interface WProfileViewController ()

@end

@implementation WProfileViewController


#pragma mark - Private Methods
- (void)donePressed:(id)sender {
    
    WZHomeViewController *homeViewController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_HOME_VIEW_CONTROLLER];
    
    [RUUtility setMainRootController:homeViewController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Profile Setup"];
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Done" forViewController:self selector:@selector(donePressed:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WEditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Edit_Profile"];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textField.placeholder = @"Username";
            cell.imageView.image = [UIImage imageNamed:@"Image_Profile_Icon"];

        }
        else if (indexPath.row == 1 ) {
            
            cell.textField.placeholder = @"Bio";
            cell.imageView.image = [UIImage imageNamed:@"Image_Bio"];


        }
    }
    else {
     
        if (indexPath.row == 0) {
            cell.textField.placeholder = @"Email";
            cell.imageView.image = [UIImage imageNamed:@"Image_Email"];

            
        }
        else if (indexPath.row == 1 ) {
            
            cell.textField.placeholder = @"Phone";
            cell.imageView.image = [UIImage imageNamed:@"Image_Phone"];

            
        }
        
        else if (indexPath.row == 2 ) {
            
            cell.textField.placeholder = @"Gender";
            cell.imageView.image = [UIImage imageNamed:@"Image_Gender"];

            
        }

    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    else {
    return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  @"";
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
    sectionLabel.textColor = [UIColor blackColor]; //here you can change the text color of header.
    //  sectionLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSizeForHeaders];
    //  sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    
    if (section == 0) {
        sectionLabel.text =  @"";
    }
    else {
        sectionLabel.text = @"Private Information";
        
    }
    [headerView addSubview:sectionLabel];
    return headerView;
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
