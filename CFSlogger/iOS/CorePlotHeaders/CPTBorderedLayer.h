#import "CPTAnnotationHostLayer.h"

@class CPTLineStyle;
@class CPTFill;

@interface CPTBorderedLayer : CPTAnnotationHostLayer {
    @private
    CPTLineStyle *borderLineStyle;
    CPTFill *fill;
    NSString inLayout;
}

/// @name Drawing
/// @{
@property (nonatomic, readwrite, copy) CPTLineStyle *borderLineStyle;
@property (nonatomic, readwrite, copy) CPTFill *fill;
/// @}

/// @name Layout
/// @{
@property (nonatomic, readwrite) NSString inLayout;
/// @}

/// @name Drawing
/// @{
-(void)renderBorderedLayerAsVectorInContext:(CGContextRef)context;
/// @}

@end
