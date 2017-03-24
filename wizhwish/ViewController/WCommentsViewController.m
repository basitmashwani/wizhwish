//
//  WCommentsViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WCommentsViewController.h"

@interface WCommentsViewController ()

@end

@implementation WCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 84.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self.sendButton setEnabled:NO];

// set to whatever your "average" cell height is

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}


#pragma mark - UITextfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.text.length>0) {
        
       // [self.sendButton setEnabled:YES];
    }
    else {
       // [self.sendButton setEnabled:NO];

    }
}

- (void)commentPressed:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processCommentOnPost:self.postId commentText:self.textField.text success:^(NSDictionary *dict) {
       
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.textField.text = @"";

    } failure:^(NSError *error) {
       
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
    
    
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
