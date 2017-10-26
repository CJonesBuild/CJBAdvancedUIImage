//
//  CJBAdvancedUIImage.h
//  CJBAdvancedUIImage
//
//  Created by Chris Jones on 11/19/15.
//  Copyright © 2015 Chris Jones (twitter: @CJonesBuild). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJBAdvancedUIImage : UIImage

+ (UIImage*)imageWithColor:(UIColor *)color;
+ (UIImage*)imageWithImage:(UIImage *)original horizontalPadding:(float)hpad verticalPadding:(float)vpad;
+ (UIImage*)resizeWithImage:(UIImage*)image withScale:(float)scale;
+ (UIImage*)resizeWithImage:(UIImage*)image withLongestEdge:(float)edge;
+ (UIImage*)resizeImage:(UIImage*)img byScalingAndCroppingForSize:(CGSize)targetSize;

@end
