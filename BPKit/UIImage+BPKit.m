//
//  UIImage+BPKit.m
//  BPKit
//
//  Created by Brian Partridge on 4/16/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "UIImage+BPKit.h"

@implementation UIImage (BPKit)

+ (UIImage *)bp_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
