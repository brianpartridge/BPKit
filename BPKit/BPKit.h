//
//  BPKit.h
//  BPKit
//
//  Created by Brian Partridge on 9/18/11.
//  Copyright 2011 Brian Partridge. All rights reserved.
//

#ifndef BPKIT
#define BPKIT

#pragma mark - Constants

extern NSString * const BPKitErrorDomain;

typedef enum {
    BPKitErrorUnexpectedReturnType,
    BPKitErrorUnknown,
} BPKitError;

#pragma mark - Helpers

#define DegreesToRadians(degrees) (degrees * M_PI / 180.0)
#define RadiansToDegrees(radians) (radians * 180.0 / M_PI)

#pragma mark - Categories

#import "NSBundle+BPKit.h"
#import "NSDictionary+BPKit.h"
#import "NSJSONSerialization+BPKit.h"
#import "NSSet+BPKit.h"
#import "NSString+BPKit.h"
#import "NSURL+BPKit.h"
#import "UIColor+BPKit.h"
#import "UIImage+BPKit.h"

#pragma mark - Controllers

#import "BPTableViewController.h"
#import "BPSupportViewController.h"
#import "BPCreditsViewController.h"
#import "BPLicenseViewController.h"

#pragma mark - Views

#import "BPTransparentToolbar.h"
#import "BPAlertView.h"

#pragma mark - Utils

#import "BPIndirectiTunesURLOpener.h"
#import "BPiTunesStoreClient.h"
#import "BPImageDownloader.h"
#import "BPAnimationDelegate.h"

#endif