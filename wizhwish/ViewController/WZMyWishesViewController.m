//
//  WMyWishesViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-05-08.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZMyWishesViewController.h"

@interface WZMyWishesViewController()

@property(nonatomic ,assign) BOOL isMyPost;

@end

@implementation WZMyWishesViewController


#pragma mark Private Methods


#pragma mark Life Cycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backPressed)];
    
    


        [self.tableView reloadData];
    
    if (self.wishType == KWMyWishes) {
        
        
        [self.navigationItem setTitle:@"My Wishes"];
        
        [self.buttonPost setTitle:@"Post" forState:UIControlStateNormal];
        
        [self.buttonMyWishes setTitle:@"WishList" forState:UIControlStateNormal];
    
    } else {
        
        
        [self.navigationItem setTitle:@"WishBoard"];
        
        [self.buttonPost setTitle:@"Followers" forState:UIControlStateNormal];
        
        [self.buttonMyWishes setTitle:@"You" forState:UIControlStateNormal];
    }
    [self.buttonPost setBackgroundColor:[UIColor getTabBarColor]];
    
    [self.buttonPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.buttonMyWishes setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonMyWishes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.wishType == kWWishList && _isMyPost) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_CELL_MY_POST];
        return cell;
    }
    else {
    WZMyWishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_TABLE_CELL_MY_WISHES];
        cell.collectionType = KWWishesType;
    
    return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

#pragma mark Private Methods

- (void)postPressed:(id)sender {
    
    if ([self.buttonPost.titleLabel.text isEqualToString:@"Followers"]) {
        
        self.isMyPost = NO;

    }
    [self.tableView reloadData];

    [self.buttonPost setBackgroundColor:[UIColor getTabBarColor]];
    
    [self.buttonPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    [self.buttonMyWishes setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonMyWishes setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}

- (void)myWishesPressed:(id)sender {
    
    
    if ([self.buttonMyWishes.titleLabel.text isEqualToString:@"You"]) {
        
        self.isMyPost = YES;

    }
    [self.tableView reloadData];
    
    [self.buttonMyWishes setBackgroundColor:[UIColor getTabBarColor]];
    
    [self.buttonMyWishes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.buttonPost setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonPost setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}


@end
