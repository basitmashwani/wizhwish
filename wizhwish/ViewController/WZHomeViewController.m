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

@property(nonatomic ,retain) WPostView *myView;

@property(nonatomic) NSInteger offSetValue;

@property(nonatomic) BOOL canScrollTop;

@property(nonatomic) NSInteger *counter;

@property(nonatomic) BOOL isHide;

@end
@implementation WZHomeViewController

#pragma mark Private Methods

- (void)hidePressed {
    
    __weak typeof(self) weakSelf = self;
   
    [self.tableView setScrollEnabled:YES];
   
    if (!self.isHide) {
        
    
    self.myView.buttonWhatOn.alpha = 0;
    self.myView.buttonMessage.alpha = 0;
    [self.myView.buttonNotification setImage:[UIImage imageNamed:@"Image_Profile"] forState:UIControlStateNormal];
    [self.myView.buttonGift setImage:[UIImage imageNamed:@"Image_SearchBar"] forState:UIControlStateNormal];
    [self.myView.buttonMenu setImage:[UIImage imageNamed:@"Image_Lamp"] forState:UIControlStateNormal];
        self.isHide = YES;
        
        CGRect frame = self.myView.buttonMenu.frame;
        NSLog(@"Frame %ld",(long)frame.origin.y);
      //  self.myView.buttonMenu.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
        self.myView.topSpace.constant = -15;
        NSLog(@"Frame %ld",(long)self.myView.frame.origin.y);
       
        //Update button Frames for View
        
        self.myView.leftButtonWidth.constant = 36;
        self.myView.leftButtonHeight.constant = 36;
        self.myView.leftButtonyAxis.constant = -5;
        
        
        self.myView.rightButtonWidth.constant = 36;
        self.myView.rightButtonHeight.constant = 36;
        self.myView.rightButtonyAxis.constant = -5;

        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            weakSelf.myView.center = CGPointMake(weakSelf.myView.center.x, weakSelf.myView.center.y + weakSelf.myView.frame.size.height - 60);
            
        } completion:^(BOOL finished) {
            
        }];

    }
    else {
        
        if (self.canScrollTop) {
            
            
            [self.tableView setScrollEnabled:NO];
            [self scrollTopPressed:self];
        }
        self.myView.buttonWhatOn.alpha = 1;
        self.myView.buttonMessage.alpha = 1;
        [self.myView.buttonNotification setImage:[UIImage imageNamed:@"Image_Alerts"] forState:UIControlStateNormal];
        [self.myView.buttonGift setImage:[UIImage imageNamed:@"Image_Gifts"] forState:UIControlStateNormal];
        [self.myView.buttonMenu setImage:[UIImage imageNamed:@"Image_Lamp2"] forState:UIControlStateNormal];
        self.isHide = NO;
        
        self.myView.topSpace.constant = 10;
        self.myView.leftButtonWidth.constant = 35;
        self.myView.leftButtonHeight.constant = 35;
        self.myView.leftButtonyAxis.constant = 0;
        
        
        self.myView.rightButtonWidth.constant = 35;
        self.myView.rightButtonHeight.constant = 35;
        self.myView.rightButtonyAxis.constant = 0;


        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            weakSelf.myView.center = CGPointMake(weakSelf.myView.center.x, weakSelf.myView.center.y - weakSelf.myView.frame.size.height+60);
            
        } completion:^(BOOL finished) {
            
        }];

    }
    
    
    
}
- (IBAction)showPostView:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if (self.canScrollTop) {
        
    
    [self.tableView setScrollEnabled:NO];
    [self scrollTopPressed:self];
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.myView.center = CGPointMake(weakSelf.myView.center.x, weakSelf.myView.center.y - weakSelf.myView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
     }
    
}
- (void)settingPressed {
    
}


#pragma Life Cycle Methods


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  //  [(ScrollingNavigationController *)self.navigationController followScrollView:self.tableView delay:50.0f];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.offSetValue = 30;
    
    self.canScrollTop = YES;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationItem setTitle:@"Whizwish"];
    
   // [self.tableView setContentInset:UIEdgeInsetsMake(0, -20, 0, 0)]; // 108 is only example

    
    self.buttonTopScroll.hidden = YES;
  
    self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Setting"] forViewController:self selector:@selector(settingPressed)];
    self.tableView.tableHeaderView.frame = CGRectZero;
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self]; // UIScrollViewDelegate and UITableViewDelegate methods proxy to ViewController
    self.tableView.delegate = (id)_scrollProxy; // cast for surpress incompatible warnings
    _scrollProxy.delegate = self;
    
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    // Do any additional setup after loading the view.
   
     self.myView = [WPostView getPostView];
    self.myView.parentViewController = self;
    if(IS_IPHONE_6_PLUS) {
   self. myView.frame = CGRectMake(0, 300, self.view.frame.size.width, 450);
    
    }
    else if(IS_IPHONE_6) {
     
        self.myView.frame = CGRectMake(0, 280, self.view.frame.size.width, 400);

    }
    else if(IS_IPHONE_5) {
       
        self.myView.frame = CGRectMake(0, 160, self.view.frame.size.width, 420);

        [self.tableView setContentInset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
        self.automaticallyAdjustsScrollViewInsets = NO;

    }
    
    [self.myView.buttonHidden addTarget:self action:@selector(hidePressed) forControlEvents:UIControlEventTouchUpInside];
    
    
 //   postView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_myView];
    
    [self.tableView setScrollEnabled:NO];
    
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
        
        

        
       


       
        return cell;
    }
    else  {
   
        WZPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL];
        
        [cell.buttonComment addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        return 110;
    }
    else  {
        
        return  370;
    }
}


#pragma mark UIScrollView Delegate Methods 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    self.canScrollTop = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingFinish];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingFinish];
}
- (void)scrollingFinish {
    //enter code here
    NSLog(@"Scroll Finish");
    self.canScrollTop = YES;
}

#pragma mark Public Methods

- (void)commentPressed:(id)sender {
    
    WCommentsViewController *commentController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_COMMENTS_VIEW_CONTROLLER];
    [self.navigationController pushViewController:commentController animated:YES];
}
- (void)scrollTopPressed:(id)sender {
  
  //  [self.tableView setContentOffset:CGPointZero animated:YES];
  
    if(IS_IPHONE_5) {
        
        _offSetValue = _offSetValue+30;
        
        [self.tableView setContentOffset:CGPointMake(0, -30)];
        //[self.tableView setContentOffset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    else {
       
        [self.tableView setContentOffset:CGPointMake(0, -30)];

    }
    
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
