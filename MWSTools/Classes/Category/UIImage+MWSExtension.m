//
//  UIImage+MWSExtension.h
//
//  Created by 马文帅 on 2018/6/19.
//  Copyright © 2018年 mawenshuai. All rights reserved.
//

@import Accelerate;
#import "UIImage+MWSExtension.h"

@implementation UIImage (MWSColorUtils)

+ (UIImage *)mws_imageWithColor:(UIColor *)color {
    return  [self mws_imageWithColor:color size:CGSizeMake(1, 1) cornerRadius:0];
}

+ (UIImage *)mws_imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self mws_imageWithColor:color size:size cornerRadius:0];
}

+ (UIImage *)mws_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (radius > 0) {
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContext(size);

        // Add a clip before drawing anything, in the shape of an rounded rect
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
        // Draw your image
        [image drawInRect:rect];

        // Get the image, here setting the UIImageView image
        image = UIGraphicsGetImageFromCurrentImageContext();

        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
    }

    return image;
}

@end

typedef NS_ENUM(NSInteger, MWSDeviceClass) {
    mws_DeviceClass_iPhone,
    mws_DeviceClass_iPhone5,
    mws_DeviceClass_iPhone6,
    mws_DeviceClass_iPhone6plus,
    mws_DeviceClass_iPhoneX,
    mws_DeviceClass_iPad,
    mws_DeviceClass_unknown
};

MWSDeviceClass mws_currentDeviceClass() {

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat greaterPixelDimension = screenHeight > screenWidth ? screenHeight : screenWidth;
    
    switch ((NSInteger)greaterPixelDimension) {
        case 480:
            return mws_DeviceClass_iPhone;
            break;
        case 568:
            return mws_DeviceClass_iPhone5;
            break;
        case 667:
            return mws_DeviceClass_iPhone6;
            break;
        case 736:
            return mws_DeviceClass_iPhone6plus;
            break;
        case 812:
            return mws_DeviceClass_iPhoneX;
        case 1024:
            return mws_DeviceClass_iPad;
            break;
        case 1366:
            return mws_DeviceClass_iPad;
            break;
        default:
            return mws_DeviceClass_unknown;
            break;
    }
}

@implementation UIImage (MWSDeviceSpecificMedia)

+ (instancetype )mws_imageForDeviceWithName:(NSString *)fileName
{
    UIImage *result = nil;
    NSString *nameWithSuffix = [fileName stringByAppendingString:[UIImage mws_magicSuffixForDevice]];
    
    result = [UIImage imageNamed:nameWithSuffix];

    if (!result) {
        result = [UIImage imageNamed:fileName];
    }
    return result;
}

#pragma mark - private methods
+ (NSString *)mws_magicSuffixForDevice
{
    switch (mws_currentDeviceClass()) {
        case mws_DeviceClass_iPhone:
            return @"_480h";
            break;
        case mws_DeviceClass_iPhone5:
            return @"_568h"; //只是个命名约定
            break;
        case mws_DeviceClass_iPhone6:
            return @"_667h"; //只是个命名约定
            break;
        case mws_DeviceClass_iPhone6plus:
            return @"_736h"; //主要是防止以后出现其他尺寸不同的@3x的设备，不然可以和不带后缀的放一起
            break;
        case mws_DeviceClass_iPhoneX:
            return @"_812h";
            break;
        case mws_DeviceClass_iPad:
            return @"_iPad";
            break;
        case mws_DeviceClass_unknown:
        default:
            return @"";
            break;
    }
}

@end



@implementation UIImage (MWSImageBlurEffects)


- (UIImage *)mws_applyLightBlurEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self mws_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)mws_applyDarkBlurEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self mws_applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)mws_applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self mws_applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)mws_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }

    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);

        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);

    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);

    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }

    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }

    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end

@implementation UIImage (MWSFrameUtils)

- (UIImage *)mws_scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)mws_clipToRect:(CGRect)rect {
    CGRect targetRect = CGRectMake(rect.origin.x,
                                   rect.origin.y,
                                   rect.size.width,
                                   rect.size.height);
    CGImageRef cgimg = CGImageCreateWithImageInRect(self.CGImage, targetRect);
    UIImage *destImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return destImg;
}

- (UIImage *)mws_scaleToWidth:(CGFloat)width {
    CGFloat height = width / self.size.width * self.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)mws_circleImage {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)mws_circleImageBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CGFloat imageW = self.size.width + 2 * borderWidth;
    CGFloat imageH = self.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 大圆
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 画图
    [self drawInRect:CGRectMake(borderWidth, borderWidth, self.size.width, self.size.height)];
    
    // 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)mws_circleImageBigBorderWidth:(CGFloat)bigBorderWidth bigBorderColor:(UIColor *)bigBorderColor littleBorderWidth:(CGFloat)littleBorderWidth littleBorderColor:(UIColor *)littleBorderColor {
    CGFloat imageW = self.size.width + 2 * bigBorderWidth;
    CGFloat imageH = self.size.height + 2 * bigBorderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //大大圆
    [bigBorderColor set];
    CGFloat bigbigRadius = imageW * 0.5; // 大圆半径
    CGFloat bigcenterX = bigbigRadius; // 圆心
    CGFloat bigcenterY = bigbigRadius;
    CGContextAddArc(ctx, bigcenterX, bigcenterY, bigbigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 大圆
    [littleBorderColor set];
    CGFloat bigRadius = bigbigRadius-bigBorderWidth; // 大圆半径
    CGContextAddArc(ctx, bigcenterX, bigcenterY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 小圆
    CGFloat smallRadius = bigRadius - littleBorderWidth;
    CGContextAddArc(ctx, bigcenterX, bigcenterY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 画图
    [self drawInRect:CGRectMake(bigBorderWidth, bigBorderWidth, self.size.width, self.size.height)];
    
    // 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)mws_clipToCornerRadius:(CGFloat)radius {
    UIGraphicsBeginImageContext(self.size);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [self drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)mws_compressToMaxFileSize:(NSUInteger)bytes {
    CGFloat compression = 1.0;
    CGFloat maxCompression = 0.1;

    NSData *imageData = UIImageJPEGRepresentation(self, compression);

    while ([imageData length] > bytes && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    return [UIImage imageWithData:imageData];
}

+ (instancetype)mws_cupWithView:(UIView *)view {
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 2.获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3.把控制器图层渲染到上下文
    [view.layer renderInContext:ctx];
    
    // 4.取出新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*
 *  直接截屏
 */
+ (UIImage *)mws_cutScreen {
    return [self mws_cupWithView:[UIApplication sharedApplication].keyWindow];
}

- (UIImage *)mws_cutWithFrame:(CGRect)frame {
    //创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    //释放CGImage
    CGImageRelease(cgimage);
    return newImage;
}


@end
