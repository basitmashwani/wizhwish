//
//  JKSearchBar.m
//  JKSearchBar
//
//  Created by Jakey on 15/5/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "JKSearchBar.h"
#import <QuartzCore/QuartzCore.h>
@interface JKSearchBar()<UITextFieldDelegate>
{
    ////UIImageView *_iconView;
    UIImageView *_iconCenterView;
    UIImageView *_backgroundImageView;
    JKSearchBarIconAlign _iconAlignTemp;
}

@end

@implementation JKSearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidViewWithFrame:frame];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self buidViewWithFrame:self.frame];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        
    }
}
-(void)buidViewWithFrame:(CGRect)frame{

    
    self.frame = frame;
    
    _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_backgroundImageView];
  
    _cancelButton = [[UIButton alloc] initWithFrame: CGRectMake(self.frame.size.width-80, self.frame.size.height/4, 100, __textField.frame.size.height+20)];
  //  _cancelButton.frame = CGRectMake(self.frame.size.width-30, 7, 20, 20);
  //  _cancelButton.backgroundColor = [UIColor redColor];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_cancelButton addTarget:self
                     action:@selector(cancelButtonTouched)
           forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _cancelButton.hidden = NO;
    _cancelButton.alpha = 1;
    //[self sendSubviewToBack:__textField];
    //(
//    _cancelButton = ({
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(self.frame.size.width, 7, 20, 20);
//        cancelButton.backgroundColor = [UIColor redColor];
//        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [cancelButton addTarget:self
//                         action:@selector(cancelButtonTouched)
//               forControlEvents:UIControlEventTouchUpInside];
//        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        cancelButton.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
//        
//        cancelButton;
//    });
    
    
    __textField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 7, self.frame.size.width-7*2, frame.size.height-7*2)];
        textField.delegate = self;
       // textField.layer.cornerRadius = 24;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        textField.returnKeyType = UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically = YES;
        textField.font = [UIFont systemFontOfSize:14.0f];
      //  textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //for dspa
        textField.borderStyle=UITextBorderStyleNone;
       // textField.layer.cornerRadius= 17.0f;
        
        textField.layer.masksToBounds=YES;
       // textField.layer.borderColor = [[UIColor colorWithWhite:0.783 alpha:1.000] CGColor];
       // textField.layer.borderWidth= 0.5f;
        textField.backgroundColor = [UIColor whiteColor];
        
        textField;
    });
    [self addSubview:__textField];
    
    [self sendSubviewToBack:__textField];

    [self addSubview:_cancelButton];
    
    [self setIconAlign:_iconAlign];

    
    _cancelButton.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0.733 green:0.732 blue:0.756 alpha:1.000];
}
-(void)setIconAlign:(JKSearchBarIconAlign)iconAlign{
    if(!_iconAlignTemp){
        _iconAlignTemp = iconAlign;
    }
    _iconAlign = iconAlign;
    [self ajustIconWith:_iconAlign];
    
}
-(void)ajustIconWith:(JKSearchBarIconAlign)iconAlign {
    if (_iconAlign == JKSearchBarIconAlignCenter) {
        _iconCenterView.hidden = NO;
        
        __textField.frame = CGRectMake(7, 7, self.frame.size.width-7*2, self.frame.size.height-7*2);
        __textField.textAlignment = NSTextAlignmentCenter;
        __textField.layer.cornerRadius = __textField.frame.size.height/2;
        
        
        CGSize titleSize;
        if (!self.text || ![self.text isEqualToString:@""]) {
            titleSize =  [self.text sizeWithAttributes: @{NSFontAttributeName:__textField.font}];
        }else{
            titleSize =  [self.placeholder?:@"" sizeWithAttributes: @{NSFontAttributeName:__textField.font}];
            
        }
        
        CGFloat x = __textField.frame.size.width/2 - titleSize.width/2-25;
        
        if (!_iconCenterView) {
            _iconCenterView = [[UIImageView alloc]initWithImage: _iconImage ? _iconImage : [UIImage imageNamed:@"Image_Search_Icon"]];
            
            _iconCenterView.contentMode = UIViewContentModeScaleAspectFit;
          //  _iconCenterView.frame = CGRectMake(__textField.frame.size.width/4-40, __textField.frame.size.height/4, 15, 15);
        }
        if (x>0) {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            NSInteger limit = 50+self.frame.origin.x;
            _iconCenterView.frame = CGRectMake(screenRect.size.width/2-limit, (self.frame.size.height-_iconCenterView.frame.size.height)/2, 15,15);
            __textField.leftView = nil;
        } else {
         //   _iconCenterView.hidden = YES;
            CGRect frame = _iconCenterView.frame;
            _iconCenterView.frame = CGRectMake(20, frame.origin.y, frame.size.width, frame.size.height);
          //  __textField.leftView = _iconView;
        }
        
        [self addSubview:_iconCenterView];

        
    } else {
        _iconCenterView.hidden = YES;
        

        [UIView animateWithDuration:0 animations:^{
           // __textField.textAlignment = NSTextAlignmentLeft;
            _iconCenterView.hidden = NO;
            CGRect frame = _iconCenterView.frame;
            _iconCenterView.frame = CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
         //   __textField.frame = CGRectMake(100, __textField.frame.origin.y, __textField.frame.size.width, __textField.frame.size.height);
       //     _iconView = [[UIImageView alloc]initWithImage:_iconImage ? _iconImage : [UIImage imageNamed:@"Image_Search_Icon"]];
         //   _iconView.frame  = CGRectMake(100, _iconView.frame.origin.y, 15, 15);
          //  _iconView.contentMode = UIViewContentModeScaleAspectFit;
          // __textField.leftView = _iconView;
        //    __textField.leftViewMode =  UITextFieldViewModeAlways;
        }];
    }
}
-(NSString *)text{
    return __textField.text;
}

-(void)setText:(NSString *)text{
   __textField.text= text?:@"";
}
-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [__textField setFont:_textFont];
    [self setIconAlign:_iconAlign];
}

-(void)setTextBorderStyle:(UITextBorderStyle)textBorderStyle{
    _textBorderStyle = textBorderStyle;
    __textField.borderStyle = textBorderStyle;
}

-(void)setTfCornerRadius:(CGFloat)tfCornerRadius{
    _tfCornerRadius = tfCornerRadius;
   __textField.layer.cornerRadius = tfCornerRadius;
}

-(void)setTfMasksToBounds:(BOOL)tfMasksToBounds{
    _tfMasksToBounds = tfMasksToBounds;
    __textField.layer.masksToBounds = tfMasksToBounds;
}

-(void)setTfBorderColor:(UIColor*)tfBorderColor{
    _tfBorderColor = tfBorderColor;
    __textField.layer.borderColor = tfBorderColor.CGColor;
}

-(void)setTfBorderWidth:(CGFloat)tfBorderWidth{
    _tfBorderWidth = tfBorderWidth;
    __textField.layer.borderWidth = tfBorderWidth;
}

-(void)setTfBackgroundColor:(UIColor *)tfBackgroundColor{
    _tfBackgroundColor = tfBackgroundColor;
   __textField.backgroundColor = tfBackgroundColor;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [__textField setTextColor:_textColor];
}
-(void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    
    if (!__textField.leftView) {
        ((UIImageView*)__textField.leftView).image = _iconImage;
    }
    
    if (!_iconCenterView) {
        _iconCenterView.image = _iconImage;
    }
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    //__textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    __textField.placeholder = placeholder;
    
    [self setIconAlign:_iconAlign];
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    _backgroundImageView.image = backgroundImage;
}

-(void)setCancelButton:(UIButton *)cancelButton{
    if (_cancelButton) {
        [_cancelButton removeFromSuperview];
    }
    _cancelButton = cancelButton;
    [self addSubview:cancelButton];
}

-(void)setCbTitleFont:(UIFont *)cbTitleFont{
    _cbTitleFont = cbTitleFont;
    _cancelButton.titleLabel.font = cbTitleFont;
}

-(void)setCbTitleColor:(UIColor *)cbTitleColor{
    _cbTitleColor = cbTitleColor;
    [_cancelButton setTitleColor:cbTitleColor forState:UIControlStateNormal];
}

-(void)setCbBackgroundColor:(UIColor *)cbBackgroundColor{
    _cbBackgroundColor = cbBackgroundColor;
    [_cancelButton setBackgroundColor:cbBackgroundColor];
}

-(void)setCbBackgroundImage:(UIImage *)cbBackgroundImage{
    _cbBackgroundImage = cbBackgroundImage;
    [_cancelButton setBackgroundImage:cbBackgroundImage forState:UIControlStateNormal];
}

-(void)setCbTitle:(NSString *)cbTitle{
    _cbTitle = cbTitle;
    [_cancelButton setTitle:cbTitle forState:UIControlStateNormal];
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    __textField.keyboardType = _keyboardType;
}
-(void)setInputView:(UIView *)inputView{
    _inputView = inputView;
    __textField.inputView = _inputView;
}
//- (BOOL)isUserInteractionEnabled
//{
//    return YES;
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
-(void)setInputAccessoryView:(UIView *)inputAccessoryView{
    _inputAccessoryView = inputAccessoryView;
    __textField.inputAccessoryView = _inputAccessoryView;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    NSAssert(_placeholder, @"Please set placeholder before setting placeholdercolor");
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 6)
    {
        [__textField setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    else
    {
        __textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    }
}
-(BOOL)resignFirstResponder
{
    return [__textField resignFirstResponder];
}

-(void)cancelButtonTouched
{
    __textField.text = @"";
    [__textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}
-(void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type
{
    __textField.autocapitalizationType = type;
}
#pragma --mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_iconAlignTemp == JKSearchBarIconAlignCenter){
        self.iconAlign = JKSearchBarIconAlignLeft;
        
        
    //  _iconCenterView.frame = CGRectMake(30, _iconCenterView.frame.origin.y, 15, 15);
        
      //  _iconView.frame = _iconCenterView.frame;
        
    }
    _cancelButton.hidden = NO;
    
    if (!_cancelButtonDisabled) {
        [UIView animateWithDuration:0.1 animations:^{
            _cancelButton.hidden = NO;
            __textField.frame = CGRectMake(30, 7, __textField.frame.size.width-20, self.frame.size.height-7*2);
            __textField.textAlignment = NSTextAlignmentLeft;
//            __textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            //        _textField.transform = CGAffineTransformMakeTranslation(-_cancelButton.frame.size.width,0);
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_iconAlignTemp == JKSearchBarIconAlignCenter){
        self.iconAlign = JKSearchBarIconAlignCenter;
    }
    
    if (!_cancelButtonDisabled) {
        [UIView animateWithDuration:0.1 animations:^{
            _cancelButton.hidden = YES;
           // __textField.frame = CGRectMake(7, 7, self.frame.size.width-7*2, self.frame.size.height-7*2);
            //        _textField.transform = CGAffineTransformMakeTranslation(-_cancelButton.frame.size.width,0);
        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [__textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}
@end
