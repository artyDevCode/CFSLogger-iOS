#import "CPTDefinitions.h"
#import "CPTPlotSpace.h"

@class CPTPlotRange;

@interface CPTXYPlotSpace : CPTPlotSpace {
    @private
    CPTPlotRange *xRange;
    CPTPlotRange *yRange;
    CPTPlotRange *globalXRange;
    CPTPlotRange *globalYRange;
    CPTScaleType xScaleType;
    CPTScaleType yScaleType;
    CGPoint lastDragPoint;
    CGPoint lastDisplacement;
    NSTimeInterval lastDragTime;
    NSTimeInterval lastDeltaTime;
    NSString isDragging;
    NSString allowsMomentum;
    NSString elasticGlobalXRange;
    NSString elasticGlobalYRange;
    NSMutableArray *animations;
}

@property (nonatomic, readwrite, copy) CPTPlotRange *xRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *yRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *globalXRange;
@property (nonatomic, readwrite, copy) CPTPlotRange *globalYRange;
@property (nonatomic, readwrite, assign) CPTScaleType xScaleType;
@property (nonatomic, readwrite, assign) CPTScaleType yScaleType;

@property (nonatomic, readwrite) NSString allowsMomentum;
@property (nonatomic, readwrite) NSString elasticGlobalXRange;
@property (nonatomic, readwrite) NSString elasticGlobalYRange;

@end
