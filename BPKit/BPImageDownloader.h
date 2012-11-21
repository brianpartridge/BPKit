//
//  BPImageDownloader.h
//  BPKit
//
//  Created by Brian Partridge on 6/3/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPImageDownloader : NSObject

+ (void)imageForURL:(NSURL *)url
         completion:(void(^)(UIImage *image))completionBlock
              error:(void(^)(NSError *error))errorBlock;

+ (void)imageForURL:(NSURL *)url
        cachePolicy:(NSURLRequestCachePolicy)cachePolicy
         completion:(void(^)(UIImage *image))completionBlock
              error:(void(^)(NSError *error))errorBlock;

@end
