//
//  BPAnimationDelegate.m
//  BPKit
//
//  Created by Brian Partridge on 9/14/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPAnimationDelegate.h"

@implementation BPAnimationDelegate

- (void)animationDidStart:(CAAnimation *)theAnimation {
    if (self.start != nil) {
        self.start(theAnimation);
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (self.completion != nil) {
        self.completion(theAnimation, flag);
    }
}

+ (BPAnimationDelegate *)delegateWithStart:(BPAnimationDidStartBlock)start completion:(BPAnimationDidStopBlock)completion {
    BPAnimationDelegate *delegate = [[BPAnimationDelegate alloc] init];
    delegate.start = start;
    delegate.completion = completion;
    return delegate;
}

@end
