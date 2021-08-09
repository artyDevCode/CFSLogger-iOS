//
//  SymptomViewController.h
//  MECFSJournal
//
//  Created by Arturo Plottier on 15/02/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFSDB.h"

#import <MessageUI/MessageUI.h>
#define cfsonline @"https://cfsonline.azurewebsites.net"


@interface SymptomViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray *symptomTypes;
}
@property (nonatomic, strong) CFSRecord *Recorddata;
-(IBAction) popButton:(id) sender;
//-(void)animateTextField:(UITextView*)textField up:(BOOL)up;
-(void)animateTextField:(UITextField*)textField up:(BOOL)up;


//-(void)actionSheet:(UIAlertController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)dismissKeyboard:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *symptomPicker;
@property (strong, nonatomic) IBOutlet NSString *symType;

@property (strong, nonatomic) IBOutlet UISwitch *URF;
@property (strong, nonatomic) IBOutlet UISwitch *MJP;
@property (strong, nonatomic) IBOutlet UISwitch *LMS;
@property (strong, nonatomic) IBOutlet UISwitch *HA;
@property (strong, nonatomic) IBOutlet UISwitch *ST;
@property (strong, nonatomic) IBOutlet UISwitch *SF;

@property (strong, nonatomic) IBOutlet UISwitch *CC;
@property (strong, nonatomic) IBOutlet UISwitch *CNS;
@property (strong, nonatomic) IBOutlet UISwitch *LGF;
@property (strong, nonatomic) IBOutlet UISwitch *NS;
@property (strong, nonatomic) IBOutlet UISwitch *RS;
@property (strong, nonatomic) IBOutlet UISwitch *RIF;
@property (strong, nonatomic) IBOutlet UISwitch *TSLN;

@property (strong, nonatomic) IBOutlet UISwitch *BV;
@property (strong, nonatomic) IBOutlet UISwitch *SL;
@property (strong, nonatomic) IBOutlet UISwitch *EPS;
@property (strong, nonatomic) IBOutlet UISwitch *RIE;
@property (strong, nonatomic) IBOutlet UISwitch *DME;
@property (strong, nonatomic) IBOutlet UISwitch *NTS;
@property (strong, nonatomic) IBOutlet UISwitch *STN;

@property (strong, nonatomic) IBOutlet UISwitch *RD;
@property (strong, nonatomic) IBOutlet UISwitch *HWD;
@property (strong, nonatomic) IBOutlet UISwitch *DWN;
@property (strong, nonatomic) IBOutlet UISwitch *IS;
@property (strong, nonatomic) IBOutlet UISwitch *MLBF;
@property (strong, nonatomic) IBOutlet UISwitch *PJ;
@property (strong, nonatomic) IBOutlet UISwitch *SS;
@property (strong, nonatomic) IBOutlet UISwitch *DMD;

@property (strong, nonatomic) IBOutlet UISwitch *IB;
@property (strong, nonatomic) IBOutlet UISwitch *AP;
@property (strong, nonatomic) IBOutlet UISwitch *FD;
@property (strong, nonatomic) IBOutlet UISwitch *FB;
@property (strong, nonatomic) IBOutlet UISwitch *FC;
@property (strong, nonatomic) IBOutlet UISwitch *RF;
@property (strong, nonatomic) IBOutlet UISwitch *VOM;
@property (strong, nonatomic) IBOutlet UISwitch *FCA;
@property (strong, nonatomic) IBOutlet UISwitch *AC;

@property (strong, nonatomic) IBOutlet UISwitch *LH;
@property (strong, nonatomic) IBOutlet UISwitch *DV;
@property (strong, nonatomic) IBOutlet UISwitch *FA;
@property (strong, nonatomic) IBOutlet UISwitch *SB;
@property (strong, nonatomic) IBOutlet UISwitch *CP;
@property (strong, nonatomic) IBOutlet UISwitch *IH;
@property (strong, nonatomic) IBOutlet UISwitch *SIZ;
//44
@property (strong, nonatomic) IBOutlet UITextView *DATXT;
@property (strong, nonatomic) IBOutlet UITextField *SymptomTitleTXT;

@end
