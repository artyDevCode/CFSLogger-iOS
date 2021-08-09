//
//  RegisterViewController.h
//  MECFSJournal
//
//  Created by Arturo Plottier on 9/12/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONDictionaryExtensions.h"
#define cfsonline @"https://cfsonline.azurewebsites.net"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *Email;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *DateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *Gender;
@property (strong, nonatomic) IBOutlet UITextField *Country;
@property (strong, nonatomic) IBOutlet UITextField *PostCode;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)RegisterClicked:(id)sender;
- (BOOL)validateEmail:(NSString *)emailStr;
-(void) dateTextField:(id)sender;
- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id)sender;
@end
