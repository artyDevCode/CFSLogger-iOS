//
//  LoginViewController.h
//  MECFSJournal
//
//  Created by Arturo Plottier on 21/04/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//
#import "UICKeyChainStore.h"
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#define cfsonline @"https://cfsonline.azurewebsites.net"
#import <SafariServices/SafariServices.h>


@interface LoginViewController : UIViewController <SFSafariViewControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate >;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) startSpinner;
- (IBAction)forgotPassword:(id)sender;
-(void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
-(IBAction)signInClicked:(id)sender;
- (IBAction)RegisterClicked:(id)sender;
- (BOOL)validateEmail:(NSString *)emailStr;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotpwdButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
- (void)enableButtons;
-(void)disableButtons;

@end
