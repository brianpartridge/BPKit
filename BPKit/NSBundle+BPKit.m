//
//  NSBundle+BPKit.m
//  BPKit
//
//  Created by Brian Partridge on 3/2/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "NSBundle+BPKit.h"

@implementation NSBundle (BPKit)

- (NSString *)bp_name {
    return [self bp_infoObjectForKey:(id)kCFBundleNameKey];
}

- (NSString *)bp_version {
    return [self bp_infoObjectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)bp_build {
    return [self bp_infoObjectForKey:(id)kCFBundleVersionKey];
}

- (NSString *)bp_formattedVersion {
    NSString *version = self.bp_version;
    NSString *build = self.bp_build;

    NSString *result = nil;
    if ([NSString bp_isNilOrEmpty:self.bp_build]) {
        // Version number only
        result = [NSString stringWithFormat:@"v%@", version];
    } else {
        // Version with build number
        result = [NSString stringWithFormat:@"v%@ (%@)", version, build];
    }
    return result;
}

- (id)bp_infoObjectForKey:(id)key {
    return [self.infoDictionary objectForKey:key];
}

@end
