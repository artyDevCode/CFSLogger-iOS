#import "CPTLayer.h"

@class CPTPlotArea;

@interface CPTGridLineGroup : CPTLayer {
    @private
    __cpt_weak CPTPlotArea *plotArea;
    NSString major;
}

@property (nonatomic, readwrite, cpt_weak_property) __cpt_weak CPTPlotArea *plotArea;
@property (nonatomic, readwrite) NSString major;

@end
