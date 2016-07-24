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
    
    
    
    return myView;
}


- (IBAction)textPressed:(id)sender {
    
}

- (IBAction)audioPressed:(id)sender {
    
}
- (IBAction)videoPressed:(id)sender {
    
}
- (IBAction)goOnlinePressed:(id)sender {
    
}
- (IBAction)photoPressed:(id)sender {
    
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
