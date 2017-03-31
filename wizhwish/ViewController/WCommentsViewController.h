//
//  WCommentsViewController.h
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCommentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic ,retain) IBOutlet UITableView *tableView;

@property(nonatomic ,retain) IBOutlet UITextField *textField;

@property(nonatomic ,retain) IBOutlet UIView *commentView;

@property(nonatomic ,retain) IBOutlet UIButton *sendButton;

@property(nonatomic ,retain)  NSString *postId;


- (IBAction)commentPressed:(id)sender;
@end

