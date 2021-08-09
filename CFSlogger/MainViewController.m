//
//  MainViewController.m
//  CFSlogger
//
//  Created by pac-apps on 1/12/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "MainViewController.h"
#import "JSONDictionaryExtensions.h"




@implementation MainViewController
NSData *receivedData;

@synthesize CFStype, Recorddata, calendar, ToastLabel, RecorddataSync, displayDate, MainCollectionViewTable, MyselectedDate, ActivityTblarray ,CalendarFirstDate, CalendarLastDate, syncButton ;//filteredlist;

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)months targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    NSLog(@"Month = %@", [calendarView currentMonth]);
    [self GetFirstAndLastDate:[calendarView currentMonth]];
}



-(void)GetFirstAndLastDate:(NSDate *)sdate
{
     NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate: sdate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
     
    [df setDateFormat:@"MM"];
    NSString * myMonthString = [df stringFromDate:sdate];
    
    [df setDateFormat:@"yyyy"];
    NSString * myYearString = [df stringFromDate:sdate];
   
    CalendarFirstDate  =  [[NSString alloc]initWithFormat:@"%@-%@-%@", myYearString, myMonthString,@"01"];
    CalendarLastDate =  [[NSString alloc]initWithFormat: @"%@-%@-%lu", myYearString, myMonthString, (unsigned long)rng.length]; //numberOfDaysInMonth;
 }

-(NSString *)CurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
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

 - (IBAction)SyncButton:(id)sender {
    
   // [activityIndicator startAnimating];
     UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Sync"
                                                                         message:[NSString stringWithFormat:@"Syncronizing the selected month between %@ and %@", CalendarFirstDate, CalendarLastDate ]
                                                                  preferredStyle: UIAlertControllerStyleAlert];
    // UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
     
   //  [controller addAction: ok];
     [self presentViewController: controller animated: YES completion: nil];

/*    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync" message:[NSString stringWithFormat:@"Syncronizing the selected month between %@ and %@", CalendarFirstDate, CalendarLastDate ]
                                                delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
  */
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    [controller.view addSubview: indicator];
    
     syncButton.enabled = NO;
   // [alert setValue:indicator forKey:@"accessoryView"];
   // [alert show];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
   

    NSUserDefaults *AccessTokenGet = [NSUserDefaults standardUserDefaults];
    NSString *AccessToken = [AccessTokenGet stringForKey:@"access_token"];
    NSUserDefaults *TokenTypeGet = [NSUserDefaults standardUserDefaults];
    NSString *TokenType = [TokenTypeGet stringForKey:@"token_type"];
    
    NSMutableDictionary *entry = [[NSMutableDictionary alloc] init];
    NSMutableArray *RecordedData = [[NSMutableArray alloc] init];

    ActivityTblarray = [[CFSDB database] getAllRecordsSync:CalendarFirstDate  claLastDate: CalendarLastDate];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    for (CFSRecord *rec in ActivityTblarray)
    {
        NSDate  *objDate    = [dateFormatter dateFromString:rec.RecordedDate];
        NSString * UnixDate = [NSString stringWithFormat:@"%.0f",[objDate timeIntervalSince1970] * 1000];
        
    [dictionary setValue: [[NSString alloc]initWithFormat:@"/Date(%@)/",UnixDate] forKey:@"RecordedDate"];
    [dictionary setValue:rec.UserName forKey:@"UserName"];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)rec.ActId] forKey:@"ActID"];
    [dictionary setValue:rec.FromTime forKey:@"FromTime"];
    [dictionary setValue:rec.ToTime forKey:@"ToTime"];
    [dictionary setValue:rec.ActivityType forKey:@"ActivityType"];
    [dictionary setValue:rec.ActivityDesc forKey:@"ActivityDesc"];
    [dictionary setValue:rec.ActivityTitle forKey:@"ActivityTitle"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", rec.EnergyLevel] forKey:@"EnergyLevel"];
    [dictionary setValue:rec.Field1 forKey:@"Field1"];
    [dictionary setValue:rec.Field2 forKey:@"Field2"];
    [dictionary setValue:rec.SymptomName forKey:@"SymptomName"];
    [dictionary setValue:rec.Severity forKey:@"Severity"];
    [dictionary setValue:rec.SymptomTitle forKey:@"SymptomTitle"];
    [dictionary setValue:rec.SymptomDesc forKey:@"SymptomDesc"];
    NSDictionary * copiedData = [dictionary mutableCopy];

    [RecordedData addObject:copiedData];
    [dictionary removeAllObjects];
    }
    
    
    NSLog(@"activitytblarray = %@", RecordedData);

    
    NSError *error;
    
    [entry setValue:RecordedData forKey:@"RecordedData"];
    [entry setValue:CalendarFirstDate forKey:@"StartCalendarDate"];
    [entry setValue:CalendarLastDate forKey:@"EndCalendarDate"];
    NSLog(@"entry = %@", entry);
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:cfsonline @"/api/CFSRecordSync"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:entry options:0 error:&error]; //for DICTIONARY data
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:150.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *bearer = [NSString stringWithFormat:@"%@ %@", TokenType, AccessToken];
    [request setValue:bearer forHTTPHeaderField:@"Authorization"];
  
    [request setHTTPBody:postData];
    NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] <= 300)
        {
        [UserEmail setObject:@"false" forKey:@"Offline"];
        NSLog(@"error = %@", response.description);
            NSMutableArray *jsonList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
               NSLog(@"jsonList: %@", jsonList);
        CFSDB *nad = [[CFSDB database]init];

        dispatch_async(dispatch_get_main_queue(), ^{

        for(NSDictionary * array in jsonList)
        {
            CFSRecord *record = [[CFSRecord alloc] init];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
           [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            NSDate * sdate = [formatter dateFromString:[array valueForKey:@"recordedDate"]];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            [df setDateFormat:@"dd"];
            NSString * myDayString = [df stringFromDate:sdate];
            
            [df setDateFormat:@"MM"];
            NSString * myMonthString = [df stringFromDate:sdate];
            
            [df setDateFormat:@"yyyy"];
            NSString * myYearString = [df stringFromDate:sdate];

            record.RecordedDate  =  [[NSString alloc]initWithFormat:@"%@-%@-%@", myYearString, myMonthString,myDayString];
            
            
             record.UserName = [array valueForKey:@"userName"];
             record.ActId = [[array valueForKey:@"actID"] longValue];
            // record.ServerRecordID = [[array valueForKey:@"serverRecordID"] longValue];
             record.FromTime = [array valueForKey:@"fromTime"];
             record.ToTime = [array valueForKey:@"toTime"];
             record.ActivityType = [array valueForKey:@"activityType"];
             record.ActivityDesc = [array valueForKey:@"activityDesc"];
             record.ActivityTitle = [array valueForKey:@"activityTitle"];
             record.EnergyLevel = [[array valueForKey:@"energyLevel"] intValue];
             record.Field1 = [array valueForKey:@"field1"];
             record.Field2 = [array valueForKey:@"field2"];
             record.SymptomName = [array valueForKey:@"symptomName"];
             record.Severity = [array valueForKey:@"severity"];
             record.SymptomTitle = [array valueForKey:@"symptomTitle"];
             record.SymptomDesc = [array valueForKey:@"symptomDesc"];
             [nad insertActivity:record];  //variable result is to test


          }
            syncButton.enabled = YES;
            [controller dismissViewControllerAnimated:YES completion:nil];
            Recorddata = [[CFSDB database] getLatestRecords];
            [self.MainCollectionViewTable reloadData];

         // [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
       // [NSThread detachNewThreadSelector:@selector(stopSpinner) toTarget:self withObject:nil];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UserEmail setObject:@"true" forKey:@"Offline"];
               // [activityIndicator stopAnimating];
                syncButton.enabled = YES;
                [controller dismissViewControllerAnimated:YES completion:nil];
              //  [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self alertStatus:@"Connection Failed":@"Could not Sync at this time":0:syncButton];
            });
  
        }
       }];
  
        dispatch_async(dispatch_get_main_queue(), ^{
           // [activityIndicator stopAnimating];
            [postDataTask resume];
            syncButton.enabled = YES;

        });

    });

}

- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id) sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                        message: msg
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
    
    [controller addAction: ok];
    
    if ([[UIDevice currentDevice].model rangeOfString:@"Pad"].location != NSNotFound) {
        controller.popoverPresentationController.sourceView = sender; //self.view;
        controller.popoverPresentationController.sourceRect = [sender bounds]; //CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    }
    [self presentViewController: controller animated:YES completion:nil];


    /*
    UIAlertView *alert = [[UIAlertView alloc] init];
    
    [alert setTitle:title];
    [alert setMessage:msg];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
    */
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd-MM-yyyy"];
    [formatter setDateFormat:@"yyyy-MM-dd"];

   
    MyselectedDate = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
    [self GetFirstAndLastDate:date];
    NSLog(@"MyselectedDate = %@", MyselectedDate);
   
    Recorddata = [[CFSDB database] getAllRecords:MyselectedDate];
    [self performSegueWithIdentifier:@"listSegue" sender:self];
    
    NSLog(@"Selected my date = %@ the date picked", [formatter stringFromDate: date]);
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
     }
    [self presentViewController: controller animated: YES completion: nil];
    

    /*
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel"  destructiveButtonTitle:nil otherButtonTitles:@"share", @"search",@"about us", nil];
   // [ac setTintColor:[UIColor blackColor]];
    ac.actionSheetStyle = UIBarStyleBlack;
    [ac showInView:self.view];
    */
}

- (IBAction)Logoff:(id)sender
{
   // dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
   // dispatch_async(downloadQueue, ^{
        
    NSUserDefaults *AccessTokenGet = [NSUserDefaults standardUserDefaults];
    NSString *AccessToken = [AccessTokenGet stringForKey:@"access_token"];
    NSUserDefaults *TokenTypeGet = [NSUserDefaults standardUserDefaults];
    NSString *TokenType = [TokenTypeGet stringForKey:@"token_type"];
   
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:cfsonline @"/Logout"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *bearer = [NSString stringWithFormat:@"%@ %@", TokenType, AccessToken];
    [request setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"error = %@", response.description);
                     }];
        [AccessTokenGet setObject:@"" forKey:@"access_token"];
        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        [UserEmail setObject:@"" forKey:@"UserEmail"];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];

        [postDataTask resume];
   // });
                   

}

-(void) sendMail{
    if ([MFMailComposeViewController canSendMail]) {
       MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
       [mailController setMailComposeDelegate:self];
       [mailController setMessageBody:@"Check this app out at " cfsonline isHTML:NO];
       [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Email account"
                                                                            message: @"No email account found"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
        
        [controller addAction: ok];
        [self presentViewController: controller animated: YES completion: nil];

        /*
       // NSLog(@"Unable to send email");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"email account" message:@"No email account found"
                                                       delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
         */
    }
}

 /*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self sendMail];
            break;
        case 1:
            [self performSegueWithIdentifier:@"searchSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
            break;
     //   case 3:
     //       [self performSegueWithIdentifier:@"searchSegue" sender:self];
     //       break;
        default:
            break;
    }
   
}
  */

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) calendarSizeAndLocation {
    
    calendar.frame = CGRectMake(0,0,320,320);
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    calendar.center = CGPointMake(screenSize.width/2 - calendar.frame.size.width/2 + 160, 220);
    NSLog(@"frame = %.20f and %.20f", calendar.frame.size.width/2 , screenSize.width/2 );
    calendar.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:calendar];
    
}
 
- (void)orientationChanged:(NSNotification *)notification {
    // Respond to changes in device orientation
    
    [self calendarSizeAndLocation];
    
}


-(void) viewDidAppear:(BOOL)animated
{
    Recorddata = [[CFSDB database] getLatestRecords];
    [self.MainCollectionViewTable reloadData];
    NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
    NSString *offline = [UserEmail stringForKey:@"Offline"];
    
    if ([offline isEqualToString:@"true"])
    {
        [self.syncButton setEnabled: NO];
        [self toast: self :@"Network connection unavailable"];
    }
    else
    {
        [self.syncButton setEnabled: YES];
    }


}

-(void)toast:(id) sender :(NSString*) message
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image;
        // Request to turn on accelerometer and begin receiving accelerometer events
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    calendar = [[VRGCalendarView alloc] init];
    calendar.delegate = self;
    [ToastLabel setHidden:TRUE];

    
   // self.navigationController.navigationBar.topItem.title = @"Calendar";
   // self.navigationController.navigationBar.backItem.title = @"Log In";

    
   // CFSArray = [[CFSDB database] getAllRecords:mySelectedDate];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        image = [UIImage imageNamed:@"iosiphonehdrbg.png"];
    }
    else
    {
        image = [UIImage imageNamed:@"iosipadhdrbg.png"];
        
    }
    CFStype = [self CurrentDate];
    [self calendarSizeAndLocation];
      // Recorddata = [[CFSDB database] getLatestRecords];
   // [self.MainCollectionViewTable reloadData];
    
    
    
    //displayDate.text = [self CurrentDatePretty: [NSDate].date];
    
    /*  use calendarSizeAndLocation
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate = self;
    
    
    calendar.frame = CGRectMake(0,0,320,320);
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
   
    calendar.center = CGPointMake(screenSize.width/2 - calendar.frame.size.width/2 + 160, 320);
    NSLog(@"frame = %.20f and %.20f", calendar.frame.size.width/2 , screenSize.width/2 );
    [self.view addSubview:calendar];
   */
    
    
    
    /*
    
    
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:calendar
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:MyCalenderView
                                       attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0
                                       constant:0];
    
    [MyCalenderView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:calendar
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:MyCalenderView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    
    [MyCalenderView addConstraint:myConstraint];
*/
    
    
    //Keep to default date for sync
   // MyselectedDate = [self CurrentDate];
   // [self GetFirstAndLastDate: [NSDate date]];
   // Recorddata = [[CFSDB database] getAllRecords:MyselectedDate];
    
    
    //if (Recorddata.count < 2) moreButton.hidden = YES;
    
    // backgroundImageView = [[UIImageView alloc]initWithImage:image];
   // backgroundImageView.image=image;
    
   // [self.view addSubview:backgroundImageView]; //sendSubviewToBack:myview];
   // [self.view sendSubviewToBack:backgroundImageView];
   // backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
  if ([segue.identifier isEqualToString:@"listSegue"])  //CategorySegue
    {
      
        CFSViewController *CFSvc = [segue destinationViewController];
        CFSvc.Recorddata = Recorddata;
        CFSvc.CFStype = MyselectedDate;
      
    }
   /* if ([segue.identifier isEqualToString:@"searchSegue"])  //CategorySegue
    {
        SearcherViewController *searchVC = [segue destinationViewController];
        searchVC.CFSData = Recorddata;
        
    }
    if ([segue.identifier isEqualToString:@"reportSegue"])  //CategorySegue
    {
        ReportViewController *report = [segue destinationViewController];
        report.recordData = Recorddata;
    }
*/
    
   
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [Recorddata count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mainCell";
    
    CFSRecord *mydata = [Recorddata objectAtIndex:indexPath.row];
    
   // mydata.RecordedDate = CFStype;
    CFSCollectionCell *cell =  (CFSCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
   // if (mydata.ActId > 0)
   // {
        cell.CFSCollTitle.numberOfLines=0;
        cell.CFSCollTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        cell.CFSCollTitle.textColor = [UIColor darkGrayColor];
        cell.CFSCollTitle.text = mydata.ActivityTitle;
        
        cell.CFSCollDate.numberOfLines=0;
        cell.CFSCollDate.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollDate.textColor = [UIColor redColor];
        cell.CFSCollDate.text = [self CurrentDatePretty: mydata.RecordedDate];
    
        cell.CFSCollFromTime.numberOfLines=0;
        cell.CFSCollFromTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollFromTime.textColor = [UIColor redColor];
        cell.CFSCollFromTime.text = [NSString stringWithFormat:@" %@", mydata.FromTime];
        
        cell.CFSCollToTime.numberOfLines=0;
        cell.CFSCollToTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollToTime.textColor = [UIColor redColor];
        cell.CFSCollToTime.text = [NSString stringWithFormat:@" %@",mydata.ToTime];
   // }
    
    return cell;
}

- (IBAction)chartButtonClicked:(id)sender {
    SFSafariViewController * svc = [[SFSafariViewController alloc]
                                    initWithURL:[NSURL URLWithString:cfsonline] entersReaderIfAvailable:nil];
    svc.delegate = self;
    [self presentViewController:svc animated:NO completion:nil];

   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cfsonline @""]];
}

    
@end
