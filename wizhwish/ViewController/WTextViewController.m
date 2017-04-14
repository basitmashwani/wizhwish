//
//  WTextViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-11.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WTextViewController.h"
#import <NEOColorPickerViewController.h>

@interface WTextViewController ()<NEOColorPickerViewControllerDelegate>

@property(nonatomic ,assign) NSInteger count;

@end

@implementation WTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 15;
    [self.navigationItem setTitle:@"Text"];
    
     self.navigationItem.leftBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Cross"] forViewController:self selector:@selector(crossPressed)];
    
     self.navigationItem.rightBarButtonItem =  [RUUtility getBarButtonWithImage:[UIImage imageNamed:@"Image_Next"] forViewController:self selector:@selector(nextPressed)];
    
   // CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +120, self.view.frame.size.width, self.view.frame.size.height);
    
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    
    tempView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tempView];
    
    [self didTappedView:self.view];
    
    UIButton *colorPicker = [UIButton buttonWithType:UIButtonTypeCustom];
    colorPicker.frame = CGRectMake(10, 80, 30, 30);
    [colorPicker setImage:[UIImage imageNamed:@"Image_Pencil_Disable"] forState:UIControlStateNormal];
    [tempView addSubview:colorPicker];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame = CGRectMake(self.view.frame.size.width/2-40, 80, 30, 30);
    [plusButton setImage:[UIImage imageNamed:@"Image_Plus"] forState:UIControlStateNormal];
    [tempView addSubview:plusButton];
    [plusButton addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchDown];
    
    
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(self.view.frame.size.width/1.5-30, 80, 30, 30);
    [minusButton setImage:[UIImage imageNamed:@"Image_Minus"] forState:UIControlStateNormal];
    [tempView addSubview:minusButton];
    [minusButton addTarget:self action:@selector(minusPressed) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    [colorPicker addTarget:self action:@selector(colorChanged) forControlEvents:UIControlEventTouchDown];

    

    // Do any additional setup after loading the view.
}

- (void)colorChanged {
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor =  [UIColor redColor];//self.currentColor;
    controller.title = @"Whizwish";
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:controller];
    [RUUtility setUpNavigationBar:navCon];
    [self presentViewController:navCon animated:YES completion:nil];
    
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

#pragma mark - Color Picker Delegate Methods
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color {
    
    NSLog(@"selected color");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    self.textView.textColor = color;
}
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didChangeColor:(UIColor *)color {
    
    NSLog(@"changed color");
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)crossPressed {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextPressed {
    
    if ([self.textView.text isEqualToString:@"Enter Text"]) {
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
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
   
    if ([textView.text isEqualToString:@"Enter Text"]) {
    
     textView.text = @"";
    
    }
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
