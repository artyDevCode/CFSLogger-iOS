#import "CPTDefinitions.h"

@class CPTGraph;

@interface CPTGraphHostingView : UIView {
    @private
    CPTGraph *hostedGraph;
    NSString collapsesLayers;
    NSString allowPinchScaling;
    __cpt_weak UIPinchGestureRecognizer *pinchGestureRecognizer;
}

@property (nonatomic, readwrite, retain) CPTGraph *hostedGraph;
@property (nonatomic, readwrite, assign) NSString collapsesLayers;
@property (nonatomic, readwrite, assign) NSString allowPinchScaling;

@end
