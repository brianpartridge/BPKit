//
//  BPImageDownloader.m
//  BPKit
//
//  Created by Brian Partridge on 6/3/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPImageDownloader.h"

@implementation BPImageDownloader

+ (void)imageForURL:(NSURL *)url
         completion:(void(^)(UIImage *image))completionBlock
              error:(void(^)(NSError *error))errorBlock {
    [BPImageDownloader imageForURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy completion:completionBlock error:errorBlock];
}

+ (void)imageForURL:(NSURL *)url
        cachePolicy:(NSURLRequestCachePolicy)cachePolicy
         completion:(void(^)(UIImage *image))completionBlock
              error:(void(^)(NSError *error))errorBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:cachePolicy timeoutInterval:60];
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // NOTE: No need to dispatch completion/error blocks since this in on the main thread.
                               
                               if (error != nil) {
                                   if (errorBlock != nil) {
                                       errorBlock(error);
                                   }
                                   return;
                               }
                               
                               UIImage *result = [UIImage imageWithData:data];
                               if (completionBlock != nil) {
                                   completionBlock(result);
                               }
                           }];
}

@end

