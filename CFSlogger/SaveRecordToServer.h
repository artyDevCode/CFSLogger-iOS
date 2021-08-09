//
//  SaveRecordToServer.h
//  MECFSJournal
//
//  Created by Arturo Plottier on 19/05/2015.
//  Copyright (c) 2015 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFSDB.h"
#define cfsonline @"https://cfsonline.azurewebsites.net"

@interface SaveRecordToServer : NSObject
-(void)CopyDataToServer:(CFSRecord *)record;


@end
