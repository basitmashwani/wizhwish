//
//  WPhotoEditViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-01.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//

#import "WPhotoEditViewController.h"
#import "NEOColorPickerViewController.h"

@interface WPhotoEditViewController ()<ACEDrawingViewDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ColorPickerViewDelegate,ColorPickerViewDelegateFlowLayout>

@property(nonatomic ,retain) ACEDrawingView *drawingView;

@property(nonatomic ,retain) HRColorMapView *colorPicker;

@property(nonatomic ,retain) UIView *overlayView;

@property(nonatomic ,retain) UITextView *textField;

@property(nonatomic ,retain) UIPanGestureRecognizer *panGesture;

@property(nonatomic ,retain) UITapGestureRecognizer *tapGesture;

@property(nonatomic ,retain) UILabel *textLabel;

@property(nonatomic ,assign) CGPoint labelCGPoint;

@property(nonatomic ,retain) UIView *colorView;

@property(nonatomic ,retain) UIButton *undoButton;

@property(nonatomic ,retain) ColorPickerView *colorPickerView;

@property(nonatomic ,retain) ColorPickerView *textColorPickerView;

@property(nonatomic ,assign) NSInteger count;


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
    
    self.navigationItem.title = self.titleName;
    
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.count = 15;
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    self.view.tag = 100;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_selectedImage];
    imageView.frame = rect;
    imageView.tag = 100;
    [self.view addSubview:imageView];
    
   // [self didTappedView:imageView];
    
    
    
    
    
    
    if(self.isDrawing) {
        
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +30, self.view.frame.size.width, self.view.frame.size.height - 30);
        
        
        _drawingView = [[ACEDrawingView alloc] initWithFrame:rect];
        
        [self.view addSubview:self.drawingView];
        
        
        self.drawingView.delegate = self;
        self.drawingView.lineWidth  = 3.0;
        self.drawingView.lineColor = [UIColor whiteColor];
        
        //if (!self.colorPicker) {
        
        //            CGRect colorPickerRect = CGRectMake(0, 0, self.drawingView.frame.size.width, 480);
        //            self.colorPicker = [HRColorMapView colorMapWithFrame:colorPickerRect];
        //            self.colorPicker.tileSize = [NSNumber numberWithInt:16];
        //            [self.view addSubview:self.colorPicker];
        //}
        [self.drawingView loadImage:[[UIImage alloc] init]];
        
        self.undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.undoButton.frame = CGRectMake(rect.size.width - 40, 80, 50, 50);
        [self.undoButton setImage:[UIImage imageNamed:@"Image_Eraser"] forState:UIControlStateNormal];
        [self.view addSubview:self.undoButton];
        [self.undoButton setHidden:YES];
        [self.undoButton addTarget:self action:@selector(undoPressed) forControlEvents:UIControlEventTouchDown];
        
        self.colorPickerView = [[ColorPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -30, self.view.frame.size.width, 30)];
        self.colorPickerView.delegate = self;
        
        [self.view addSubview:self.colorPickerView];
        
    }
    else {
        
        CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height);
        imageView.frame = rect;
        
        
        
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame = CGRectMake(self.view.frame.size.width-80, 80, 30, 30);
        [plusButton setImage:[UIImage imageNamed:@"Image_Plus"] forState:UIControlStateNormal];
        [self.view addSubview:plusButton];
        [plusButton addTarget:self action:@selector(plusPressed) forControlEvents:UIControlEventTouchDown];
        
        
        
        UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        minusButton.frame = CGRectMake(self.view.frame.size.width-40, 80, 30, 30);

        [minusButton setImage:[UIImage imageNamed:@"Image_Minus"] forState:UIControlStateNormal];
        [self.view addSubview:minusButton];
        [minusButton addTarget:self action:@selector(minusPressed) forControlEvents:UIControlEventTouchDown];
        
        
        
        
        
        
        
        self.textLabel = [[UILabel alloc] init];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment  = NSTextAlignmentCenter;
        [self.textLabel setFrameWidth:self.view.frame.size.width];
        [self.textLabel setFrameHeight:100];
        [self.textLabel setNumberOfLines:0];
        //  self.textLabel.text = @"Text";
        self.textLabel.hidden = YES;
        
        [self.textLabel setCenter:CGPointMake(self.view.center.x, self.view.center.y - 40)];
        
        [self.view addSubview:self.textLabel];
        
        
        self.textField = [[UITextView alloc] init];
        
        [self.textField setFrameWidth:self.view.frame.size.width];
        [self.textField setFrameHeight:100];
        self.textField.delegate = self;
        self.textField.text = @"Text";
        [self.textField setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:23]];
        
        //  self.textField.placeholder = @"Text";
        self.textField.textAlignment = NSTextAlignmentCenter;
        [self.textField setCenter:CGPointMake(self.view.center.x, self.view.center.y - 30)];
        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.backgroundColor = [UIColor clearColor];
        
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
    
    self.navigationItem.rightBarButtonItem = [RUUtility getBarButtonWithTitle:@"Done" forViewController:self selector:@selector(savePressed)];
    
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject] locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    if (view.tag == 100) {
        
        [self.textField resignFirstResponder];
    }

}

- (void)plusPressed {
    
    
        self.count = self.count+2;
        [self.textField setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];
        [self.textLabel setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];

    
}

- (void)minusPressed {
    
    if (_count >15) {
        
    
    self.count = self.count-2;
    [self.textField setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];
    [self.textLabel setFont:[UIFont fontWithName:@"MicrosoftPhagsPa" size:_count]];
    
    }

}

- (void)changeFontPressed {
    
    
}
- (void)undoPressed {
    
    if (_drawingView.canUndo) {
        
        [_drawingView undoLatestStep];
        
        if (![_drawingView canUndo]) {
            self.undoButton.hidden = YES;
        }
    }
}

- (CGSize)colorPickerView:(ColorPickerView *)colorPickerView sizeForItemAt:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width/10, 30);
}
- (void)colorPickerView:(ColorPickerView *)colorPickerView didSelectItemAt:(NSIndexPath *)indexPath {
    
    NSLog(@"Did select");
    
    self.drawingView.lineColor = [colorPickerView.colors objectAtIndex:indexPath.row];
    self.textLabel.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];
    self.textField.textColor = [colorPickerView.colors objectAtIndex:indexPath.row];
}
- (void)savePressed {
    
    
    if ([self.delegate respondsToSelector:@selector(PhotoEditViewController:didSaveImage:withIndex:)]) {
        
        UIImage *image = nil;
        
        if (self.isDrawing) {
            
      image =  [UIImage drawImage:self.selectedImage inImage:self.drawingView.image atPoint:CGPointMake(self.selectedImage.size.width , self.selectedImage.size.height)];
        }
        else {
            
            image = [UIImage drawToImage:self.selectedImage withText:self.textField.text withFrame:self.textLabel.frame fontSize:_count textColor:self.textLabel.textColor];
        }
        [self.delegate PhotoEditViewController:self didSaveImage:image withIndex:self.selectedIndex];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

- (void)labelPressed:(id)sender {
    
    
    self.textLabel.hidden = YES;
    self.textField.hidden = NO;
   // [self.textField becomeFirstResponder];
    
   // [self.view addSubview:self.overlayView];
       
      // self.textField.text = @"Enter Text";
          [self.textField becomeFirstResponder];
    //
//        self.overlayView  = [[UIView alloc] initWithFrame:self.view.frame];
//        self.overlayView.backgroundColor = [UIColor grayColor];
//        self.overlayView.alpha = 0.3;
//        [self didTappedView:self.overlayView];

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


#pragma mark - ACEDrawingView Delegate Methods
- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool {
    
    if (view.canUndo) {
        
        [self.undoButton setHidden:NO];
        
    }
    else {
        
        [self.undoButton setHidden:YES];
    }
}




#pragma Mark - UITExtview Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //  [textView resignFirstResponder];
        textView.text = [NSString stringWithFormat:@"%@\n",textView.text];
        self.textField.frame = CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y - 10, self.textField.frame.size.width, self.textField.frame.size.height);
        
        return NO;
    }
    
    return YES;
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
    _textColorPickerView.frame = CGRectMake(0, keyboardSize.height+80, self.view.frame.size.width, 30);
}
- (void)keyBoardDidHide:(id)sender {
    
    
    [_textColorPickerView removeFromSuperview];
    _textColorPickerView = nil;
    //_textColorPickerView.frame = CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 60);

    //Given size may not account for screen rotation
    //  NSLog(@"keyboard did hide");
    // [self.textLabel removeFromSuperview];
    self.textLabel.text = self.textField.text;
    [self.view bringSubviewToFront:self.textLabel];
    [self viewDidLayoutSubviews];
    self.textLabel.hidden = NO;
    [self.overlayView removeFromSuperview];
    self.textField.hidden = YES;
    
   
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"Syed";
}

#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Text" withString:@""];
    
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

