//
//  SearcherViewController.h
//  CFSlogger
//
//  Created by pac-apps on 3/12/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CFSRecord.h"
#import "DetailsViewController.h"
#import "SaveRecordToServer.h"
#import "CFSCollectionCell.h"
#import "CFSDB.h"

@interface SearcherViewController : UIViewController <UISearchBarDelegate,  UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> //, UITextFieldDelegate>
{
}
//- (IBAction)srchClicked:(id)sender;
//- (void)showConfirmAlert;
@property (nonatomic, strong) CFSRecord * RecorddataCopy;
@property (strong, nonatomic) IBOutlet UISearchBar *SymptomName;

//@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (strong, nonatomic) NSMutableArray *CFSData;
@property (strong, nonatomic) IBOutlet UICollectionView *CFSCollectionView;
@property (strong, nonatomic) IBOutlet UITextField *energyTo;
@property (strong, nonatomic) IBOutlet UITextField *energyFrom;
- (IBAction)Switches:(id)sender;
- (IBAction)switchesSymptoms:(id)sender;
@property (nonatomic, strong) IBOutlet UILabel * ToastLabel;

@property (strong, nonatomic) IBOutlet UISwitch *excerciseSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sleepSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *socialSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *restSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *workSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *playSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *otherSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *moderateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mildSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *severeSwitch;
- (IBAction)checkValues:(id)sender;
-(void)saveEntry;
- (NSString*)GetActivitySwitchValue;
- (NSString*)GetSeveritySwitchValue;
-(NSString *)CurrentDatePretty:(NSString *) prettyDate;
- (void) searchForRecords;
-(IBAction) popButton:(id) sender;
-(void) sendMail;

@end
