//
//  WCommentsViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD  240

#import "WCommentsViewController.h"


@interface WCommentsViewController ()

@property(nonatomic ,retain) NSArray *array;

@property(nonatomic ) BOOL canFetch;

@end

@implementation WCommentsViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
   
    self.array = [[NSArray alloc] init];
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 84.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self.sendButton setEnabled:NO];
    [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

// set to whatever your "average" cell height is

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self getCommentListWithlimit:self.array.count];
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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


#pragma mark Private Methods
- (void)getCommentListWithlimit:(NSInteger)limit {
    
  //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processGetCommentsForPost:self.postId withLimit:limit success:^(NSDictionary *dict) {
        
       // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        NSArray *commentArray = [dict valueForKey:@"data"];

        if (commentArray.count >0) {
        
            weakSelf.canFetch = YES;
        weakSelf.array =  [weakSelf.array arrayByAddingObjectsFromArray:commentArray];
       // weakSelf.array = [[weakSelf.array reverseObjectEnumerator] allObjects];

        [weakSelf.tableView reloadData];
        
        }
        else {
            
            weakSelf.canFetch = NO;
        }
        
        
    } failure:^(NSError *error) {
        
       // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to get comments"];
        
    }];
    
}

#pragma mark Keyboard Delegate Methods
- (void)keyboardWillShow {
    // Animate the current view out of the way
    //  if (self.view.frame.origin.y >= 0)
    
    [self setViewMovedUp:YES];
    // }
    
}

-(void)keyboardWillHide {
    
    [self setViewMovedUp:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger index = (self.array.count-1) - indexPath.row;
   
    WZProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_FOLLOWER_CELL];
    
    NSDictionary *postDict = [self.array objectAtIndex:index];

    WZPost *post = [WZServiceParser getDataFromDictionary:postDict haveComments:NO];
    
    cell.labelName.text = post.postText;
    
    cell.labelUserName.text = post.displayName;
    
    cell.timeLabel.text = post.createdDate;
    
    if (![NSString isStringNull:post.userProfileURL]) {

    NSURL *url = [NSURL URLWithString:post.userProfileURL];
    
    [cell.imageViewProfile setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Image_Profile-1"]];
    
    }
    else {
        
        cell.imageViewProfile.image = [UIImage imageNamed:@"Image_Profile-1"];
    }
    

    return cell;
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
           return 85;
  
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        if(indexPath.row == self.array.count - 1 && self.canFetch)
        {
            //  NSLog(@"last row %ld with post last index %ld",(long)indexPath.row,self.postArray.count-1);
            [self getCommentListWithlimit:self.array.count];
            
            
        }
    }

}


#pragma mark - UITextfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.text.length>0) {
        
     //   [self.sendButton setEnabled:YES];
     //   [self.sendButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    }
    else {
       // [self.sendButton setEnabled:NO];
       // [self.sendButton setEnabled:NO];
       // [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    }
}

- (void)commentPressed:(id)sender {
    
    [self.textField resignFirstResponder];
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.textField.text.length == 0) {
        
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Please enter comment to post"];
    }
    else {
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processCommentOnPost:self.postId commentText:self.textField.text success:^(NSDictionary *dict) {
       
       // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.textField.text = @"";
        weakSelf.canFetch = YES;
        [weakSelf getCommentListWithlimit:self.array.count];

    } failure:^(NSError *error) {
       
       // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    }];
    
    }
    
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0]; // if you want to slide up the view
    
    CGPoint rect = self.commentView.center;
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
    self.commentView.center = rect;
    
    [UIView commitAnimations];
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
