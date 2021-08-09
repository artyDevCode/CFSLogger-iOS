//
//  AboutUsViewController.m
//  CFSlogger
//
//  Created by Carlos Plottier on 15/12/2013.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "AboutUsViewController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize aboutUsTextView;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [aboutUsTextView setDataDetectorTypes :UIDataDetectorTypeLink];
    [aboutUsTextView setEditable: NO];
    //[aboutUsTextView setSelectable: YES];
    [aboutUsTextView setFont: [UIFont fontWithName:@"Helvetica Neue" size:16.0]];
    [aboutUsTextView setTextColor:[UIColor whiteColor]];
  
    //[aboutUsTextView setBackgroundColor:[UIColor blackColor]];

    [aboutUsTextView setText: [NSString localizedStringWithFormat:
    @"About us \r"
    cfsonline @" \r\r"
    @"Pac-Apps was created by two brothers with the aim of developing feature rich and visually stunning applications.  With the combination of skills already acquired throughout their careers, the idea to start developing apps came about through conversation,  the possibilities in making use of these skills for app development.  Skills include graphic design, application design, coding in iOS and .Net, to name a few. \r\r"
    @"So with determination and perseverance, the brothers set off to developed their first apps (see www.pac-apps.com).  These apps turned the dream into reality, and it was exciting times to see these apps being used! \r\r"
    @"Attention to detail, focusing on user enjoyment is what drives the brothers to think innovation and quality in design. \r\r"
    @"If you have any questions about CFS Online, please email info@pac-apps.com"]];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
