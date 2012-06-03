//
//  BPIndirectItunesURLOpener.h
//  LampPost
//
//  Created by Brian Partridge on 4/13/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (BPIndirectiTunesURLOpener)

- (void)bp_openURL:(NSURL *)url;

@end

// Based on Technical Q&A QA1629
// https://developer.apple.com/library/ios/#qa/qa2008/qa1629.html
@interface BPIndirectiTunesURLOpener : NSObject

+ (BOOL)isRedirectURL:(NSURL *)url;
+ (void)openURL:(NSURL *)url;

@end
