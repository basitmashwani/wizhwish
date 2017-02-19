//
//  WWizhViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-12.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WWizhViewController.h"

@interface WWizhViewController ()

@end

@implementation WWizhViewController

#pragma mark - Private Methods
- (void)backPressed:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"WhizWish"];
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed:)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WWishBoardViewController *controller = [segue destinationViewController];

    
    if ([segue.identifier isEqualToString:@"K_SEGUE_WISHBOARD"]) {
        
        controller.currentType = KWWishBoard;
    }
    else if([segue.identifier isEqualToString:@"K_SEGUE_WISHLIST"]) {
     
        controller.currentType = kWWishLists;
    }
}


@end
