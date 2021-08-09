//
//  SaveRecordToServer.m
//  MECFSJournal
//
//  Created by Arturo Plottier on 19/05/2015.
//  Copyright (c) 2015 pac-apps. All rights reserved.
//

#import "SaveRecordToServer.h"

@implementation SaveRecordToServer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)CopyDataToServer:(CFSRecord *)record
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{

        NSUserDefaults *UserEmail = [NSUserDefaults standardUserDefaults];
        NSString *userEmail = [UserEmail stringForKey:@"UserEmail"];
        
        
        NSDate  *objDate    = [dateFormatter dateFromString:record.RecordedDate];
        NSString * UnixDate = [NSString stringWithFormat:@"%.0f",[objDate timeIntervalSince1970] * 1000];
        
        NSUserDefaults *AccessTokenGet = [NSUserDefaults standardUserDefaults];
        NSString *AccessToken = [AccessTokenGet stringForKey:@"access_token"];
        
        NSUserDefaults *TokenTypeGet = [NSUserDefaults standardUserDefaults];
        NSString *TokenType = [TokenTypeGet stringForKey:@"token_type"];
        
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue: [[NSString alloc]initWithFormat:@"/Date(%@)/",UnixDate] forKey:@"RecordedDate"];
        [dictionary setValue:userEmail forKey:@"UserName"];
        [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)record.ActId] forKey:@"ActID"];
        [dictionary setValue:record.FromTime forKey:@"FromTime"];
        [dictionary setValue:record.ToTime forKey:@"ToTime"];
        [dictionary setValue:record.ActivityType forKey:@"ActivityType"];
        [dictionary setValue:record.ActivityDesc forKey:@"ActivityDesc"];
        [dictionary setValue:record.ActivityTitle forKey:@"ActivityTitle"];
        [dictionary setValue:[NSString stringWithFormat:@"%d", record.EnergyLevel] forKey:@"EnergyLevel"];
        [dictionary setValue:[NSString stringWithFormat:@"%@", (NSString *)record.Field1] forKey:@"Field1"];
        [dictionary setValue:[NSString stringWithFormat:@"%@", (NSString *)record.Field2] forKey:@"Field2"];
        [dictionary setValue:record.SymptomName forKey:@"SymptomName"];
        [dictionary setValue:record.Severity forKey:@"Severity"];
        [dictionary setValue:record.SymptomTitle forKey:@"SymptomTitle"];
        [dictionary setValue:record.SymptomDesc forKey:@"SymptomDesc"];
        
        NSError *error;
        
     //   NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
       // NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURL *url = [NSURL URLWithString:cfsonline @"/api/CFSRecord"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error]; //for DICTIONARY data
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSString *bearer = [NSString stringWithFormat:@"%@ %@", TokenType, AccessToken];
        [request setValue:bearer forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];

        //////
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] >= 200 && [httpResponse statusCode] <= 300)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UserEmail setObject:@"false" forKey:@"Offline"];
                     NSLog(@"Save record to server Response = %@", response.description);
                    // [self alertStatus:response.description :@"Register Account:@" :0];
                });
            }
            
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UserEmail setObject:@"true" forKey:@"Offline"];
                    NSLog(@"error = %@", response.description);
                 
                });
                
            }
            
            
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //   [activityIndicator stopAnimating];
            [postDataTask resume];
            
        });
    });
        //////
        /* the original
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
              NSLog(@"Return ID from server = %@", response);
        }];
        
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [postDataTask resume];
        });
         */
}


@end
