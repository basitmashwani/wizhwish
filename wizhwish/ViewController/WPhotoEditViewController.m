//
//  WPhotoEditViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-01.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WPhotoEditViewController.h"

@interface WPhotoEditViewController ()<ACEDrawingViewDelegate,UITextFieldDelegate>

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) HRColorMapView *colorPicker;

@property(nonatomic ,retain) UIView *overlayView;

@property(nonatomic ,retain) UITextField *textField;

@property(nonatomic ,retain) UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain) UITapGestureRecognizer *tapGesture;

@property(nonatomic ,retain) UILabel *textLabel;

@property(nonatomic ,assign) CGPoint labelCGPoint;


@end

@implementation WPhotoEditViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self) {
        self = [super initWithCoder:aDecoder];
    }
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 80);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = self.selectedImage;
    [self.view addSubview:imageView];
    
    if(self.isDrawing) {
    _drawingView = [[ACEDrawingView alloc] initWithFrame:rect];
  
    [self.view addSubview:self.drawingView];
    
    
    self.drawingView.delegate = self;
    self.drawingView.lineWidth  = 3.0;
    self.drawingView.lineColor = [UIColor whiteColor];
    
    if (!self.colorPicker) {
        
        CGRect colorPickerRect = CGRectMake(self.drawingView.frame.origin.x, self.drawingView.frame.size.height, self.drawingView.frame.size.width, 80);
        self.colorPicker = [HRColorMapView colorMapWithFrame:colorPickerRect saturationUpperLimit:0.95];
        self.colorPicker.tileSize = [NSNumber numberWithInt:16];
        [self.view addSubview:self.colorPicker];
    }
    [self.drawingView loadImage:[[UIImage alloc] init]];
    self.colorPicker.hidden = NO;
    [self.colorPicker setFrameHeight:80];
    self.colorPicker.color = [UIColor whiteColor];
    [self.colorPicker addTarget:self action:@selector(colorChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    else {
        
        imageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        self.textLabel = [[UILabel alloc] init];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment  = NSTextAlignmentCenter;
        [self.textLabel setFrameWidth:self.view.frame.size.width];
        [self.textLabel setFrameHeight:30];
        //  self.textLabel.text = @"Text";
        self.textLabel.hidden = YES;
        
        [self.textLabel setCenter:self.view.center];
        
        [self.view addSubview:self.textLabel];
        
        
        self.textField = [[UITextField alloc] init];
        
        [self.textField setFrameWidth:self.view.frame.size.width];
        [self.textField setFrameHeight:30];
        self.textField.delegate = self;
        //  self.textField.text = @"Text";
        self.textField.placeholder = @"Text";
        self.textField.textAlignment = NSTextAlignmentCenter;
        [self.textField setCenter:self.view.center];
        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.textColor = [UIColor whiteColor];
        
        [self.view addSubview:self.textField];
        
        // self.textField.hidden = YES;
        
        [self.textField becomeFirstResponder];
        
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(labelChange:)];
        [self.textLabel setUserInteractionEnabled:YES];
        _panGesture.cancelsTouchesInView = NO;
        [self.textLabel addGestureRecognizer:_panGesture];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelPressed:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.cancelsTouchesInView = NO;
        [self.textLabel addGestureRecognizer:_tapGesture];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyBoardDidShow:)
                                                     name: UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (keyBoardDidHide:)
                                                     name: UIKeyboardDidHideNotification
                                                   object:nil];
        
    }
    
    [RUUtility setBackButtonForController:self withSelector:@selector(backBtnPressed)];
    
   self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Save" forViewController:self selector:@selector(savePressed)];
    
   
    
    

    
    
}


- (void)savePressed {
    
    
    if ([self.delegate respondsToSelector:@selector(PhotoEditViewController:didSaveImage:withIndex:)]) {
        
        UIImage *image = nil;
        
        if (self.isDrawing) {
            
      image =  [UIImage drawImage:self.selectedImage inImage:self.drawingView.image atPoint:CGPointMake(self.selectedImage.size.width , self.selectedImage.size.height)];
        }
        else {
            
            image = [UIImage drawToImage:self.selectedImage withText:self.textLabel.text withFrame:self.textLabel.frame];
        }
        [self.delegate PhotoEditViewController:self didSaveImage:image withIndex:self.selectedIndex];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

- (void)labelPressed:(id)sender {
    
    
   // self.textLabel.hidden = YES;
   // self.textField.hidden = NO;
   // [self.textField becomeFirstResponder];
    
   // [self.view addSubview:self.overlayView];
       
       self.textField.placeholder = @"Enter Text";
        self.textField.delegate = self;
        self.textField.textColor = [UIColor whiteColor];
        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.textAlignment = NSTextAlignmentCenter;
    //
        self.overlayView  = [[UIView alloc] initWithFrame:self.view.frame];
        self.overlayView.backgroundColor = [UIColor grayColor];
        self.overlayView.alpha = 0.3;
        [self didTappedView:self.overlayView];

}

- (void)labelChange:(id)sender {
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer*)sender;
    self.labelCGPoint = [recognizer locationInView:self.view];
    
   // if (recognizer.state == UIGestureRecognizerStateEnded) {
    CGRect rect = CGRectMake(self.view.frame.origin.x-8, self.view.frame.origin.y - 8, self.view.frame.size.width - 8, self.view.frame.size.height - 8);
    
    if (CGRectContainsPoint(rect, self.labelCGPoint)) {
        
        self.textLabel.center = self.labelCGPoint;
        
    }
    
   // }

    }
#pragma KeyBoard Delegate Methods
- (void)keyBoardDidShow:(id)sender {
    
    NSLog(@"Keyboard did show");
}
- (void)keyBoardDidHide:(id)sender {
    
    //  NSLog(@"keyboard did hide");
    // [self.textLabel removeFromSuperview];
    self.textLabel.text = self.textField.text;
    [self.view bringSubviewToFront:self.textLabel];
    [self viewDidLayoutSubviews];
    self.textLabel.hidden = NO;
    [self.overlayView removeFromSuperview];
    self.textField.hidden = YES;
}


#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



- (void)backBtnPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
    // Do any additional setup after loading the view.

- (void)colorChanged:(id)sender {
    HRColorMapView *colorMap = (HRColorMapView*)sender;
    self.drawingView.lineColor = colorMap.color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
