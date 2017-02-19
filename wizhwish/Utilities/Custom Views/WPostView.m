//
//  WPostView.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2016-07-23.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "WPostView.h"


@interface WPostView ()

@end

@implementation WPostView

+ (WPostView *)getPostView {
  
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"WPostView"
                                                      owner:self
                                                    options:nil];
    
    
    WPostView* myView = [ nibViews objectAtIndex: 0];
    
    [myView.buttonChat setRoundCornersAsCircle];
    [myView.buttonVideo setRoundCornersAsCircle];
    [myView.buttonPhoto setRoundCornersAsCircle];
    [myView.buttonAudio setRoundCornersAsCircle];
    [myView.buttonGoOnline setRoundCornersAsCircle];
    [myView.buttonText setRoundCornersAsCircle];


    
    
    
    
    return myView;
}


- (IBAction)textPressed:(id)sender {
    
    WTextViewController *controller = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_TEXT_VIEW_CONTROLLER];
    
    [self.parentController.navigationController pushViewController:controller animated:YES];
}

- (IBAction)audioPressed:(id)sender {
    
    WRecordAudioViewController *controller = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_RECORD_VIEW_CONTROLLER];
    
    [self.parentController.navigationController pushViewController:controller animated:YES];
}
- (IBAction)videoPressed:(id)sender {
    WVideoRecordViewController *controller = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_VIDEO_RECORD_VIEW_CONTROLLER];
    
    [self.parentController.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)goOnlinePressed:(id)sender {
    
}
- (IBAction)photoPressed:(id)sender {
    
    WPhotoViewController *controller = [[UIStoryboard getMediaStoryBoard] instantiateViewControllerWithIdentifier:K_SB_PHOTO_VIEW_CONTROLLER];
    
    [self.parentController.navigationController pushViewController:controller animated:YES];
}
- (IBAction)chatPressed:(id)sender {
    
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
