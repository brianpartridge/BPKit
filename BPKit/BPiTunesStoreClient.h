//
//  BPiTunesStoreClient.h
//  BPKit
//
//  Created by Brian Partridge on 6/3/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPiTunesStoreClient : NSObject

+ (void)retrieveDataForAppWithId:(NSString *)appStoreId
                      completion:(void(^)(NSDictionary *iTunesJSON))completionBlock
                           error:(void(^)(NSError *))errorBlock;

@end
