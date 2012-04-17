//
//  UIImage+BPKit.h
//  BPKit
//
//  Created by Brian Partridge on 4/16/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BPKit)

// Originally from: http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
+ (UIImage *)bp_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
