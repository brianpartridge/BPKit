//
//  BPSupportViewController.h
//  BPKit
//
//  Created by Brian Partridge on 3/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

/*
 Provides a simple reusable BPTableViewController to layout support information.
 
 Usage:
 Add a new dictionary entry to your Info.plist named:
    BPSupportViewControllerContent
 
 Specify values for the following required keys:
    SupportEmail
    RateURL
    CopyrightHolder
    CopyrightYear
 
 Additional optional keys:
    SupportEmailImage
    SupportTwitter
    SupportTwitterImage
    RateURLImage
    UpgradeMessage
    UpgradeURL
    UpgradeURLImage
    UpgradeDescription
    CreditsImage
 */

@interface BPSupportViewController : BPTableViewController <MFMailComposeViewControllerDelegate>

@end
