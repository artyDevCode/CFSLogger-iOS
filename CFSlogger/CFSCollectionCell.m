//
//  CFSCollectionCell.m
//  CFSlogger
//
//  Created by Carlos Plottier on 18/12/2013.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import "CFSCollectionCell.h"

@implementation CFSCollectionCell
@synthesize CFSCollDate, CFSCollFromTime, CFSCollToTime , divider, CFSCollField1, CFSCollTitle, CFSCollSymptom;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
