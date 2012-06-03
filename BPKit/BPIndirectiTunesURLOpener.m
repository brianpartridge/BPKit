//
//  BPIndirectItunesURLOpener.m
//  LampPost
//
//  Created by Brian Partridge on 4/13/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPIndirectiTunesURLOpener.h"

static NSString * const kLinkShareURLHostSuffix = @"click.linksynergy.com";
static NSString * const kiTunesURLHostSuffix = @"itunes.apple.com";

@implementation UIApplication (BPIndirectiTunesURLOpener)

- (void)bp_openURL:(NSURL *)url {
    // Check for affiliate/redirect URLs and use the indirect url opener if necessary.
    if ([BPIndirectiTunesURLOpener isRedirectURL:url]) {
        [BPIndirectiTunesURLOpener openURL:url];
    } else {
        [self openURL:url];
    }
}

@end

@interface BPIndirectiTunesURLOpener ()

@property (nonatomic, strong) NSURL *responseURL;

- (void)openURL:(NSURL *)url;

@end

@implementation BPIndirectiTunesURLOpener

#pragma mark - Class Methods

+ (void)openURL:url {
    BPIndirectiTunesURLOpener *opener = [[BPIndirectiTunesURLOpener alloc] init];
    [opener openURL:url];
}

#pragma mark - Instance Methods

@synthesize responseURL;

+ (BOOL)isRedirectURL:(NSURL *)url {
    return [url.host hasSuffix:kLinkShareURLHostSuffix];
}

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
    if( [self.responseURL.host hasSuffix:kiTunesURLHostSuffix]) {
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
