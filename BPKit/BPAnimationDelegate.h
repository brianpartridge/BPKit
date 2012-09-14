//
//  BPAnimationDelegate.h
//  BPKit
//
//  Created by Brian Partridge on 9/14/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^BPAnimationDidStartBlock)(CAAnimation *animation);
typedef void(^BPAnimationDidStopBlock)(CAAnimation *animation, BOOL finished);

@interface BPAnimationDelegate : NSObject

@property (nonatomic, copy) BPAnimationDidStartBlock start;
@property (nonatomic, copy) BPAnimationDidStopBlock completion;

+ (BPAnimationDelegate *)delegateWithStart:(BPAnimationDidStartBlock)start
                                completion:(BPAnimationDidStopBlock)completion;

@end
