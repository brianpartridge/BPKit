//
//  BPCreditsViewController.m
//  BPKit
//
//  Created by Brian Partridge on 3/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPCreditsViewController.h"
#import "BPLicenseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+BPKit.h"
#import "BPIndirectItunesURLOpener.h"

static NSString * const kBPCreditsViewControllerContent = @"BPCreditsViewControllerContent";

static NSString * const kCreators = @"Creators";
static NSString * const kOtherApps = @"OtherApps";
static NSString * const kThanks = @"Thanks";
static NSString * const kOSSProjects = @"OSSProjects";

static NSString * const kPersonName = @"Name";
static NSString * const kPersonTwitter = @"Twitter";
static NSString * const kPersonURL = @"URL";

static NSString * const kAppStoreId = @"StoreId";
static NSString * const kAppName = @"Name";
static NSString * const kAppSubtitle = @"Subtitle";
static NSString * const kAppURL = @"URL";

static NSString * const kProjectName = @"Name";
static NSString * const kProjectLicense = @"License";
static NSString * const kProjectURL = @"URL";

typedef enum {
    SectionCreators,
    SectionOtherApps,
    SectionThanks,
    SectionOpenSource,
    SectionCount,
}Sections;

@interface BPCreditsViewController ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *creators;
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSArray *thanks;
@property (nonatomic, strong) NSArray *projects;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BPCreditsViewController

@synthesize data;
@synthesize creators;
@synthesize apps;
@synthesize thanks;
@synthesize projects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Credits";
    
    self.data = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBPCreditsViewControllerContent];
    self.creators = [self.data objectForKey:kCreators];
    self.apps = [self.data objectForKey:kOtherApps];
    self.thanks = [self.data objectForKey:kThanks];
    self.projects = [self.data objectForKey:kOSSProjects];
    
    // TODO: validate required keys
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionCreators: {
            NSDictionary *creator = [self.creators objectAtIndex:indexPath.row];
            cell.textLabel.text = [creator objectForKey:kPersonName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *creatorImageName = [creator objectForKey:@"BPCreatorImage"];
            // TODO: support loading icon from URL
            cell.imageView.image = [UIImage imageNamed:creatorImageName];
            cell.imageView.layer.cornerRadius = 4;
            cell.imageView.layer.borderWidth = 1;
            cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        }   break;
        case SectionOtherApps: {
            NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
            cell.textLabel.text = [app objectForKey:kAppName];
            cell.detailTextLabel.text = [app objectForKey:kAppSubtitle];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *iconName = [app objectForKey:@"AppIcon"];
            // TODO: support loading icon from URL
            UIImage *icon = [UIImage imageNamed:iconName];
            icon = [UIImage bp_imageWithImage:icon scaledToSize:CGSizeMake(57, 57)];
            cell.imageView.image = icon;
            cell.imageView.layer.cornerRadius = 10;
            cell.imageView.layer.borderWidth = 1;
            cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        }   break;
        case SectionThanks: {
            NSDictionary *thank = [self.thanks objectAtIndex:indexPath.row];
            cell.textLabel.text = [thank objectForKey:kPersonName];
            NSString *thankURL = [thank objectForKey:kPersonURL];
            cell.accessoryType = (thankURL == nil) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = (thankURL == nil) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
        }   break;
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            cell.textLabel.text = [project objectForKey:kProjectName];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }   break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    
    switch (section) {
        case SectionCreators:
            count = self.creators.count;
            break;
        case SectionOtherApps:
            count = self.apps.count;
            break;
        case SectionThanks:
            count = self.thanks.count;
            break;
        case SectionOpenSource:
            count = self.projects.count;
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellForSection-%d", indexPath.section];
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
    if (indexPath.section == SectionOtherApps) {
        cellStyle = UITableViewCellStyleSubtitle;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    switch (section) {
        case SectionCreators:
            title = (self.creators.count == 1) ? @"Creator" : @"Creators";
            break;
        case SectionOtherApps:
            title = (self.creators.count == 1) ? @"My Other Apps" : @"Other Apps";
            break;
        case SectionThanks:
            title = @"Thanks";
            break;
        case SectionOpenSource:
            title = @"Open Source";
            break;
        default:
            break;
    }
    
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *title = nil;
    
    switch (section) {
        case SectionOpenSource:
            title = @"Thank you, project contributors!";
            break;
        default:
            break;
    }
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    
//    switch (indexPath.section) {
//        case SectionCreator:
//            switch (indexPath.row) {
//                case SectionCreatorRowName:
//                    height = 52;
//                    break;
//                default:
//                    break;
//            }
//            break;
//        case SectionOtherApps:
//            height = 64;
//            break;
//        default:
//            break;
//    }
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SectionCreators: {
            NSDictionary *creator = [self.creators objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[creator objectForKey:kPersonURL]];
            [[UIApplication sharedApplication] bp_attemptOpenURL:url];
        }   break;
        case SectionOtherApps: {
            NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[app objectForKey:kAppURL]];
            [[UIApplication sharedApplication] bp_attemptOpenURL:url];
        }   break;
        case SectionThanks: {
            NSDictionary *thank = [self.thanks objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[thank objectForKey:kPersonURL]];
            [[UIApplication sharedApplication] bp_attemptOpenURL:url];
        }   break;
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[project objectForKey:kProjectURL]];
            [[UIApplication sharedApplication] bp_attemptOpenURL:url];
        }   break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            NSString *file = [project objectForKey:kProjectLicense];
            NSURL *url = [[NSBundle mainBundle] URLForResource:[file stringByDeletingPathExtension]
                                                 withExtension:[file pathExtension]];
            BPLicenseViewController *viewer = [[BPLicenseViewController alloc] init];
            viewer.licenseURL = url;
            if (self.navigationController != nil) {
                [self.navigationController pushViewController:viewer animated:YES];
            } else {
                [self presentModalViewController:viewer animated:YES];
            }
        }   break;
        default:
            break;
    }
}

@end
