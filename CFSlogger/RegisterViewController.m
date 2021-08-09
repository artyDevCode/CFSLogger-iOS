//
//  RegisterViewController.m
//  MECFSJournal
//
//  Created by Arturo Plottier on 9/12/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
NSData *receivedData;
}
@end

@implementation RegisterViewController
@synthesize Email, ConfirmPassword, Password, Gender, DateOfBirth, Country, PostCode, activityIndicator, registerButton ;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  //  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  //  if (self) {
        // Custom initialization
  //  }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    Email.keyboardType = UIKeyboardTypeEmailAddress;
    PostCode.keyboardType = UIKeyboardTypeNumberPad;
    Gender.keyboardType = UIKeyboardTypeAlphabet;
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [DateOfBirth setInputView:datePicker];
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)DateOfBirth.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    DateOfBirth.text = [NSString stringWithFormat:@"%@",dateString];
}

- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id)sender
{
   // [registerButton resignFirstResponder];
   
    [[self view] endEditing:TRUE];

    UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                        message: msg
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
    
    [controller addAction: ok];
    
    if ([[UIDevice currentDevice].model rangeOfString:@"Pad"].location != NSNotFound) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0); //[sender bounds];
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


- (IBAction)RegisterClicked:(id)sender {
    if(![self validateEmail: Email.text])
    {
        [self alertStatus:@"Enter a valid email address.":@"Email failed":0 :Email];
        return;
    }

    if ((![ConfirmPassword.text isEqualToString:Password.text] && [ConfirmPassword.text isEqualToString:@""] ) || [Email.text isEqualToString:@""] || [Password.text isEqualToString:@""] || [DateOfBirth.text isEqualToString:@""] || [Gender.text isEqualToString:@""] || [Country.text isEqualToString:@""] ||
        [PostCode.text isEqualToString:@""])
        [self alertStatus:@"Please enter all fields":@"Register Failed":0 :PostCode];
    else
    {
        [activityIndicator startAnimating];
        registerButton.enabled=NO;

        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate  *objDate    = [dateFormatter dateFromString:DateOfBirth.text];
        NSLog(@"birth date = %@", DateOfBirth.text);
        NSString * UnixDate = [NSString stringWithFormat:@"%.0f",[objDate timeIntervalSince1970] * 1000];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:Email.text forKey:@"Email"];
        [dictionary setValue:Password.text forKey:@"Password"];
        [dictionary setValue:ConfirmPassword.text forKey:@"ConfirmPassword"];
        [dictionary setValue:Country.text forKey:@"Country"];
        [dictionary setValue: [[NSString alloc]initWithFormat:@"/Date(%@)/",UnixDate] forKey:@"DateOfBirth"];
     //   [dictionary setValue:DateOfBirth.text forKey:@"DateOfBirth"];
        [dictionary setValue:Gender.text forKey:@"Gender"];
        [dictionary setValue:PostCode.text forKey:@"PostCode"];
        
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:cfsonline @"/Register"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error]; //for DICTIONARY data
        [request setHTTPBody:postData];
         
        NSLog(@"JSON = %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
            
            
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] <= 300)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    registerButton.enabled=YES;
                   // NSLog(@"Response = %@", response.description);
                   // [self alertStatus:response.description :@"Register Account:@" :0];
                    [self alertStatus:@"Check your email to confirm registration" :@"Register Account:" :0 :registerButton];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    registerButton.enabled=YES;
                    NSLog(@"error = %@", response.description);
                    [self alertStatus:@"Something went wrong, contact info@pac-apps.com" :@"Registration Error:" :0 :registerButton];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
               
            }
            
        
        }];
       

       dispatch_async(dispatch_get_main_queue(), ^{
        //   [activityIndicator stopAnimating];
           [postDataTask resume];
           registerButton.enabled=YES;

       });
    });
      

    }


}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [Email resignFirstResponder];
    [Password resignFirstResponder];
    [ConfirmPassword resignFirstResponder];
    [Country resignFirstResponder];
    [PostCode resignFirstResponder];
    [Gender resignFirstResponder];
    [DateOfBirth resignFirstResponder];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
