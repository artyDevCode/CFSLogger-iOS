//
//  LoginViewController.m
//  MECFSJournal
//
//  Created by Arturo Plottier on 21/04/2014.
//  Copyright (c) 2014 pac-apps. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController
@synthesize txtPassword, txtEmail, activityIndicator, signinButton, forgotpwdButton, registerButton;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
      
    
    txtPassword.text = @"";
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;

  //  [activityIndicator startAnimating];
  //  dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
  //  dispatch_async(downloadQueue, ^{
        // do our long running process here
  //      [NSThread sleepForTimeInterval:10];
        // do any UI stuff on the main UI thread
  //      dispatch_async(dispatch_get_main_queue(), ^{
  //          [activityIndicator stopAnimating];
  //      });
  //  });

    //self.navigationController.navigationBar.topItem.title = @"Log In";
}
-(void) viewWillDisappear:(BOOL)animated
{
    txtEmail.text = @"";
    txtPassword.text = @"";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"au.com.cfs-connection"];
    if (keychain.allItems.count > 0) {
        txtEmail.text = [keychain stringForKey:@"email"];
    }
    else
        txtEmail.text = @"";

    NSUserDefaults *AccessTokenGet = [NSUserDefaults standardUserDefaults];
    NSString *AccessToken = [AccessTokenGet stringForKey:@"access_token"];
    NSUserDefaults *TokenTypeGet = [NSUserDefaults standardUserDefaults];
    NSString *TokenType = [TokenTypeGet stringForKey:@"token_type"];
    if (AccessToken.length > 0)
    {
    
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
  
        //clear defaults in memory
   [AccessTokenGet setObject:@"" forKey:@"access_token"];
  // NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
 
    [postDataTask resume];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startSpinner
{
    [self.view addSubview:activityIndicator];
    self.activityIndicator.hidden = false;
    [activityIndicator startAnimating];
}

-(IBAction)signInClicked:(id)sender
{
  
    //[self performSegueWithIdentifier:@"mainviewSegue" sender:self];

  /*
    NSError *errors;
  
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.120:8080/cfsservice/GetCFSRecord/30-06-2014"];  // GetEmployee/1"]; @"https://cfsonline.azurewebsites.net/ServiceTestDan/Service1.svc/GetData"
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&errors ];
    if (!data)
    {
        NSLog(@"Download Error: %@", errors.localizedDescription);
        
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    NSDictionary *jasonData = [[NSDictionary alloc]init];
    jasonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errors];
    NSLog(@"data received = %@", jasonData);
 //  NSArray *array = [jasonData valueForKey:@"ActivityDesc"];
 //  self.txtUsername.text = array[0];

NSArray *array1 = [jasonData valueForKey:@"DRDateId"];
NSArray *array2 = [jasonData valueForKey:@"RecordedDate"];
NSArray *array3 = [jasonData valueForKey:@"ActId"];
NSArray *array4 = [jasonData valueForKey:@"ADateId"];
NSArray *array5 = [jasonData valueForKey:@"FromTime"];
NSArray *array6 = [jasonData valueForKey:@"ToTime"];
NSArray *array7 = [jasonData valueForKey:@"ActivityType"];
NSArray *array8 = [jasonData valueForKey:@"ActivityTitle"];
NSArray *array9 = [jasonData valueForKey:@"ActivityDesc"];
NSArray *array10 = [jasonData valueForKey:@"EnergyLevel"];
NSArray *array11 = [jasonData valueForKey:@"Field1"];
NSArray *array12 = [jasonData valueForKey:@"SymId"];
NSArray *array13 = [jasonData valueForKey:@"SDateId"];
NSArray *array14 = [jasonData valueForKey:@"SymptomName"];
NSArray *array15 = [jasonData valueForKey:@"Severity"];
NSArray *array16 = [jasonData valueForKey:@"SymptomTitle"];
NSArray *array17 = [jasonData valueForKey:@"SymptomDesc"];
    */
    //[NSThread detachNewThreadSelector:@selector(startSpinner) toTarget:self withObject:nil];

    if(![self validateEmail: txtEmail.text])
    {
        [self alertStatus:@"Enter a valid email address.":@"Email failed":0:txtEmail];
        return;
    }
    [self.view resignFirstResponder];
    
    @try{
        if([[self.txtEmail text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""])
        {
            [self alertStatus:@"Please enter fields":@"Login Failed":0:self.txtPassword];
            [self.activityIndicator stopAnimating];
        }
        else
        {
            [activityIndicator startAnimating];
            
            [self disableButtons];
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{
           
            
            NSString *post = [[NSString alloc]initWithFormat:@"username=%@&password=%@&grant_type=password",[self.txtEmail text], [self.txtPassword text]];
            
            NSLog(@"data: %@",post);
            NSURL *url=[NSURL URLWithString:cfsonline @"/token"];
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding]; // allowLossyConversion:YES];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            
            [request setValue:post forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            
            /*
             NSOperationQueue *queue = [[NSOperationQueue alloc]init];
             [NSURLConnection sendAsynchronousRequest:request
             queue:queue
             completionHandler:^(NSURLResponse *response, NSData *urlData, NSError *error){
             if (!error)
             {
             NSDictionary *jasonData = [[NSDictionary alloc]init];
             NSInteger success = 0;
             */
            
            
            
           
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                    completionHandler:
                                          ^(NSData *urlData, NSURLResponse *response, NSError *error) {
            NSLog(@"response code: %@", [(NSHTTPURLResponse *)response URL]);
            
         // NSError *error1 = [[NSError alloc]init];
         // NSHTTPURLResponse *response = nil;
         //   NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
         //   NSLog(@"response code: %ld", (long)[response statusCode]);
            NSDictionary *jasonData = [[NSDictionary alloc]init];
            NSInteger success = 0;
            NSString * string = [NSString stringWithFormat:@"%@", [(NSHTTPURLResponse *)response URL]];
         //  if ([response statusCode] >= 200 && [response statusCode] <= 300)
            
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"au.com.cfs-connection"];
            NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];

            if ([(NSHTTPURLResponse *)response statusCode] >= 200 && [(NSHTTPURLResponse *)response statusCode] <= 300
                && [string rangeOfString:@"404"].location == NSNotFound)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"response => %@", responseData);
                NSError *error2 = nil;
                jasonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error2];
                success = [jasonData[@"success"] integerValue];
                NSLog(@"success = %ld", (long)success);
                
                if (success == 0)
                {
                    [keychain setString:txtEmail.text forKey:@"email" error:&error];
                    [keychain setString:txtPassword.text forKey:@"password" error:&error];
                    
                    if (error){
                        [self alertStatus:@"Key Chain":@"Error has occurred updating Key Chain":0 :self];
                    }

                    [UserEmail setObject:txtEmail.text forKey:@"UserEmail"];
                    [UserEmail setObject:@"false" forKey:@"Offline"];

                    
                    NSUserDefaults *TokenType = [NSUserDefaults standardUserDefaults];
                    NSString *TokenTypeJson = [jasonData objectForKey:@"token_type"];
                    [TokenType setObject:TokenTypeJson forKey:@"token_type"];
                    
                    NSUserDefaults *AccessToken = [NSUserDefaults standardUserDefaults];
                    NSString *AccessTokenJson = [jasonData objectForKey:@"access_token"];
                    [AccessToken setObject:AccessTokenJson forKey:@"access_token"];
                    
                    NSLog(@"token = %@",  [jasonData objectForKey:@"access_token"]);//this
                    NSLog(@"login success");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [activityIndicator stopAnimating];
                        [self enableButtons];
                        [UserEmail setObject:@"false" forKey:@"Offline"];
                        [self performSegueWithIdentifier:@"mainviewSegue" sender:self];
                    });
                    
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [activityIndicator stopAnimating];
                        NSString *error_msg = (NSString *) jasonData[@"error_message" ];
                        [UserEmail setObject:@"false" forKey:@"Offline"];
                        [self alertStatus:error_msg:@"Login in Failed:" :0:self];
                        [self enableButtons];

                    });

                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    [UserEmail setObject:@"true" forKey:@"Offline"];
                    if ([txtPassword.text isEqualToString: [keychain stringForKey:@"password"]] &&
                          [txtEmail.text isEqualToString: [keychain stringForKey:@"email"]])
                    {
                        [UserEmail setObject:txtEmail.text forKey:@"UserEmail"];
                        [self performSegueWithIdentifier:@"mainviewSegue" sender:self];
                        [self enableButtons];
                    }
                    else{
                        [self alertStatus:@"Login":@"Login in Failed:" :0:self];
                        [self enableButtons];
                    }
                });

            }

            
    
         dispatch_async(dispatch_get_main_queue(), ^{
             [activityIndicator stopAnimating];
             [self enableButtons];

         });
            
                                              
        }];
        
        [task resume];

                                              
                                              
        });
      }

    }
    @catch (NSException * e) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [activityIndicator stopAnimating];
             NSLog(@"Exception: %@", e);
             [self alertStatus:@"Something went wrong, contact info@pac-apps.com" :@"Login Error:" :0:self];
             [self enableButtons];
        });

    }
   
}

- (void)enableButtons{
    signinButton.enabled = YES;
    forgotpwdButton.enabled = YES;
    registerButton.enabled=YES;

}

-(void)disableButtons {
    signinButton.enabled = NO;
    forgotpwdButton.enabled = NO;
    registerButton.enabled=NO;
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"mainviewSegue"])  //CategorySegue
    {
    
    }

}
*/
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
  }


- (IBAction)forgotPassword:(id)sender
{
    @try{
        if([[self.txtEmail text] isEqualToString:@""])
        {
            [self alertStatus:@"Please enter Email Address":@"Forgot Password Failed":0:self];
        }
        else
        {
            
        [self disableButtons];
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:txtEmail.text forKey:@"Email"];
            
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];//[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
            NSURL *url = [NSURL URLWithString:cfsonline @"/forgotpassword"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error]; //for DICTIONARY data
        [request setHTTPBody:postData];
        
            
            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] <= 300)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertStatus:@"An email has been sent to the login email account." :@"Reset Password:" :0:self];
                       [self enableButtons];
                    });

                }
                
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"error = %@", response.description);
                        [self alertStatus:@"Something went wrong, contact info@pac-apps.com" :@"Reset Password Error:" :0:self];
                        [self enableButtons];
                    });
                }
                
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
               [self dismissViewControllerAnimated:YES completion:nil];
               [self.navigationController popToRootViewControllerAnimated:YES];
               [postDataTask resume];
               [activityIndicator stopAnimating];
               [self enableButtons];
            });
         });
            
        }
    }
    @catch (NSException * e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Exception: %@", e);
            [self alertStatus:@"Something went wrong, contact info@pac-apps.com" :@"Reset Password Error:" :0:self];
           [self enableButtons];
        });
    }
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}




- (void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag :(id)sender
{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                        message: msg
                                                                 preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleDefault handler: nil];
    
    [controller addAction: ok];
    
    
    if ([[UIDevice currentDevice].model rangeOfString:@"Pad"].location != NSNotFound) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0); //[sender bounds];
    }
  //  NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
  //  NSString *offline = [UserEmail stringForKey:@"Offline"];
    
   // if ([offline isEqualToString:@"true"])
   // {
        [self presentViewController: controller animated:YES completion:nil];
   // }
    
}

- (IBAction)RegisterClicked:(id)sender {
    SFSafariViewController * svc = [[SFSafariViewController alloc]
                initWithURL:[NSURL URLWithString:cfsonline @"/account/register"] entersReaderIfAvailable:nil];
    svc.delegate = self;
    [self presentViewController:svc animated:NO completion:nil];
   /*
   // [self performSegueWithIdentifier:@"registerviewSegue" sender:self];
    NSURL *url = [NSURL URLWithString:cfsonline];
//    NSURL *url = [NSURL URLWithString:cfsonline @"/account/register"];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cfsonline @"/account/register"]];
*/
}

-(void) safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    
}

@end
