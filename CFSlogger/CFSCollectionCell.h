//
//  CFSCollectionCell.h
//  CFSlogger
//
//  Created by Carlos Plottier on 18/12/2013.
//  Copyright (c) 2013 pac-apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFSCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *CFSCollTitle;
@property (strong, nonatomic) IBOutlet UILabel *CFSCollDate;
@property (strong, nonatomic) IBOutlet UILabel *CFSCollFromTime;
@property (strong, nonatomic) IBOutlet UILabel *CFSCollToTime;
@property (strong, nonatomic) IBOutlet UILabel *divider;

@property (strong, nonatomic) IBOutlet UIImageView *CFSCollField1;
@property (strong, nonatomic) IBOutlet UIImageView *CFSCollSymptom;
//severity_image_red.png
@end
