//
//  WWishListViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWishListViewController.h"

@interface WWishListViewController ()

@end

@implementation WWishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextPressed {
    
    NSString *text = [[WSetting getSharedSetting] postText];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processPostText:text success:^(NSString *accessToken) {
       
        NSLog(@"msg:%@",accessToken);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];

    } failure:^(NSError *error) {
       
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to proceed request"];
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
