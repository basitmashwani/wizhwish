//
//  RUOverlayView.m
//  iOSReachabilityTestARC
//
//  Created by Arslan Raza on 05/08/2015.
//
//

#import "RUOverlayView.h"

@implementation RUOverlayView

#pragma mark - Private Methods

- (void)setupGradiantColor {
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
}

- (void)setup {
    
    [self setupGradiantColor];
    
    [self setUserInteractionEnabled:YES];
}

#pragma mark - Life Cycle Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

+ (RUOverlayView*)showOnView:(UIView*)parentView {
    RUOverlayView *overlay = [[RUOverlayView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    if (overlay) {
        
        [parentView addSubview:overlay];
    }
    return overlay;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Public Methods

@end
