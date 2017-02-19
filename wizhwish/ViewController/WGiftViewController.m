//
//  WGiftViewController.m
//  wizhwish
//
//  Created by Syed Abdul Basit on 2017-02-19.
//  Copyright © 2017 Syed Abdul Basit. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 150.0


#import "WGiftViewController.h"

@interface WGiftViewController ()

@end

@implementation WGiftViewController


- (void)keyboardWillShow {
    // Animate the current view out of the way
  //  if (self.view.frame.origin.y >= 0)
    
        [self setViewMovedUp:YES];
   // }
    
}

-(void)keyboardWillHide {
   
        [self setViewMovedUp:NO];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
           // [self setViewMovedUp:YES];
        }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self setViewMovedUp:NO];
    [textField resignFirstResponder];
    
    return YES;
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGPoint rect = self.view.center;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.y -= kOFFSET_FOR_KEYBOARD;
       // rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.center = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.iconAlign = JKSearchBarIconAlignCenter;
    _searchBar.placeholder = @"Search";
    _searchBar.placeholderColor = [UIColor darkGrayColor];
    _searchBar.layer.cornerRadius = _searchBar.frame.size.height/2;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar._textField.borderStyle = UITextBorderStyleNone;
    _searchBar._textField.delegate = self;
    _searchBar.delegate = self;
    _searchBar._textField.backgroundColor = [UIColor whiteColor];
    
    [self didTappedView:self.view];

    
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = [UIColor getLightGrayColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)giftPressed:(id)sender {
    
    [self.privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.giftButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    
    self.imageBg.image = [UIImage imageNamed:@"Image_Gift_Bg"];
    
    self.firstLabel.hidden = NO;
    self.secondLabel.text = @"Who bought you this gift";
}

- (IBAction)privatePressed:(id)sender {
    
    [self.giftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.privateButton setTitleColor:[UIColor navigationBarColor] forState:UIControlStateNormal];
    
    self.firstLabel.hidden = YES;
    
    self.secondLabel.text = @"Select who can see the post?";
    self.imageBg.image = [UIImage imageNamed:@"Image_Private_Bg"];
}

#pragma mark CollectionView Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_PEOPLE_COLLECTION_CELL forIndexPath:indexPath];
    [cell.buttonPeople setRoundCornersAsCircle];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(collectionView.frame.size.width/4-4 , collectionView.frame.size.height);
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


#pragma mark - JKSearchBar Delegate Methods
- (void)searchBar:(JKSearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarSearchButtonClicked:(JKSearchBar *)searchBar {
    
    [self setViewMovedUp:NO];

    
}

- (void)searchBarCancelButtonClicked:(JKSearchBar *)searchBar {
    
    [self setViewMovedUp:NO];
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
