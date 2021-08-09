//
//  SearcherViewController.m
//  CFSlogger
//
//  Created by pac-apps on 3/12/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "SearcherViewController.h"

@interface SearcherViewController ()
@property BOOL saveRecord;


@end

@implementation SearcherViewController

@synthesize filteredData, CFSData, ToastLabel, CFSCollectionView ,  energyFrom, energyTo, sleepSwitch, excerciseSwitch, socialSwitch, restSwitch, playSwitch, otherSwitch, workSwitch, mildSwitch, moderateSwitch, severeSwitch, saveRecord, SymptomName, RecorddataCopy; //, favstarImg;
NSInteger RownNumber;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    return self;
}
 
*/


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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self searchForRecords];
}

- (void) searchForRecords
{
    [filteredData removeAllObjects];
    filteredData = [[CFSDB database] searchRecords]; //[CFSData mutableCopy];
    
    NSArray *filteredSplit = [SymptomName.text componentsSeparatedByString:@" "];
    
    for (int i = 0; i <= filteredSplit.count-1; i++)
    {
        NSPredicate *mydata1 = [NSPredicate predicateWithFormat:
                                @"ActivityTitle CONTAINS[c] %@" , [filteredSplit objectAtIndex: i]]; //find out the star value
        
        [filteredData filterUsingPredicate:mydata1];
        NSLog(@"filter = %@", [filteredSplit objectAtIndex:i]);
        // [filteredData containsObject:[filteredSplit objectAtIndex: i]];
    }
    if (filteredData.count < 1)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Search Results"
                                                                            message: @"No records found"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *tryagain = [UIAlertAction actionWithTitle: @"Try again" style: UIAlertActionStyleDefault handler: nil];
        
        [controller addAction: tryagain];
        [self presentViewController: controller animated: YES completion: nil];
        
        
        /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No records found"
         delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
         [alert show];
         */
    }
    [self.CFSCollectionView reloadData];
    [SymptomName resignFirstResponder];

}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [energyTo resignFirstResponder];
    [energyFrom resignFirstResponder];
    [SymptomName resignFirstResponder];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [ToastLabel setHidden:TRUE];
    energyFrom.keyboardType = UIKeyboardTypeNumberPad;
    energyTo.keyboardType = UIKeyboardTypeNumberPad;
    
    
    workSwitch.on = YES;
    restSwitch.on = NO;
    otherSwitch.on = NO;
    playSwitch.on = NO;
    excerciseSwitch.on = NO;
    sleepSwitch.on = NO;
    socialSwitch.on = NO;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];

}

-(void) viewDidAppear:(BOOL)animated
{
       if (saveRecord == true)
    {
        RecorddataCopy = (CFSRecord *)filteredData[RownNumber];
      //  if (RownNumber == 0)
      //  {
      //      [self showConfirmAlert];
      //  }
      //  else
        [self toast: self :@"Record saved"];
        saveRecord = false;
        
    }


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
    location.y = 225;
    [ToastLabel setHidden:FALSE];
    [UIView animateWithDuration:4.0 animations:^{
        ToastLabel.alpha = 0.0;
        ToastLabel.center = location;
    }];
}

-(void)saveEntry
{
    CFSDB *nad = [[CFSDB database]init];
    NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
   
    if (RecorddataCopy.ActId < 1)
    {
        RecorddataCopy.ActId = (NSUInteger)[nad checkExistingRecords:RecorddataCopy.RecordedDate] + 1;
        [nad insertActivity:RecorddataCopy];  //variable result is to test
    }
    else
    {
        [nad updateActivity:RecorddataCopy];
    }
    [self searchForRecords];
    [self.CFSCollectionView reloadData];
    
    NSString *offline = [UserEmail stringForKey:@"Offline"];
    
    //if ([offline isEqualToString:@"false"])
    //{
        SaveRecordToServer * srts = [[SaveRecordToServer alloc]init];
        [srts CopyDataToServer: RecorddataCopy];
    //}

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [filteredData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"searchCell";
    
    CFSRecord *mydata = [filteredData objectAtIndex:indexPath.row];
    
    
    CFSCollectionCell *cell =  (CFSCollectionCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    
    if (mydata.ActId != 0) //if (mydata.ADateId != 0)
    {
        cell.CFSCollTitle.numberOfLines=0;
        cell.CFSCollTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        cell.CFSCollTitle.textColor = [UIColor darkGrayColor];
        cell.CFSCollTitle.text = mydata.ActivityTitle;
        
        cell.CFSCollDate.numberOfLines=0;
        cell.CFSCollDate.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        cell.CFSCollDate.textColor = [UIColor redColor];
        cell.CFSCollDate.text =  [self CurrentDatePretty: mydata.RecordedDate]; //[NSString stringWithFormat:@"Date: %@" , mydata.RecordedDate];
        
        cell.CFSCollFromTime.numberOfLines=0;
        cell.CFSCollFromTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollFromTime.textColor = [UIColor redColor];
        cell.CFSCollFromTime.text = [NSString stringWithFormat:@" %@", mydata.FromTime];
        
        cell.CFSCollToTime.numberOfLines=0;
        cell.CFSCollToTime.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
        cell.CFSCollToTime.textColor = [UIColor redColor];
        cell.CFSCollToTime.text = [NSString stringWithFormat:@" %@",mydata.ToTime];
        
    }
    return cell;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"srchDetailSegue"])
    {
        saveRecord = true;
       DetailsViewController *detailsVC = [segue destinationViewController];
       NSArray *indexPaths = [self.CFSCollectionView indexPathsForSelectedItems];
       NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
       [self.CFSCollectionView deselectItemAtIndexPath:indexPath animated:NO];
       detailsVC.Recorddata = [filteredData objectAtIndex:indexPath.row];
       RownNumber = indexPath.row;
       //detailsVC.Recorddata.ActId = indexPath.row;;


    }
    
}






- (IBAction)switchButton:(id)sender {
    [filteredData removeAllObjects];
    filteredData = [[CFSDB database] searchRecords]; //[CFSData mutableCopy];
    NSString * Activityfilter;
    NSString * Severityfilter;
    
    Severityfilter = [self GetSeveritySwitchValue];
    NSArray *filteredSeveritySplit =   [Severityfilter componentsSeparatedByString:@";"];

   
    Activityfilter = [self GetActivitySwitchValue];
    NSArray *filteredActivitySplit =   [Activityfilter componentsSeparatedByString:@";"];
    NSPredicate *mydata1;
    
       if (Severityfilter.length > 0)
        {
            mydata1 = [NSPredicate predicateWithFormat:
                                @"ActivityType = %@ AND Severity = %@" , filteredActivitySplit[0], filteredSeveritySplit[0]]; //find out the star value
        }
        else
        {
            mydata1 = [NSPredicate predicateWithFormat:
                                    @"ActivityType = %@" , filteredActivitySplit[0]];
        }
        [filteredData filterUsingPredicate:mydata1];
        NSLog(@"filter = %@ severity = %@", filteredActivitySplit[0],filteredSeveritySplit[0]);
    
    if (filteredData.count < 1)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Search Results"
                                                                            message: @"No records found"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *tryagain = [UIAlertAction actionWithTitle: @"Please try again" style: UIAlertActionStyleDefault handler: nil];
        
        [controller addAction: tryagain];
        [self presentViewController: controller animated: YES completion: nil];
        

        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No records found"
                                                       delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
        [alert show];
         */
    }
    [self.CFSCollectionView reloadData];
   // [mysearchBar resignFirstResponder];
    

}


- (IBAction)Switches:(id)sender {
    switch ([sender tag]) {
        case 0:
            NSLog(@"Switch is ON0");
            restSwitch.on = YES;
            otherSwitch.on = NO;
            playSwitch.on = NO;
            excerciseSwitch.on = NO;
            sleepSwitch.on = NO;
            socialSwitch.on = NO;
            workSwitch.on = NO;
             break;
        case 1:
            NSLog(@"Switch is ON1");
            restSwitch.on = NO;
            otherSwitch.on = NO;
            playSwitch.on = NO;
            excerciseSwitch.on = NO;
            sleepSwitch.on = NO;
            socialSwitch.on = NO;
            workSwitch.on = YES;
            break;
        case 2:
            NSLog(@"Switch is ON2");
            restSwitch.on = NO;
            otherSwitch.on = NO;
            playSwitch.on = NO;
            excerciseSwitch.on = YES;
            sleepSwitch.on = NO;
            socialSwitch.on = NO;
            workSwitch.on = NO;
            break;
        case 3:
            NSLog(@"Switch is ON3");
            restSwitch.on = NO;
            otherSwitch.on = NO;
            playSwitch.on = YES;
            excerciseSwitch.on = NO;
            sleepSwitch.on = NO;
            socialSwitch.on = NO;
            workSwitch.on = NO;
            break;
        case 4:
            NSLog(@"Switch is ON4");
            restSwitch.on = NO;
            otherSwitch.on = YES;
            playSwitch.on = NO;
            excerciseSwitch.on = NO;
            sleepSwitch.on = NO;
            socialSwitch.on = NO;
            workSwitch.on = NO;
            break;
        case 5:
            NSLog(@"Switch is ON5");
            restSwitch.on = NO;
            otherSwitch.on = NO;
            playSwitch.on = NO;
            excerciseSwitch.on = NO;
            sleepSwitch.on = YES;
            socialSwitch.on = NO;
            workSwitch.on = NO;
            break;
        case 6:
            NSLog(@"Switch is ON6");
            restSwitch.on = NO;
            otherSwitch.on = NO;
            playSwitch.on = NO;
            excerciseSwitch.on = NO;
            sleepSwitch.on = NO;
            socialSwitch.on = YES;
            workSwitch.on = NO;
            break;
        default:
            break;
            if(restSwitch.on == NO && workSwitch.on == NO && otherSwitch.on == NO && playSwitch.on == NO &&  excerciseSwitch.on == NO && sleepSwitch.on == NO &&  socialSwitch.on == NO)
              workSwitch.on = YES;
    }
}

- (IBAction)switchesSymptoms:(id)sender {
    switch ([sender tag]) {
        case 0:
            NSLog(@"Switch is ON0");
            mildSwitch.on = NO;
            severeSwitch.on = NO;
            break;
        case 1:
            NSLog(@"Switch is ON1");
            moderateSwitch.on = NO;
            severeSwitch.on = NO;
            break;
        case 2:
            NSLog(@"Switch is ON2");
            moderateSwitch.on = NO;
            mildSwitch.on = NO;
            break;
        default:
            break;
    }

}
/*
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ((long)[energyTo text] < 0 || (long)[energyTo text] > 100)
        energyTo.text = 0;
    
    if ((long)[energyFrom text] < 0 || (long)[energyFrom text] > 100)
        energyFrom.text = 0;

}
*/

- (IBAction)checkValues:(id)sender {
    if ([energyTo.text intValue] < 0 || [energyTo.text intValue] > 100)
        energyTo.text = @"0";
    
    if ([energyFrom.text intValue] < 0 || [energyFrom.text intValue] > 100)
        energyFrom.text = @"0";
    if ([energyFrom.text intValue] > [energyTo.text intValue] && energyTo.text.length > 0)
        energyTo.text = energyFrom.text;
}

-(NSString*)GetActivitySwitchValue{
    
    NSString * Activityfilter;
    
   if (workSwitch.on)
      Activityfilter = @"Work";
    
   if (playSwitch.on)
       Activityfilter = [NSString stringWithFormat:@"Play"];
    
   if (restSwitch.on)
      Activityfilter = [NSString stringWithFormat:@"Rest"];
    
   if (sleepSwitch.on)
      Activityfilter = [NSString stringWithFormat:@"Sleep"];
  
    if (socialSwitch.on)
        Activityfilter = [NSString stringWithFormat:@"Social"];

    if (excerciseSwitch.on)
        Activityfilter = [NSString stringWithFormat:@"Excercise"];

    if (otherSwitch.on)
        Activityfilter = [NSString stringWithFormat:@"Other"];

   // NSString * Activityfilter1 = [[NSString alloc]init];
   // Activityfilter1 = [Activityfilter substringToIndex:[Activityfilter length]-1];
    return Activityfilter;

}

-(NSString*)GetSeveritySwitchValue{

    NSString * Severityfilter;
    
    if (mildSwitch.on)
        Severityfilter = [NSString stringWithFormat:@"Mild"];
    
    if (moderateSwitch.on)
        Severityfilter = [NSString stringWithFormat:@"Moderate"];
    
    if (severeSwitch.on)
        Severityfilter = [NSString stringWithFormat:@"Severe"];
    
  //  NSString * Severityfilter1 = [[NSString alloc]init];
  //  Severityfilter1 = [Severityfilter substringToIndex:[Severityfilter length]-1];
    return Severityfilter;
    
}


- (IBAction)energyButton:(id)sender {
    [energyTo resignFirstResponder];
    [energyFrom resignFirstResponder];

    if ([energyFrom.text intValue] >= 0 && [energyTo.text intValue] <= 100)
    {
        [filteredData removeAllObjects];
        filteredData = [[CFSDB database] searchRecords]; //[CFSData mutableCopy];
        
        NSPredicate *mydata1;
        NSLog(@"from = %i to = %i",  [energyFrom.text intValue] , [energyTo.text intValue]);

        mydata1 = [NSPredicate predicateWithFormat:
                   @"(EnergyLevel >= %i) AND (EnergyLevel <= %i)" ,[energyFrom.text intValue] , [energyTo.text intValue]]; //find out the star value
    
       [filteredData filterUsingPredicate:mydata1];
    
        if (filteredData.count < 1)
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Search Results"
                                                                                message: @"No records found"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *tryagain = [UIAlertAction actionWithTitle: @"Please try again" style: UIAlertActionStyleDefault handler: nil];
            
            [controller addAction: tryagain];
            [self presentViewController: controller animated: YES completion: nil];
            

            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No records found"
                                                       delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
            [alert show];
             */
        }
        [self.CFSCollectionView reloadData];
        [SymptomName resignFirstResponder];
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
     UIAlertAction *aboutus = [UIAlertAction actionWithTitle: @"About us"
                                                      style: UIAlertActionStyleDefault
                                                    handler: ^(UIAlertAction *action) {
                                                        [self performSegueWithIdentifier:@"aboutSegue" sender:self];
                                                    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleDefault handler: nil];
    // UIBarButtonItem *button;
    [controller addAction: share];
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


@end
