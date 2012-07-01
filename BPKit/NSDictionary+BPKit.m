//
//  NSDictionary+BPKit.m
//  BPKit
//
//  Created by Brian Partridge on 9/18/11.
//  Copyright 2011 Brian Partridge. All rights reserved.
//

#import "NSDictionary+BPKit.h"

@implementation NSDictionary (BPKit)

- (NSString  *)bp_stringForKey:(id)key {
	id object = [self objectForKey:key];
	if (object == [NSNull null] || 
        ![object isKindOfClass:[NSString class]]) {
		return nil;
	}
	return object;
}

- (NSNumber *)bp_numberForKey:(id)key {
	id object = [self objectForKey:key];
	if (object == [NSNull null] || 
        ![object isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	return object;
}

- (NSDictionary *)bp_dictionaryForKey:(id)key {
	id object = [self objectForKey:key];
	if (object == [NSNull null] || 
        ![object isKindOfClass:[NSDictionary class]]) {
		return nil;
	}
	return object;
}

- (NSArray *)bp_arrayForKey:(id)key {
	id object = [self objectForKey:key];
	if (object == [NSNull null] || 
        ![object isKindOfClass:[NSArray class]]) {
		return nil;
	}
	return object;
}

- (NSString *)bp_queryStringForEntries {
    NSMutableArray *components = [NSMutableArray array];
    NSEnumerator *enumerator = self.keyEnumerator;
    id key;
    while ((key = [enumerator nextObject])) {
        id value = [self objectForKey:key];
        NSString *valueString = nil;
        if ([value isKindOfClass:[NSString class]]) {
            valueString = [value bp_urlEncodedString];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            valueString = [value stringValue];
        } else {
            NSLog(@"Skipping query string value of type: %@", NSStringFromClass([value class]));
            continue;
        }
        
        NSString *keyString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = [key bp_urlEncodedString];
        } else if ([key isKindOfClass:[NSNumber class]]) {
            keyString = [key stringValue];
        } else {
            NSLog(@"Skipping query string key of type: %@", NSStringFromClass([key class]));
            continue;
        }
        
        NSString *component = [NSString stringWithFormat: @"%@=%@", 
                               keyString,
                               valueString];
        [components addObject:component];
    }
    return [components componentsJoinedByString: @"&"];
}

@end
