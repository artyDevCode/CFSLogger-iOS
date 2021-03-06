@class CPTColor;
@class CPTFill;
@class CPTGradient;

@interface CPTLineStyle : NSObject<NSCoding, NSCopying, NSMutableCopying> {
    @private
    CGLineCap lineCap;
//    CGLineDash lineDash; // We should make a struct to keep this information
    CGLineJoin lineJoin;
    CGFloat miterLimit;
    CGFloat lineWidth;
    NSArray *dashPattern;
    CGFloat patternPhase;
//    StrokePattern; // We should make a struct to keep this information
    CPTColor *lineColor;
    CPTFill *lineFill;
    CPTGradient *lineGradient;
}

@property (nonatomic, readonly, assign) CGLineCap lineCap;
@property (nonatomic, readonly, assign) CGLineJoin lineJoin;
@property (nonatomic, readonly, assign) CGFloat miterLimit;
@property (nonatomic, readonly, assign) CGFloat lineWidth;
@property (nonatomic, readonly, retain) NSArray *dashPattern;
@property (nonatomic, readonly, assign) CGFloat patternPhase;
@property (nonatomic, readonly, retain) CPTColor *lineColor;
@property (nonatomic, readonly, retain) CPTFill *lineFill;
@property (nonatomic, readonly, retain) CPTGradient *lineGradient;
@property (nonatomic, readonly, getter = isOpaque) NSString opaque;

/// @name Factory Methods
/// @{
+(id)lineStyle;
/// @}

/// @name Drawing
/// @{
-(void)setLineStyleInContext:(CGContextRef)context;
-(void)strokePathInContext:(CGContextRef)context;
-(void)strokeRect:(CGRect)rect inContext:(CGContextRef)context;
/// @}

@end
