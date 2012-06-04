//
//  BPiTunesStoreClient.m
//  BPKit
//
//  Created by Brian Partridge on 6/3/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPiTunesStoreClient.h"

@implementation BPiTunesStoreClient

+ (void)retrieveDataForAppWithId:(NSString *)appStoreId
                      completion:(void(^)(NSDictionary *iTunesJSON))completionBlock
                           error:(void(^)(NSError *))errorBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appStoreId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
                               
                               // Deserialize JSON
                               NSError *jsonError = nil;
                               NSDictionary *json = [NSJSONSerialization bp_JSONDictionaryWithData:data options:0 error:&jsonError];
                               if (jsonError != nil) {
                                   if (errorBlock != nil) {
                                       errorBlock(jsonError);
                                   }
                                   return;
                               }
                               
                               // Pull out the specific result dictionary
                               NSArray *results = [json objectForKey:@"results"];
                               NSDictionary *result = [results lastObject];
                               if (completionBlock != nil) {
                                   completionBlock(result);
                               }
                           }];
}

@end
