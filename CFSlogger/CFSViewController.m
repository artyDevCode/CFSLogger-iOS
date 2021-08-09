//
//  CFSViewController.m
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "CFSViewController.h"

@interface CFSViewController ()
@property BOOL saveRecord;

@end


@implementation CFSViewController
NSData *receivedData;
@synthesize Recorddata, CFStype,  ToastLabel, CFSCollectionViewTable, RecorddataCopy, ActivityTblarray, displayDate, saveRecord; // CFSCollectionViewCell, splitImageView, splitLabel;
NSInteger RownNumber;


/*
 - (id)initWithStyle:(UITableViewStyle)style
 {
 return self;
 }
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ToastLabel setHidden:TRUE];
    
    // NSDate *chosen = [self.startTimePicker date ];
    
    // NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //  [formatter setDateFormat:@"dd-MM-yyyy"];
    //  topBar.text  = (NSString *)[formatter dateFromString:CFStype];
    
    // NSPredicate *mydata1 = [NSPredicate predicateWithFormat:@"d_cat = %@", CFStype]; //CONTAINS[c]
    // dcategory.text = CFStype;
    //   NSMutableArray * filteredlist = [RecorddataCopy mutableCopy];
    // [filteredlist filterUsingPredicate:mydata1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void) viewDidAppear:(BOOL)animated
{
    RecorddataCopy = (CFSRecord *)Recorddata[RownNumber];
    displayDate.text = [self CurrentDatePretty: RecorddataCopy.RecordedDate];
    
    if (saveRecord == true && ![RecorddataCopy.ActivityTitle  isEqual: @""])
        
    {
        
        if (RownNumber == 0)
            
        {
            
            [self showConfirmAlert];
        }
        else
            [self toast: self :@"Record saved"];
        }
        saveRecord = false;
        RownNumber = 0;
}

-(NSString *)CurrentDatePretty:(NSString *) prettyDate {
    // convert to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // ignore +11 and use timezone name instead of seconds from gmt
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    // [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    NSDate *dte = [dateFormat dateFromString:prettyDate];
    NSLog(@"Date: %@", dte);
    
    // back to string
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"EEEE, MMMM dd yyyy"];
    // [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    return [dateFormat2 stringFromDate:dte];
  }


-(void)toast:(id) sender :(NSString*) message
{
    /*
     UIAlertController *toast = [UIAlertController alertControllerWithTitle: nil
     message: message
     preferredStyle: UIAlertControllerStyleAlert];
     
     [self presentViewController: toast animated: YES completion: nil];
     
     int duration = 1; // duration in seconds
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
     [toast dismissViewControllerAnimated:YES completion:nil];
     });
     */
    [self saveEntry];
    ToastLabel.text = message;
    [ToastLabel setHidden:TRUE];
    [ToastLabel setAlpha:1.0];
    CGPoint location;
    location.x = 160;
    location.y = 215;
    ToastLabel.center = location;
    location.x = 160;
    location.y = 225; //320
    [ToastLabel setHidden:FALSE];
    [UIView animateWithDuration:4.0 animations:^{
        ToastLabel.alpha = 0.0;
        ToastLabel.center = location;
    }];
}


-(void)saveEntry
{
    CFSDB *nad = [[CFSDB database]init];
    //NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
    //NSString *offline = [UserEmail stringForKey:@"Offline"];
    if (RecorddataCopy.ActId < 1)
    {
        RecorddataCopy.ActId = (NSUInteger)[nad checkExistingRecords:RecorddataCopy.RecordedDate] + 1;
        [nad insertActivity:RecorddataCopy];  //variable result is to test
    }
    else
    {
        [nad updateActivity:RecorddataCopy];
    }
  
    Recorddata = [[CFSDB database] getAllRecords:CFStype];
    [self.CFSCollectionViewTable reloadData];
    //if ([offline isEqualToString:@"false"])
    //{
        SaveRecordToServer * srts = [[SaveRecordToServer alloc]init];
        [srts CopyDataToServer: RecorddataCopy];
    //}
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



- (void)showConfirmAlert
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Confirm!"
                                                                        message: @"Save record"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle: @"Yes"
                                                  style: UIAlertActionStyleDefault
                          
                                                handler: ^(UIAlertAction *action) {
                                                    [self saveEntry];
                                                    
                                                }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle: @"No" style: UIAlertActionStyleDefault handler: nil];
    
    [controller addAction: yes];
    [controller addAction: no];
    
    [self presentViewController: controller animated: YES completion: nil];
    
    //  UIAlertController *alert = [[UIAlertController alloc] init];
    
    //  [alert setTitle:@"Confirm"];
    //  [alert setMessage:@"Save Record?"];
    //  [alert setDelegate:self];
    //  [alert addButtonWithTitle:@"Yes"];
    //  [alert addButtonWithTitle:@"No"];
    //  [alert show];
    
}
/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 CFSDB *nad = [[CFSDB database]init];
 SaveRecordToServer * srts = [[SaveRecordToServer alloc]init];
 
 switch (buttonIndex)
 {
 case 0:
 if (RecorddataCopy.ActId < 1)
 {
 RecorddataCopy.ActId = (NSUInteger)[nad checkExistingRecords:RecorddataCopy.RecordedDate] + 1;
 [nad insertActivity:RecorddataCopy];  //variable result is to test
 }
 else
 {
 [nad updateActivity:RecorddataCopy];
 }
 
 // [self CopyDataToServer: RecorddataCopy];
 [srts CopyDataToServer: RecorddataCopy];
 
 break;
 case 1:
 break;
 
 }
 Recorddata = [[CFSDB database] getAllRecords:CFStype];
 // NSLog(@"records = %lul",(unsigned long)Recorddata.count);
 [self.CFSCollectionViewTable reloadData];
 
 }
 */

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [Recorddata count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"splitCell";
    
    CFSRecord *mydata = [Recorddata objectAtIndex:indexPath.row];
    
    mydata.RecordedDate = CFStype;
    CFSCollectionCell *cell =  (CFSCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (mydata.ActId > 0)
    {
        cell.divider.backgroundColor = [UIColor redColor];
        cell.CFSCollTitle.numberOfLines=0;
        cell.CFSCollTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        cell.CFSCollTitle.textColor = [UIColor darkGrayColor];
        cell.CFSCollTitle.text = mydata.ActivityTitle;
        
        cell.CFSCollDate.numberOfLines=0;
        cell.CFSCollDate.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        cell.CFSCollDate.textColor = [UIColor redColor];
        cell.CFSCollDate.text = [NSString stringWithFormat:@"Date: %@" , mydata.RecordedDate];
        
        cell.CFSCollFromTime.numberOfLines=0;
        cell.CFSCollFromTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollFromTime.textColor = [UIColor redColor];
        cell.CFSCollFromTime.text = [NSString stringWithFormat:@" %@", mydata.FromTime];
        
        cell.CFSCollToTime.numberOfLines=0;
        cell.CFSCollToTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollToTime.textColor = [UIColor redColor];
        cell.CFSCollToTime.text = [NSString stringWithFormat:@" %@",mydata.ToTime];
    }
    else
    {
        cell.divider.backgroundColor = [UIColor clearColor];
        cell.CFSCollTitle.numberOfLines=0;
        cell.CFSCollTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
        cell.CFSCollTitle.textColor = [UIColor redColor];
        cell.CFSCollTitle.text = cellTitle; //@"Enter New Record";
        
        cell.CFSCollFromTime.text = @"";
        cell.CFSCollToTime.text = @"";
        
        
        //cell.CFSCollDate.numberOfLines=0;
        //cell.CFSCollDate.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        //cell.CFSCollDate.textColor = [UIColor redColor];
        //cell.CFSCollDate.text =  [NSString stringWithFormat:@"Date: %@" ,CFStype];
        
        // cell.CFSCollFromTime.numberOfLines=0;
        // cell.CFSCollFromTime.font = [UIFont fontWithName:@"Helvetica Neue" size:20.0];
        // cell.CFSCollFromTime.textColor = [UIColor redColor];
        // cell.CFSCollFromTime.text = @"Day";
        
    }
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        
        DetailsViewController *CFSVC = [segue destinationViewController];
        saveRecord = true;
        
        NSArray *indexPaths = [self.CFSCollectionViewTable indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        [self.CFSCollectionViewTable deselectItemAtIndexPath:indexPath animated:NO];
        CFSVC.Recorddata = [Recorddata objectAtIndex:indexPath.row];
        CFSVC.Recorddata.ActId = indexPath.row;
        RownNumber = indexPath.row;
    }
    
}

-(IBAction) popButton:(id) sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: nil
                                                                        message: nil
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *share = [UIAlertAction actionWithTitle: @"Share"
                                                    style: UIAlertActionStyleDefault
                                                  handler: ^(UIAlertAction *action) {
                                                      [self sendMail];
                                                  }];
    UIAlertAction *search = [UIAlertAction actionWithTitle: @"Search"
                                                     style: UIAlertActionStyleDefault
                                                   handler: ^(UIAlertAction *action) {
                                                       [self performSegueWithIdentifier:@"searchSegue" sender:self];
                                                   }];
    
    UIAlertAction *aboutus = [UIAlertAction actionWithTitle: @"About us"
                                                      style: UIAlertActionStyleDefault
                                                    handler: ^(UIAlertAction *action) {
                                                        [self performSegueWithIdentifier:@"aboutSegue" sender:self];
                                                    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleDefault handler: nil];
    // UIBarButtonItem *button;
    [controller addAction: share];
    [controller addAction: search];
    [controller addAction: aboutus];
    [controller addAction: cancel];
    if ([[UIDevice currentDevice].model rangeOfString:@"Pad"].location != NSNotFound) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0); //[sender bounds];
    }    [self presentViewController: controller animated: YES completion: nil];
    
    /*
     UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel"  destructiveButtonTitle:nil otherButtonTitles:@"share", @"search",@"about us", nil];
     // [ac setTintColor:[UIColor blackColor]];
     ac.actionSheetStyle = UIBarStyleBlack;
     [ac showInView:self.view];
     */
}
-(void) sendMail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setMessageBody:@"Check this app out at https://cfsonline.azurewebsites.net" isHTML:NO];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"email account" message:@"No email account found"
        //                                                delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Email account"
                                                                            message: @"No email account found"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
        
        [controller addAction: ok];
        [self presentViewController: controller animated: YES completion: nil];
        
        
        //[alert show];
    }
}

/*
 -(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 switch (buttonIndex) {
 // case 0:
 //     [self performSegueWithIdentifier:@"mapSegue" sender:self];
 //     break;
 case 0:
 [self sendMail];
 break;
 case 1:
 [self performSegueWithIdentifier:@"searchSegue" sender:self];
 break;
 case 2:
 [self performSegueWithIdentifier:@"aboutSegue" sender:self];
 break;
 //  case 3:
 //      [self performSegueWithIdentifier:@"shareSegue" sender:self];
 //      break;
 default:
 break;
 }
 
 }
 */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
