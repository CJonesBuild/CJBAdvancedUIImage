//
//  CJBAdvancedUIImage.m
//  CJBAdvancedUIImage
//
//  Created by Chris Jones on 11/19/15.
//  Copyright © 2015 Chris Jones (twitter: @CJonesBuild). All rights reserved.
//

#import "CJBAdvancedUIImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation CJBAdvancedUIImage

/**
 * Creates a 1px image based on the UIColor.
 *
 * @note This method creates a 1px image based on UIColor that can be used with [UIButton setBackgroundImage: forState:] to allow simple color to be used on custom buttons (such as UIControlStateNormal, UIControlStateHighlighted, UIControlStateSelected).
 *
 * @param color the UIColor object to be used to fill the image.
 * @return A UIImage object filled with the UIColor specified.
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

/**
 * Creates a new image modified to include additional padding.
 *
 * @note This method creates a new image from a source image that includes padding in the image space itself.
 *
 * @param hpad  pixels of horizontal padding..
 * @param vpad  pixels of vertical padding.
 * @return A new UIImage with rendered padding.
 */
+ (UIImage *)imageWithImage:(UIImage *)original horizontalPadding:(float)hpad verticalPadding:(float)vpad {
	
	// Setup a new context with the correct size
	CGFloat width = (2*hpad)+original.size.width;
	CGFloat height = (2*vpad)+original.size.height;
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	// Now we can draw anything we want into this new context.
	CGPoint origin = CGPointMake(hpad,vpad);
	[original drawAtPoint:origin];
	
	// Clean up and get the new image.
	UIGraphicsPopContext();
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

/**
 * Dynamicially compresses an image with a target filesize, returning nil if unable to achieve this target.
 *
 * @note This method dynamicially compresses (maximum ratio 50%) an image using JPEG compression functions to achieve a target file size.  Designed to be used as a pre-upload image compressor to ease bandwidth/server burden.
 *
 * @param targetSize size in Kb the image should achieve.
 * @return A new UIImage that has been compressed, or nil if unsuccessful.
 */
+ (UIImage*)resizeWithImage:(UIImage*)image forTargetFileSize:(float)targetSize {

	float comp = 1.0;
	NSData *imageData = UIImageJPEGRepresentation(image, comp);
	for (comp=comp; (comp>=0.5 && [imageData length]>=targetSize*1024.0); comp=comp-0.05) {
		imageData = UIImageJPEGRepresentation(image, comp);
	}
	if (comp<=0.5 && [imageData length]>=targetSize*1024.0) {
		NSLog(@"[CJBAdvancedUIImage] Unable to achieve target filesize");
		NSLog(@"[CJBAdvancedUIImage] Best Effort -> resulting filesize: %.1fKb (%.2f compression)",(double)([imageData length]/1024.0),comp);
		return nil;
	}

	NSLog(@"[CJBAdvancedUIImage] resulting filesize: %.1fKb (%.2f compression)",(double)([imageData length]/1024.0),comp);
	return [UIImage imageWithData:imageData];
}

/**
 * Rescales an image.
 *
 * @note This method creates a new image from a source image is rescaled.  Designed to be used as a pre-upload image scaler to ease bandwidth/server burden.
 *
 * @param image scale factor
 * @return A new UIImage that has been rescaled.
 */
+ (UIImage*)resizeWithImage:(UIImage*)image withScale:(float)scale
{
	CGSize scaledSize = CGSizeMake((image.size.width*scale), (image.size.height*scale));
	UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 1.0);
	[image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
+ (UIImage*)resizeWithImage:(UIImage*)image withLongestEdge:(float)edge
{
	if (image.size.width>image.size.height) {
		float scale = edge/image.size.width;
		return [self resizeWithImage:image withScale:scale];
	} else {
		float scale = edge/image.size.height;
		return [self resizeWithImage:image withScale:scale];
	}
}
+ (UIImage*)resizeImage:(UIImage*)img byScalingAndCroppingForSize:(CGSize)targetSize{
	// must run as main thread
	//NSAssert([NSOperationQueue currentQueue]==[NSOperationQueue mainQueue], @"[CJBAdvancedUIImage] Assert resizeImage:byScalingAndCroppingForSize: MUST be run on the main thread");

	UIImage *sourceImage = img;
	UIImage *newImage = nil;
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO)
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;

		if (widthFactor > heightFactor)
		{
			scaleFactor = widthFactor; // scale to fit height
		}
		else
		{
			scaleFactor = heightFactor; // scale to fit width
		}

		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;

		// center the image
		if (widthFactor > heightFactor)
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else
		{
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
		}
	}

	UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0); // this will crop

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();

	if(newImage == nil)
	{
		NSLog(@"[CJBAdvancedUIImage] could not scale image");
	}

	//pop the context to get back to the default
	UIGraphicsEndImageContext();

	return newImage;
}
@end
