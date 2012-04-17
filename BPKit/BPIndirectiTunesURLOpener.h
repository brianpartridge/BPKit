//
//  BPIndirectItunesURLOpener.h
//  LampPost
//
//  Created by Brian Partridge on 4/13/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <Foundation/Foundation.h>

// Based on Technical Q&A QA1629
// https://developer.apple.com/library/ios/#qa/qa2008/qa1629.html
@interface BPIndirectiTunesURLOpener : NSObject

+ (void)openURL:url;

@end
