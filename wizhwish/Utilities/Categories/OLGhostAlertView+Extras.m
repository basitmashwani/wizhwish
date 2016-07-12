////
////  OLGhostAlertView+Extras.m
////  Yatter
////
////  Created by Syed Abdul Basit on 2016-04-05.
////  Copyright © 2016 Syed Abdul Basit. All rights reserved.
////
//
//#define DEFUALT_TIME_OUT 5
//#define DEFUALT_CONTENT_MARGIN 50.5
//#define DEFUALT_TITLE_FONT  [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15.0]
//#define DEFUALT_MESSAGE_FONT [UIFont fontWithName:@"AvenirNext-Regular" size:14.0]
//#define DEFUALT_DISMISSIBLE YES;
//
//
//
//
//@implementation OLGhostAlertView (Extras)
//
//+(OLGhostAlertView*)showAlertWithTitle:(NSString*)title message:(NSString*)message timeout:(float)timeout dismissible:(BOOL)dismissible  ContentMargin:(float)topContentMargin style:(OLGhostAlertViewStyle)style position:(OLGhostAlertViewPosition)positions titleFont:(UIFont*)titleFont messageFont:(UIFont*)messageFont
//{
//    OLGhostAlertView *alert = [[OLGhostAlertView alloc] initWithTitle:title
//                                                              message:message
//                                                              timeout:timeout
//                                                          dismissible:dismissible];
//    alert.position = positions;
//    alert.topContentMargin = topContentMargin;
//    alert.style=style;
//    // alert.backgroundColor=[RUUtility getDefaultBarButtonColor];
//    alert.titleLabel.font=titleFont;
//    alert.messageLabel.font=messageFont;
//    
//    [alert show];
//    
//    return alert;
//}
//
//+(OLGhostAlertView*)showAlertAtCenterWithTitle:(NSString*)title message:(NSString*)message {
//    UIFont *font = (title && title.length > 0)?DEFUALT_TITLE_FONT:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:0];
//    
//    OLGhostAlertView *alert = [self showAlertWithTitle:title
//                                               message:message
//                                               timeout:DEFUALT_TIME_OUT
//                                           dismissible:YES
//                                         ContentMargin:DEFUALT_CONTENT_MARGIN
//                                                 style:OLGhostAlertViewStyleDark
//                                              position:OLGhostAlertViewPositionCenter
//                                             titleFont:font
//                                           messageFont:DEFUALT_MESSAGE_FONT];
//    
//    return alert ;
//}
//+(OLGhostAlertView*)showAlertAtTopWithTitle:(NSString*)title message:(NSString*)message {
//    UIFont *font=(title && title.length > 0)?DEFUALT_TITLE_FONT:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:0];
//    
//    OLGhostAlertView *alert=[self showAlertWithTitle:title message:message timeout:DEFUALT_TIME_OUT dismissible:YES ContentMargin:DEFUALT_CONTENT_MARGIN style:OLGhostAlertViewStyleDark position:OLGhostAlertViewPositionTop titleFont:font messageFont:DEFUALT_MESSAGE_FONT ] ;
//    
//    return alert ;
//}
//+(OLGhostAlertView*)showAlertAtBottomWithTitle:(NSString*)title message:(NSString*)message {
//    UIFont *font=(title && title.length > 0)?DEFUALT_TITLE_FONT:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:0];
//    
//    OLGhostAlertView *alert=[self showAlertWithTitle:title message:message timeout:DEFUALT_TIME_OUT dismissible:YES ContentMargin:DEFUALT_CONTENT_MARGIN style:OLGhostAlertViewStyleDark position:OLGhostAlertViewPositionBottom titleFont:font messageFont:DEFUALT_MESSAGE_FONT ] ;
//    
//    return alert ;
//}
//
//+(OLGhostAlertView*)showAlertAtPosition:(OLGhostAlertViewPosition)position withTitle:(NSString*)title message:(NSString*)message timeout:(CGFloat)timeOut {
//    UIFont *font=(title && title.length > 0)?DEFUALT_TITLE_FONT:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:0];
//    
//    OLGhostAlertView *alert=[self showAlertWithTitle:title message:message timeout:timeOut dismissible:YES ContentMargin:DEFUALT_CONTENT_MARGIN style:OLGhostAlertViewStyleDark position:position titleFont:font messageFont:DEFUALT_MESSAGE_FONT ] ;
//    
//    return alert ;
//}
//
//@end
