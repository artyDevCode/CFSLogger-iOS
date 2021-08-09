#import "CPTLayer.h"

@class CPTAxis;

@interface CPTGridLines : CPTLayer {
    @private
    __cpt_weak CPTAxis *axis;
    NSString major;
}

@property (nonatomic, readwrite, cpt_weak_property) __cpt_weak CPTAxis *axis;
@property (nonatomic, readwrite) NSString major;

@end
