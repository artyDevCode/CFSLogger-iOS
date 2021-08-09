//
//  DetailsViewController.m
//  CFSlogger
//
//  Created by pac-apps on 30/11/13.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

    
@synthesize formatter, activityDesc, Recorddata, fromTime, df, toTime, actType, slider, PercentageLabel, startTimePicker, endTimePicker, activityPicker, activityTitle; //, backgroundImageView;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"Segue = %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"symptomSegue"]) // && Recorddata.ADateId > 0) //check to see if they filled in the activity page
    {
         SymptomViewController *symptomRec = [segue destinationViewController];
         symptomRec.Recorddata = self.Recorddata;
        
    }
}


- (IBAction)displayStartTime:(id)sender
{
    NSDate *chosen = [self.startTimePicker date ];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    Recorddata.FromTime = [formatter stringFromDate:chosen];
  
}

- (IBAction)displayEndTime:(id)sender
{
    
    NSDate *chosen = [self.endTimePicker date ];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    Recorddata.ToTime = [formatter stringFromDate:chosen];
   
    NSLog(@"End time = %@", [formatter stringFromDate:chosen]);
}


- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // actType = activityTypes[row];
    Recorddata.ActivityType = activityTypes[row];
    NSLog(@"activity drum: %@", actType);
    
}

- (IBAction)displaySliderValue:(id)sender {
    
    //slider = (UISlider *)sender;
    
    PercentageLabel.text = [NSString stringWithFormat:@"%2ld", lroundf(slider.value)];
    Recorddata.EnergyLevel = (int)lroundf(slider.value);
    NSLog(@"Slider value = %2f ", slider.value);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [activityTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return activityTypes[row];
}




-(void)viewWillDisappear:(BOOL)animated
{
    Recorddata.ActivityTitle = activityTitle.text;
    Recorddata.ActivityDesc = activityDesc.text;
    if ([Recorddata.Severity isEqualToString: @""])
        Recorddata.Severity = @"Unselected";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (df == nil) {
        df = [[NSDateFormatter alloc] init];
    }
    self.navigationController.navigationBar.backItem.title = @"Details";
    activityTypes = @[@"Work", @"Rest", @"Play", @"Social", @"Sleep", @"Excercise", @"Other"];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
   // Recorddata.SDateId = Recorddata.ADateId;

    if (Recorddata.ActId > 0)
    {
        activityTitle.text = Recorddata.ActivityTitle;
        activityDesc.text = Recorddata.ActivityDesc;
        slider.value = Recorddata.EnergyLevel;
        PercentageLabel.text =  [NSString stringWithFormat:@"%d", Recorddata.EnergyLevel];
        
       
        if(self.startTimePicker == nil)
            self.startTimePicker = [[UIDatePicker alloc] init];
        if(self.endTimePicker == nil)
            self.endTimePicker = [[UIDatePicker alloc] init];
        [self checkDateFormat];

        //self.startTimePicker.date = [formatter dateFromString:fromTime];
        //self.endTimePicker.date = [formatter dateFromString:toTime];
        [startTimePicker setDate:[df dateFromString:fromTime]];
        [endTimePicker setDate: [df dateFromString:toTime]];
        Recorddata.FromTime = fromTime;
        Recorddata.ToTime = toTime;
        
        int b = 0;
        for(id a in activityTypes)
        {
            
            if ([a isEqualToString:Recorddata.ActivityType])
            {
                [activityPicker selectRow:b inComponent:0 animated:YES];
            }
            b = b + 1;
        }
    }
    else
    {
    // set defaults if not selected

        [self displayStartTime:startTimePicker];
        [self displayEndTime:endTimePicker];

         //set the default energy level
        slider.value = 50;
        PercentageLabel.text = [NSString stringWithFormat:@"%2ld" ,lroundf(slider.value)];
        Recorddata.EnergyLevel = 50;
    
    //set the default for the activity
        Recorddata.ActivityType = activityTypes[3];
    }
    
   
	UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
}

-(void) checkDateFormat
{
   
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en" ]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
  
    NSString *format = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    BOOL is24Hour = ([format rangeOfString:@"a"].location == NSNotFound);
    if (is24Hour) {
        [df setDateFormat:@"h:mm a"];
        NSRange amRange = [Recorddata.FromTime rangeOfString:[df AMSymbol]];
        NSRange pmRange = [Recorddata.FromTime rangeOfString:[df PMSymbol]];
        BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
        
        if (!is24h){
            [df setDateFormat:@"h:mm a"];
            NSDate* fTime = [df dateFromString:Recorddata.FromTime];
            NSDate* tTime = [df dateFromString:Recorddata.ToTime];
            fromTime = [df stringFromDate:fTime];
            toTime = [df stringFromDate:tTime];
            
            [df setDateFormat:@"HH:mm"];
            fromTime = [df stringFromDate:fTime];
            toTime = [df stringFromDate:tTime];
        }
        else
        {
            [df setDateFormat:@"HH:mm"];  //set the date format for datepicker below
            fromTime = Recorddata.FromTime;
            toTime = Recorddata.ToTime;
        }
    }
    else
    {
        [df setDateFormat:@"hh:mm a"];
        NSRange amRange = [Recorddata.FromTime rangeOfString:[df AMSymbol]];
        NSRange pmRange = [Recorddata.FromTime rangeOfString:[df PMSymbol]];
        BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
        
        if (is24h){
            [df setDateFormat:@"HH:mm"];
            NSDate* fTime = [df dateFromString:Recorddata.FromTime];
            NSDate* tTime = [df dateFromString:Recorddata.ToTime];
            fromTime = [df stringFromDate:fTime];
            toTime = [df stringFromDate:tTime];
            
            [df setDateFormat:@"h:mm a"];
            fromTime = [df stringFromDate:fTime];
            toTime = [df stringFromDate:tTime];
        }
        else
        {
            [df setDateFormat:@"h:mm a"];  //set the date format for datepicker below
            fromTime = Recorddata.FromTime;
            toTime = Recorddata.ToTime;
            
        }
        // [df setDateFormat:@"hh:mm a"];  //set the date format for datepicker below
        // fromTime = Recorddata.FromTime;
        // toTime = Recorddata.ToTime;
    }
 
}

- (IBAction)dismissKeyboard:(id)sender {
    [activityDesc resignFirstResponder];
    [activityTitle resignFirstResponder];
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [activityDesc resignFirstResponder];
    [activityTitle resignFirstResponder];
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
        

        // NSLog(@"Unable to send email");
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"email account" message:@"No email account found"
                                                       delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
         */
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textViewDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
    
}


@end








