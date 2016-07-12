//
//  WHomeViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WZHomeViewController.h"
#import "UIView+Extras.h"



@interface WZHomeViewController()

@property(nonatomic ,retain) NJKScrollFullScreen *scrollProxy;

@property(nonatomic) NSInteger *counter;

@end
@implementation WZHomeViewController

#pragma mark Private Methods

- (void)settingPressed {
    
}

- (void)alertPressed {
    
    WZFollowerViewController *controller = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
    
    controller.profileType = kWProfileAlerts;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)giftPressed {
    
    WZFollowerViewController *controller = [[UIStoryboard getProfileStoryBoard] instantiateViewControllerWithIdentifier:K_SB_FOLLOWER_VIEW_CONROLLER];
    
    controller.profileType = kWProfileGifts;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)inMailPressed {
 
    WZChatViewController *chatController = [[UIStoryboard getChatStoryBoard] instantiateViewControllerWithIdentifier:K_SB_CHAT_VIEW_CONTROLLER];
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma Life Cycle Methods


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  //  [(ScrollingNavigationController *)self.navigationController followScrollView:self.tableView delay:50.0f];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setTitle:@"Whizwish"];
    
    self.buttonTopScroll.hidden = YES;
  
    self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Setting"] forViewController:self selector:@selector(settingPressed)];
    self.tableView.tableHeaderView.frame = CGRectZero;
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    self.tableView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings
    _scrollProxy.delegate = self;
    
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
   if ([segue.destinationViewController isKindOfClass:[WZMyProfileViewController class]]) {
       
       WZMyProfileViewController *profileController = (WZMyProfileViewController*)segue.destinationViewController;
    
       profileController.profileType = KWPofileTypeSelf;
    //    KWPofileTypeSelf = 0,
      //  kWProfileTypeOther
    }
    
}

#pragma mark UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WZPostTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TOP_CELL];
        
        

        
        [cell.buttonInMail addTarget:self action:@selector(inMailPressed) forControlEvents:UIControlEventTouchUpInside];

        [cell.buttonGift addTarget:self action:@selector(giftPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.buttonNotification addTarget:self action:@selector(alertPressed) forControlEvents:UIControlEventTouchUpInside];


       
        return cell;
    }
    else  {
   
        WZPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL];
        
    if (cell) {
        
        if (indexPath.row >2) {
            

      //   self.navigationItem se
        
        }
    }
        return cell;
    }
    
    
    

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.buttonTopScroll setHidden:YES];

    }
    else if (indexPath.row > 2)  {
        [self.buttonTopScroll setHidden:NO];

    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 240;
    }
    else  {
        
        return  370;
    }
}


#pragma mark Public Methods

- (void)scrollTopPressed:(id)sender {
  
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self showNavigationBar:YES];

}


#pragma mark NJKScrollView Delegate Methods

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    
    
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    
    [self moveNavigationBar:deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    self.buttonTopScroll.frame = CGRectMake(self.buttonTopScroll.frame.origin.x, 20, self.buttonTopScroll.frame.size.width, self.buttonTopScroll.frame.size.height);
    
    [self hideNavigationBar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    self.buttonTopScroll.frame = CGRectMake(self.buttonTopScroll.frame.origin.x, 64, self.buttonTopScroll.frame.size.width, self.buttonTopScroll.frame.size.height);
    
    [self showNavigationBar:YES];
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
