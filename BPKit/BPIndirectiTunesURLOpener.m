//
//  BPIndirectItunesURLOpener.m
//  LampPost
//
//  Created by Brian Partridge on 4/13/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPIndirectiTunesURLOpener.h"

@interface BPIndirectiTunesURLOpener ()

@property (nonatomic, strong) NSURL *responseURL;

- (void)openURL:url;

@end

@implementation BPIndirectiTunesURLOpener

#pragma mark - Class Methods

+ (void)openURL:url {
    BPIndirectiTunesURLOpener *opener = [[BPIndirectiTunesURLOpener alloc] init];
    [opener openURL:url];
}

#pragma mark - Instance Methods

@synthesize responseURL;

- (void)openURL:(id)url {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] 
                                    delegate:self 
                            startImmediately:YES];
#pragma clang diagnostic pop
}

// Save the most recent URL in case multiple redirects occur
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    self.responseURL = response.URL;
    if( [self.responseURL.host hasSuffix:@"itunes.apple.com"]) {
        [connection cancel];
        [self connectionDidFinishLoading:connection];
        return nil;
    }
    else {
        return request;
    }
}

// No more redirects; use the last URL saved
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] openURL:self.responseURL];
}

@end
