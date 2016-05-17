//
//  OLGhostAlertView+Extras.h
//  Yatter
//
//  Created by Syed Abdul Basit on 2016-04-05.
//  Copyright © 2016 Syed Abdul Basit. All rights reserved.
//

#import "OLGhostAlertView.h"

@interface OLGhostAlertView (Extras)

+(OLGhostAlertView*)showAlertWithTitle:(NSString*)title message:(NSString*)message timeout:(float)timeout dismissible:(BOOL)dismissible  ContentMargin:(float)topContentMargin style:(OLGhostAlertViewStyle)style position:(OLGhostAlertViewPosition)positions titleFont:(UIFont*)titleFont messageFont:(UIFont*)messageFont;

+(OLGhostAlertView*)showAlertAtCenterWithTitle:(NSString*)title message:(NSString*)message;

+(OLGhostAlertView*)showAlertAtTopWithTitle:(NSString*)title message:(NSString*)message;

+(OLGhostAlertView*)showAlertAtBottomWithTitle:(NSString*)title message:(NSString*)message;

+(OLGhostAlertView*)showAlertAtPosition:(OLGhostAlertViewPosition)position withTitle:(NSString*)title message:(NSString*)message timeout:(CGFloat)timeOut;


@end
