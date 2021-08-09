//
//  CFSViewController.h
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFSDB.h"
#import "DetailsViewController.h"
#import "SaveRecordToServer.h"
#import "CFSCollectionCell.h"
#import <MessageUI/MessageUI.h>
#define cfsonline @"https://cfsonline.azurewebsites.net"
#define cellTitle @"Enter New Record"
@interface CFSViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
//, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
}
//@property (strong, nonatomic) IBOutlet UICollectionViewCell *CFSCollectionViewCell;
//@property (strong, nonatomic) IBOutlet UIImageView *splitImageView;
//@property (strong, nonatomic) IBOutlet UILabel *splitLabel;
//- (void)showConfirmAlert;
//- (void)CopyDataToServer:(CFSRecord *) record;
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@property (nonatomic, strong) CFSRecord * RecorddataCopy;
@property (nonatomic, strong) CFSRecord * ActivityTblarray;
-(void)saveEntry;
@property (nonatomic, strong) IBOutlet UILabel * ToastLabel;
@property (nonatomic, strong) IBOutlet UILabel * displayDate;
@property (nonatomic, strong) NSString * CFStype;
@property (nonatomic, strong) NSMutableArray * Recorddata;
@property (strong, nonatomic) IBOutlet UICollectionView *CFSCollectionViewTable;
-(IBAction) popButton:(id) sender;
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data; // executed when the connection receives data
//- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag;

-(NSString *)CurrentDatePretty:(NSString *) prettyDate;

@end
