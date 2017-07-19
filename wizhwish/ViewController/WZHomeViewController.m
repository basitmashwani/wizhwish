//
//  WHomeViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-04-20.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#define k_TABLEVIEW_HEIGHT_TEXT                 200;

#define k_TABLEVIEW_HEIGHT_TEXT_COMMENT         230;

#define k_TABLEVIEW_HEIGHT_IMAGE                500;

#define k_TABLEVIEW_HEIGHT_IMAGE_COMMENT        550;

#define k_TABLEVIEW_HEIGHT_VIDEO                430;

#define k_TABLEVIEW_HEIGHT_VIDEO_COMMENT        480;

#import "WZHomeViewController.h"
#import "UIView+Extras.h"
//#import "RUReachability.h"
#import "UIImageView+AFNetworking.h"
#import "SCVideoPlayerView.h"
#import "SCPlayer.h"
#import <ASPVideoPlayer/ASPVideoPlayer-Swift.h>
#import "UIView+WebVideoCache.h"
//#import "InstagramVideoView.h"
//#import "CommonVideoView.h"
#import <PBJVideoPlayer/PBJVideoPlayer.h>
#import "WTopViewController.h"
#import "WMyDailiesViewController.h"
@import AVFoundation;
@import AVKit;

@interface WZHomeViewController()

@property(nonatomic ,retain) NJKScrollFullScreen *scrollProxy;

@property(nonatomic ,retain) WPostView *myView;


@property(nonatomic) NSInteger offSetValue;

@property(nonatomic ,retain) NSArray *postArray;

@property(nonatomic) NSInteger viewHeight;

@property(nonatomic) BOOL canScrollTop;

@property(nonatomic) BOOL isHide;

@property(nonatomic) BOOL canFetch;

@property(nonatomic ,retain) NSArray *imagesArray;

@property(nonatomic ,retain) AVPlayer *player;

@property(nonatomic ,retain) AVAudioPlayer *audioPlayer;

@property(nonatomic ,retain) WZPostTableViewCell *tempCell;

@property(nonatomic ,retain) WMyDailiesViewController *myDailies;


@end
@implementation WZHomeViewController

#pragma mark Private Methods

- (WMyDailiesViewController*)getDailiesView {
    
    if (!self.myDailies) {
        
        self.myDailies = [self.storyboard instantiateViewControllerWithIdentifier:k_SB_MYDAILIES_VC];
   
    }
    return _myDailies;
}
- (void)setupSegmentControl {
    
    self.segmentControl.sectionTitles = @[@"Timeline",@"What's On"];
    [self.segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentControl.selectionIndicatorHeight = 1.0;
    self.segmentControl.selectionIndicatorColor = [UIColor lightGrayColor];
    
    __weak typeof(self) weakSelf = self;
    self.segmentControl.indexChangeBlock = ^(NSInteger index) {
        
        WMyDailiesViewController *dailiesView = [weakSelf getDailiesView];

        if (index == 0) {
            
            [dailiesView removeFromParentViewController];
            [dailiesView.view removeFromSuperview];
            weakSelf.tableView.alpha = 1.0;
            
        }
        else {
           
            weakSelf.tableView.alpha = 0.0;
           
                [weakSelf addChildViewController:dailiesView];
                [dailiesView.view setClipsToBounds:YES];
                [dailiesView didMoveToParentViewController:weakSelf];
            dailiesView.view.frame = weakSelf.tableView.frame;
                [weakSelf.view addSubview:dailiesView.view];
            [weakSelf.view bringSubviewToFront:weakSelf.myView];
            //    //

            
            
            
            
        }
        
    };
}


- (void)addAudioToCell:(WZPostTableViewCell *)cell audioURL:(NSString*)url imageURL:(NSString*)imageURL {
    
    [cell setupAudioPlayer:url];
    [cell.audioImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Image_Audio_Placeholder"]];
}

- (void)addVideoToCell:(WZPostTableViewCell *)cell videoURL:(NSString*)url secondVideoURL:(NSString*)secondURL {
    NSLog(@"video adding");
    
    cell.postVideoView.backgroundColor = [UIColor blackColor];
    [cell.postVideoView setURL:[NSURL URLWithString:url]];
    [cell.postVideoView setMuted:YES];
    [cell.postVideoView setEndAction:AWEasyVideoPlayerEndActionLoop];
  //  [cell.postVideoView jp_playVideoMutedWithURL:[NSURL URLWithString:url]];
    
   // cell.postVideoView.backgroundColor = [UIColor lightGrayColor];
    //[cell.postVideoView playVideoWithURL:[NSURL URLWithString:url] isSecondURL:NO];
    //InstagramVideoView *videoView = [[InstagramVideoView alloc] initWithFrame:cell.postVideoView.frame];
    //videoView.backgroundColor = [UIColor grayColor];
   // [cell.postVideoView addSubview:videoView];
  
    
  //  [videoView playVideoWithURL:[NSURL URLWithString:url]];
 //   [cell.postVideoView jp_playVideoMutedWithURL:[NSURL URLWithString:url]];
    // [cell.postVideoView.videoPlayerControls.videoPlayer stopVideo];
  // cell.postVideoView.videoURLs = @[[NSURL URLWithString:url]];
////
 
    
    if (secondURL) {
        
      //   self.player = [AVPlayer playerWithURL:[NSURL URLWithString:secondURL]];
       // AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
       // playerLayer.frame = CGRectMake(0, cell.postVideoView.frame.size.height - 150, 100, 100);
       // [cell.postVideoView.layer addSublayer:playerLayer];
        
      //  [self.player play];
      //  WZVideoView *videoView = [[WZVideoView alloc] initWithFrame:CGRectMake(0, cell.postVideoView.frame.size.height - 150, 100, 100)];
      //  [cell.postVideoView.layer addSublayer:videoView.layer];
      //  [videoView playVideoWithURL:[NSURL URLWithString:secondURL] isSecondURL:YES];
    }
    
   }

- (void)getPostWithLimit:(NSInteger)limit {
    
    __weak typeof(self) weakSelf = self;
    [[WZServiceParser sharedParser] processGetWhizPostWithLimit:limit success:^(NSDictionary *dict) {
        
        //  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        NSArray *array = [dict valueForKey:@"data"];
        if (array.count > 0) {
            
            weakSelf.postArray =  [weakSelf.postArray arrayByAddingObjectsFromArray:array];
            weakSelf.canFetch = YES;
            [weakSelf.tableView reloadData];
          //  WZPost *post = [WZServiceParser getDataFromDictionary:dict haveComments:YES];


        }
        else {
            weakSelf.canFetch = NO;
        }


    } failure:^(NSError *error) {
        
        // [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Unable to load posts"];
        
    }];
}
- (void)playViewAnimateSound:(BOOL)up {
    
    NSString *soundFileName;
    if (up) {
        soundFileName = @"1";
    }
    else {
        soundFileName = @"2";
    }
    
    // Build URL to the sound file we are going to play
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"wav"];

    NSURL *soundFile = [[NSURL alloc] initFileURLWithPath:bundlePath];

    
    // Play it
   _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    //[_audioPlayer play];
}
- (void)hidePressed {
    
    __weak typeof(self) weakSelf = self;
   
    [self.tableView setScrollEnabled:YES];
   
    if (!self.isHide) {
        
        [self playViewAnimateSound:YES];
      //  self.topConstant.constant = -150;
       // self.collectionView.hidden = YES;
        
        
    self.myView.buttonWhatOn.alpha = 0;
    self.myView.buttonMessage.alpha = 0;
    [self.myView.buttonNotification setImage:[UIImage imageNamed:@"Image_Profile"] forState:UIControlStateNormal];
    [self.myView.buttonGift setImage:[UIImage imageNamed:@"Image_SearchBar"] forState:UIControlStateNormal];
    [self.myView.buttonMenu setImage:[UIImage imageNamed:@"Image_Lamp"] forState:UIControlStateNormal];
        self.isHide = YES;
        
        //CGRect frame = self.myView.buttonMenu.frame;
        self.myView.topSpace.constant = -15;
      //  NSLog(@"Frame %ld",(long)self.myView.frame.origin.y);
       //
        //Update button Frames for View
        
        self.myView.leftButtonWidth.constant = 36;
        self.myView.leftButtonHeight.constant = 36;
        self.myView.leftButtonyAxis.constant = -5;
        
        
        self.myView.rightButtonWidth.constant = 36;
        self.myView.rightButtonHeight.constant = 36;
        self.myView.rightButtonyAxis.constant = -5;
        
     //   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
       
        
        
        
        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
             weakSelf.myView.center = CGPointMake(weakSelf.myView.center.x, weakSelf.myView.center.y + weakSelf.myView.frame.size.height - self.viewHeight);
            
            self.collectionView.center = CGPointMake(weakSelf.collectionView.center.x, weakSelf.collectionView.center.y-weakSelf.collectionView.frame.size.height);

           // [weakSelf.collectionView setFrameY:-20];
           // _tableView.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);

            
        } completion:^(BOOL finished) {
            
        }];

    }
    else {
        
        if (self.canScrollTop) {
            
            
            [self playViewAnimateSound:NO];
            [self.tableView setScrollEnabled:NO];
            //[self scrollTopPressed:self];
           
        }
        self.topConstant.constant = 0;
        self.collectionView.hidden = NO;
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
            
            weakSelf.myView.center = CGPointMake(weakSelf.myView.center.x, weakSelf.myView.center.y - weakSelf.myView.frame.size.height+self.viewHeight);
          //  _tableView.contentInset = UIEdgeInsetsMake(_offSetValue, 0, 0, 0);
            self.collectionView.center = CGPointMake(weakSelf.collectionView.center.x, weakSelf.collectionView.center.y+weakSelf.collectionView.frame.size.height);

            if(IS_IPHONE_5) {
                
                _offSetValue = _offSetValue+30;
                
              //  [self.tableView setContentOffset:CGPointMake(0, -30)];

                //[self.tableView setContentOffset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
                self.automaticallyAdjustsScrollViewInsets = NO;
                
            }
            else {
                
              //  [self.tableView setContentOffset:CGPointMake(0, -30)];
                
            }
            
            [self showNavigationBar:YES];


            
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

    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Are you want to logout?"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
   
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *loginController = [[UIStoryboard getLoginStoryBoard] instantiateViewControllerWithIdentifier:K_SB_LOGIN_VIEW_CONTROLLER];
        
        [RUUtility setMainRootController:loginController];

        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   }

- (void)intialSetup {
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
    
   // [self.tableView setContentInset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myView = [WPostView getPostView];
    self.myView.parentViewController = self;
    if(IS_IPHONE_6_PLUS) {
        self. myView.frame = CGRectMake(0, 300, self.view.frame.size.width, 450);
        
        self.viewHeight = 100;
    }
    else if(IS_IPHONE_6) {
        
        self.myView.frame = CGRectMake(0, 160, self.view.frame.size.width, 520);
        
        
        self.viewHeight = 60;
        
    }
    else if(IS_IPHONE_5) {
        
        self.myView.frame = CGRectMake(0, 160, self.view.frame.size.width, 420);
        
        
        self.viewHeight = 60;
        //   [self.tableView setContentInset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
        //  self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    [self.myView.buttonHidden addTarget:self action:@selector(hidePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.myView];
    
    [self.tableView setScrollEnabled:NO];

}

#pragma Life Cycle Methods


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    self.postArray = [[NSArray alloc] init];
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  //  [(ScrollingNavigationController *)self.navigationController followScrollView:self.tableView delay:50.0f];
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    [self getPostWithLimit:self.postArray.count];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSegmentControl];
//    [self addChildViewController:_videoView];
//    [_videoView.view setClipsToBounds:YES];
//    [_videoView didMoveToParentViewController:self];
//    [self.view addSubview:_videoView.view];
//    //
//    
    
  
   // self.segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
   // self.segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;


    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, 320, 100) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[WZFriendCollectionViewCell class] forCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL];
    
    [self.view addSubview:_collectionView];

    
   // [[RUReachabilityManager sharedManager] addControllerToShowNetworkStatus:self];

    [self intialSetup];
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    
    NSLog(@"number of post %ld",(unsigned long)_postArray.count);
    return self.postArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        NSDictionary *postDict = [self.postArray objectAtIndex:indexPath.row];
        WZPost *post = [WZServiceParser getDataFromDictionary:postDict haveComments:YES];

        if ([post.postType isEqualToString:k_VIDEO_TYPE]) {
    WZPostTableViewCell *postCell = (WZPostTableViewCell *)cell;
    [postCell.postVideoView play];
    }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
    NSDictionary *postDict = [self.postArray objectAtIndex:indexPath.row];
    WZPost *post = [WZServiceParser getDataFromDictionary:postDict haveComments:YES];
    if ([post.postType isEqualToString:k_VIDEO_TYPE])  {
        
//        WZPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k_POST_TABLEVIEW_CELL_VIDEO];
//     //   [cell.postVideoView removeFromSuperview];
       // [cell.postVideoView.videoPlayerControls.videoPlayer stopVideo];
        
    }
    else if ([post.postType isEqualToString:k_AUDIO_TYPE]) {
        WZPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k_POST_TABLEVIEW_CELL_AUDIO];
        [cell.audioPlayer.audioPlayer stop];

        
    }
    }
    
    
    
    if (indexPath.row == 0) {
        [self.buttonTopScroll setHidden:YES];
        
    }
    else if (indexPath.row > 2)  {
        // [self.buttonTopScroll setHidden:NO];
        
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
        WZPostTableViewCell *cell = nil;
        
        
        NSUInteger index = indexPath.row;
       NSDictionary *postDict = [self.postArray objectAtIndex:index];
        WZPost *post = [WZServiceParser getDataFromDictionary:postDict haveComments:YES];
        
        
        
        if (![NSString isStringNull:post.userProfileURL]) {
      
            NSURL *url = [NSURL URLWithString:post.userProfileURL];
        
        [cell.imageViewProfile setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Image_Profile-1"]];
        
        }
        else {
            
            [cell.imageViewProfile setImage:[UIImage imageNamed:@"Image_Profile-1"]];
        }
        
         if ([post.postType isEqualToString:k_TEXT_TYPE]) {
            cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL_TEXT];
            cell.isText = YES;
            cell.labelPostText.text = post.postText;
            cell.labelPostText.text =  [cell.labelPostText.text stringByReplacingOccurrencesOfString:@"~" withString:@"\n"];
        }
        else if ([post.postType isEqualToString:k_IMAGE_TYPE]) {
        
            cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL_IMAGE];
            
            cell.imageViewPost.hidden = NO;
          
            NSArray *imagesArray = [post.mediaDictionary valueForKey:@"images"];
           
            
            cell.imageArray = [[NSArray alloc] initWithArray:imagesArray];
            [cell setUpImagePager];
            [cell.imageViewPost reloadData];
            
              

          //  [cell.imageViewPost setImageWithURL:[NSURL URLWithString:imagesArray.firstObject]];
            
            cell.isText = NO;
        }
        else if ([post.postType isEqualToString:k_VIDEO_TYPE]) {
           
            cell = [tableView dequeueReusableCellWithIdentifier:k_POST_TABLEVIEW_CELL_VIDEO];
          //  [cell.imageViewPost setHidden:YES];
            NSString *videoURL = [post.mediaDictionary valueForKey:@"backendVideo"];
            NSArray *array = [videoURL componentsSeparatedByString:@"_SECONDURL_"];
            
            NSString *secondURL = nil;
            if (array.count > 1) {
                
                secondURL = array[1];
                videoURL = array[0];
            }

            [self addVideoToCell:cell videoURL:videoURL secondVideoURL:secondURL];
          //  [cell addSubview:view];
           // cell.labelPostText.text = @"Syed";
            
 
        }
        else if ([post.postType isEqualToString:k_AUDIO_TYPE]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:k_POST_TABLEVIEW_CELL_AUDIO];
            //  [cell.imageViewPost setHidden:YES];
            NSString *audioURL = [post.mediaDictionary valueForKey:@"audio"];
            NSString *audioImage = [post.mediaDictionary valueForKey:@"audioImage"];
            //cell.backgroundView = [UIColor redColor];
            [self addAudioToCell:cell audioURL:audioURL imageURL:audioImage];
            // cell.labelPostText.text = @"Syed";
            
            
        }
        else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:K_POST_TABLEVIEW_CELL_TEXT];

        }
        self.tempCell = cell;

        cell.labelProfileName.text = post.displayName;
        cell.labelPostDate.text = post.createdDate;
        cell.labelPostTitle.text = @"Post";
        cell.labelOtherComment.text = [NSString stringWithFormat:@"%@ more",post.commentCount];
        
        if (post.commentCount.integerValue>0) {
            
            cell.labelCommentTitle.text = post.postComment.displayName;
            cell.labelComment.text = post.postComment.commentText;
            
        }
        else {
            cell.labelComment.hidden = YES;
            
            cell.labelCommentTitle.hidden = YES;
            
        }
        
        if (post.commentCount.integerValue>1) {
            
            cell.labelOtherComment.hidden = NO;
        }
        else {
            cell.labelOtherComment.hidden = YES;
            
        }

        
      //  cell.imageViewProfile.image ;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(commentPressed:)];
        [tap setNumberOfTapsRequired:1];
        [cell.labelOtherComment addGestureRecognizer:tap];
        
        cell.buttonComment.tag = [post.postId integerValue];
        
        [cell.buttonComment addTarget:self action:@selector(commentPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
            if(indexPath.row == self.postArray.count)
            {
                //  NSLog(@"last row %ld with post last index %ld",(long)indexPath.row,self.postArray.count-1);
                [self getPostWithLimit:indexPath.row];
                
                
            }
        
        return cell;
    
    
    
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        
        NSInteger index = indexPath.row;
       NSDictionary *postDict = [self.postArray objectAtIndex:index];
        WZPost *post = [WZServiceParser getDataFromDictionary:postDict haveComments:YES];
        
        if ([post.postType isEqualToString:k_TEXT_TYPE]) {
        
            
            if (post.commentCount.integerValue > 1) {
                
                return k_TABLEVIEW_HEIGHT_TEXT;
            }
            
            if ([post.postText getOccuranceCountOfSubString:@"~"] > 1) {
                
                NSInteger height = k_TABLEVIEW_HEIGHT_TEXT;
                height = height+[post.postText getOccuranceCountOfSubString:@"~"] *5;

                return  height;
            }
            return k_TABLEVIEW_HEIGHT_TEXT_COMMENT;
        }
        else if ([post.postType isEqualToString:k_IMAGE_TYPE]) {
       
            if (post.commentCount.integerValue > 0) {
                
                return k_TABLEVIEW_HEIGHT_IMAGE_COMMENT;
            }

            
            return  k_TABLEVIEW_HEIGHT_IMAGE;
    }
        else if([post.postType isEqualToString:k_VIDEO_TYPE]) {
         
            if (post.commentCount.integerValue > 0) {
                
                return k_TABLEVIEW_HEIGHT_VIDEO_COMMENT;
            }
            
            
            return  k_TABLEVIEW_HEIGHT_VIDEO;
        }
        
        else if([post.postType isEqualToString:k_AUDIO_TYPE]) {
            
            if (post.commentCount.integerValue > 0) {
                
                return k_TABLEVIEW_HEIGHT_VIDEO_COMMENT;
            }
            
            
            return  k_TABLEVIEW_HEIGHT_VIDEO;
        }
        
        
        return tableView.estimatedRowHeight;
    
}



#pragma mark - UIScrollView Delegate Methods

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

- (void)segmentedControlChangedValue:(id)sender {
    
}
- (void)commentPressed:(id)sender {
    
    NSInteger buttonTag = -1;
    if ([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton*)sender;
        buttonTag = button.tag;

    }
    else {
       
        UILabel *label = (UILabel*)sender;
        buttonTag = label.tag;
    }
    
    [self showNavigationBar:YES];
    WCommentsViewController *commentController = [[UIStoryboard getHomeStoryBoard] instantiateViewControllerWithIdentifier:K_SB_COMMENTS_VIEW_CONTROLLER];
    commentController.postId = [NSString stringWithFormat:@"%ld",(long)buttonTag];
    [self.navigationController pushViewController:commentController animated:YES];
}
- (void)scrollTopPressed:(id)sender {
  
  //  [self.tableView setContentOffset:CGPointZero animated:YES];
  
    if(IS_IPHONE_5) {
        
        _offSetValue = _offSetValue+30;
        
        //[self.tableView setContentOffset:CGPointMake(0, -30)];
        //[self.tableView setContentOffset:UIEdgeInsetsMake(_offSetValue, 0, 0, 0)]; // 108 is only example
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    else {
       
        //[self.tableView setContentOffset:CGPointMake(0, -30)];

    }
    
    [self showNavigationBar:YES];
    
    
    

}


#pragma mark UICollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];
    [cell.buttonPeople setUserInteractionEnabled:NO];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image_Search"]];
    imgView.frame = CGRectMake(10, 10, 70 , 70);
    [cell addSubview:imgView];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/4.5 , collectionView.frame.size.height);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Sedas");
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
