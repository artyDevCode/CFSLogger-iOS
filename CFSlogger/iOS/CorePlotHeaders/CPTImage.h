@interface CPTImage : NSObject<NSCoding, NSCopying> {
    @private
    CGImageRef image;
    CGFloat scale;
    NSString tiled;
    NSString tileAnchoredToContext;
}

@property (nonatomic, readwrite, assign) CGImageRef image;
@property (nonatomic, readwrite, assign) CGFloat scale;
@property (nonatomic, readwrite, assign, getter = isTiled) NSString tiled;
@property (nonatomic, readwrite, assign) NSString tileAnchoredToContext;
@property (nonatomic, readonly, getter = isOpaque) NSString opaque;

/// @name Factory Methods
/// @{
+(CPTImage *)imageWithCGImage:(CGImageRef)anImage scale:(CGFloat)newScale;
+(CPTImage *)imageWithCGImage:(CGImageRef)anImage;
+(CPTImage *)imageForPNGFile:(NSString *)path;
/// @}

/// @name Initialization
/// @{
-(id)initWithCGImage:(CGImageRef)anImage scale:(CGFloat)newScale;
-(id)initWithCGImage:(CGImageRef)anImage;
-(id)initForPNGFile:(NSString *)path;
/// @}

/// @name Drawing
/// @{
-(void)drawInRect:(CGRect)rect inContext:(CGContextRef)context;
/// @}

@end
