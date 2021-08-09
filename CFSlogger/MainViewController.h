//
//  MainViewController.h
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CFSDB.h"
#import "CFSViewController.h"
#import "VRGCalendarView.h"
#import <MessageUI/MessageUI.h>
#define cfsonline @"https://cfsonline.azurewebsites.net"
#import <SafariServices/SafariServices.h>


@interface MainViewController : UIViewController <SFSafariViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UITableViewDelegate, MFMailComposeViewControllerDelegate, VRGCalendarViewDelegate>
{
    NSString * MyselectedDate;
}
-(IBAction) popButton:(id) sender;
-(NSString *)CurrentDate;
-(void)GetFirstAndLastDate:(NSDate*)sdate;
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id) sender;
@property (strong, nonatomic) IBOutlet UILabel * displayDate;
@property (strong, nonatomic) IBOutlet UIButton * syncButton;
@property (strong, nonatomic) IBOutlet UIButton * chartButton;

@property (strong, nonatomic) IBOutlet UITableView * tableView;
-(void)toast:(id) sender :(NSString*) message;
- (IBAction)Logoff:(id)sender;
@property (nonatomic, strong) IBOutlet UILabel * ToastLabel;

- (IBAction)SyncButton:(id)sender;
@property (nonatomic, strong) NSString *CFStype;
@property (nonatomic, strong) NSMutableArray *Recorddata;
@property (nonatomic, strong) CFSRecord * RecorddataSync;
@property (nonatomic , strong) NSString * CalendarFirstDate;
@property (nonatomic, strong) NSString * CalendarLastDate;
@property (strong, nonatomic) IBOutlet UICollectionView *MainCollectionViewTable;
@property (nonatomic, strong) NSString *MyselectedDate;
//@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) NSMutableArray * ActivityTblarray;
@property (nonatomic, strong) VRGCalendarView *calendar;
-(NSString *)CurrentDatePretty:(NSString *) prettyDate;
@end
