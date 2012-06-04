//
//  BPCreditsViewController.h
//  BPKit
//
//  Created by Brian Partridge on 3/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Provides a simple reusable BPTableViewController to layout credits for an app.
 
 Usage:
 Add a new dictionary entry to your Info.plist named:
    BPCreditsViewControllerContent
 
 Specify values for the following required keys:
    Creators - An array of 'people' dictionaries
    OtherApps - An array of 'app' dictionaries
    Thanks - An array of 'people' dictionaries
    OSSProjects - An array of 'project' dictionaries
 
 'People' Keys:
    Name
    Twitter - used to retrieve their avatar
    URL
 
 'App' Keys:
    StoreId
    Name
    Subtitle
    URL
 
 'Project' Keys:
    Name
    License - the name of a license file to be displayed (plain text or HTML)
    URL

 */

@interface BPCreditsViewController : BPTableViewController

@end
