//
//  WGiftViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 150.0

#import "WWishBoardViewController.h"

@interface WWishBoardViewController ()

@end

@implementation WWishBoardViewController

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

- (void)keyboardWillShow {
    // Animate the current view out of the way
    //  if (self.view.frame.origin.y >= 0)
    
    [self setViewMovedUp:YES];
    // }
    
}

-(void)keyboardWillHide {
    
    [self setViewMovedUp:NO];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        // [self setViewMovedUp:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self setViewMovedUp:NO];
    [textField resignFirstResponder];
    
    return YES;
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGPoint rect = self.view.center;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.y -= kOFFSET_FOR_KEYBOARD;
        // rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.center = rect;
    
    [UIView commitAnimations];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    if (self.currentType == KWWishBoard) {
        
        self.constraint.constant = 20;
        self.label.hidden = YES;
        
    }
    else {
        
        self.constraint.constant = 40;
        self.label.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self didTappedView:self.view];
    [self showSearBarWithColor:[UIColor getLightGrayColor]];
    
    // Do any additional setup after loading the view.
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
 
    return 2;
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
