//
//  WTextViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-11.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WTextViewController.h"
#import "NEOColorPickerViewController.h"

@interface WTextViewController ()<ColorPickerViewDelegateFlowLayout,ColorPickerViewDelegate,UITextViewDelegate>

@property(nonatomic ,assign) NSInteger count;

@property(nonatomic ,retain) ColorPickerView *textColorPickerView;

@end

@implementation WTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 15;
    [self.navigationItem setTitle:@"Text"];
    
     self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Cross"] forViewController:self selector:@selector(crossPressed)];
    
     self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    
   // CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +120, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.tag = 100;
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    
    tempView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tempView];
    
    //[self didTappedView:self.view];
    
    
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame = CGRectMake(self.view.frame.size.width-40, 80, 30, 30);
    [plusButton setImage:[UIImage imageNamed:@"Image_Plus_Grey"] forState:UIControlStateNormal];
    [tempView addSubview:plusButton];
    [plusButton addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchDown];
    
    
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(self.view.frame.size.width-80, 80, 30, 30);
    [minusButton setImage:[UIImage imageNamed:@"Image_Minus_Grey"] forState:UIControlStateNormal];
    [tempView addSubview:minusButton];
    [minusButton addTarget:self action:@selector(minusPressed) forControlEvents:UIControlEventTouchDown];

    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyBoardDidHide:)
                                                 name: UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)plusPressed {
    
    
    self.count = self.count+2;
    [self.textView setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];
    
    
}

- (void)minusPressed {
    
    if (_count >15) {
        
        
        self.count = self.count-2;
        [self.textView setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];
        
    }
    
}

#pragma KeyBoard Delegate Methods
- (void)keyBoardDidShow:(id)sender {
    
    NSLog(@"Keyboard did show");
    
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (!_textColorPickerView) {
        self.textColorPickerView  = [[ColorPickerView alloc] init];
        
        _textColorPickerView.delegate = self;
        _textColorPickerView.layoutDelegate = self;
        _textColorPickerView.scrollToPreselectedIndex = YES;
        _textColorPickerView.tag = 120;
        [self.view addSubview:_textColorPickerView];
        
    }
    _textColorPickerView.frame = CGRectMake(0, keyboardSize.height, self.view.frame.size.width, 60);
}
- (void)keyBoardDidHide:(id)sender {

    _textColorPickerView.frame = CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 60);
    }


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    if (view.tag == 100) {
        
        [self.textView resignFirstResponder];
    }
    
}
#pragma mark - Color Picker Delegate Methods

- (CGSize)colorPickerView:(ColorPickerView *)colorPickerView sizeForItemAt:(NSIndexPath *)indexPath {
    
    return CGSizeMake(30, 30);
}

- (void)colorPickerView:(ColorPickerView *)colorPickerView didSelectItemAt:(NSIndexPath *)indexPath {
    
    _textView.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)crossPressed {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPressed {
    
    if ([self.textView.text isEqualToString:@"Text"]) {
        [OLGhostAlertView showAlertAtBottomWithTitle:@"Message" message:@"Please enter text to post"];
    }
    else {
        
        [[WSetting getSharedSetting] setPostText:self.textView.text];
        
   WWizhViewController *controller =  [[UIStoryboard getWhizStoryBoard] instantiateViewControllerWithIdentifier:K_SB_WIZH_VIEW_CONTROLLER];
    
        controller.showWhiz = NO;
    [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark UITextView Delegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Text" withString:@""];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
      //  [textView resignFirstResponder];
        textView.text = [NSString stringWithFormat:@"%@\n",textView.text];
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y - 10, self.textView.frame.size.width, self.textView.frame.size.height);

        return NO;
    }
    
    
    return YES;
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

