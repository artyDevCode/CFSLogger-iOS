//
//  DetailsViewController.h
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SymptomViewController.h"
//#import "MainViewController.h"
//#import "CFSViewController.h" //added to access the recorddatacopy
#import "CFSDB.h"
#import <MessageUI/MessageUI.h>
#define cfsonline @"https://cfsonline.azurewebsites.net"


@interface DetailsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate , UIPickerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    UIImageView *backgroundImageView;
    float keyboardheight;
    NSArray *activityTypes;
    NSDateFormatter *formatter;
   // UIAlertView *alert;
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up;

-(IBAction) popButton:(id) sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)displayStartTime:(id)sender;
-(void) checkDateFormat;
@property (strong, nonatomic) NSDateFormatter* df;
@property (strong, nonatomic) NSString * fromTime;
@property (strong, nonatomic) NSString * toTime;

@property (strong, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (strong, nonatomic) IBOutlet UILabel *PercentageLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIButton *SelectSymtoms;



@property (nonatomic, strong) CFSRecord *Recorddata;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSString *actType;
@property (strong, nonatomic) IBOutlet UITextView *activityDesc;
@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
//@property (strong, nonatomic) IBOutlet UIDatePicker *startTime;
//@property (strong, nonatomic) IBOutlet UIDatePicker *endTime;
//@property (strong, nonatomic) IBOutlet UISlider *energy;

@end
