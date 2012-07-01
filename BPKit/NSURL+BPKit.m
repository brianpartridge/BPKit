//
//  NSURL+BPKit.m
//  BPKit
//
//  Created by Brian Partridge on 9/18/11.
//  Copyright 2011 Brian Partridge. All rights reserved.
//

#import "NSURL+BPKit.h"

@implementation NSURL (NSURL_BPKit)

+ (NSURL *)bp_urlWithString:(NSString *)urlString queryComponents:(NSDictionary *)queryComponents {
    return [NSURL URLWithString:[urlString stringByAppendingFormat:@"?%@", [queryComponents bp_queryStringForEntries]]];
}

- (NSString *)bp_urlStringByTrimmingQueryAndFragment {
    NSString *result = self.absoluteString;
    
    // Save everything before the query.
    NSRange queryRange = [self.absoluteString rangeOfString:self.query];
    if (queryRange.location != NSNotFound) {
        result = [result substringToIndex:queryRange.location];
    }
    
    // Remove any trailling ?'s
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?"]];
    
    return result;
}

- (NSDictionary *)bp_queryComponents {
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [self.query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if (keyValue.count != 2) {
            NSLog(@"Unexpected query component '%@'", pair);
            continue;
        }
        NSString *key = [(NSString *)[keyValue objectAtIndex:0] bp_urlDecodedString];
        NSString *value = [(NSString *)[keyValue objectAtIndex:1] bp_urlDecodedString];
        [results setObject:value forKey:key];
    }
    
    return [results copy];
}

@end
