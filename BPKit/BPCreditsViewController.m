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

typedef enum {
    SectionCreator,
    SectionOtherApps,
    SectionThanks,
    SectionOpenSource,
    SectionCount,
}Sections;

typedef enum {
    SectionCreatorRowName,
    SectionCreatorRowCount,
    SectionCreatorRowTwitter,
} SectionCreatorRows;

@interface BPCreditsViewController ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSArray *thanks;
@property (nonatomic, strong) NSArray *projects;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BPCreditsViewController

@synthesize data;
@synthesize apps;
@synthesize thanks;
@synthesize projects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Credits";
    
    self.data = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BPAboutContent"];
    self.apps = [self.data objectForKey:@"BPOtherApps"];
    self.thanks = [self.data objectForKey:@"BPThanks"];
    self.projects = [self.data objectForKey:@"BPOSS"];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionCreator:
            switch (indexPath.row) {
                case SectionCreatorRowName: {
                    cell.textLabel.text = [self.data objectForKey:@"BPCreatorName"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    NSString *creatorImageName = [self.data objectForKey:@"BPCreatorImage"];
                    cell.imageView.image = [UIImage imageNamed:creatorImageName];
                    cell.imageView.layer.cornerRadius = 4;
                    cell.imageView.layer.borderWidth = 1;
                    cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
                }   break;
                case SectionCreatorRowTwitter:
                    cell.textLabel.text = [NSString stringWithFormat:@"@%@", [self.data objectForKey:@"BPCreatorTwitter"]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case SectionOtherApps: {
            NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
            cell.textLabel.text = [app objectForKey:@"AppName"];
            cell.detailTextLabel.text = [app objectForKey:@"AppSubtitle"];
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
            cell.textLabel.text = [thank objectForKey:@"ThankName"];
            NSString *thankURL = [thank objectForKey:@"ThankURL"];
            cell.accessoryType = (thankURL == nil) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = (thankURL == nil) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
        }   break;
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            cell.textLabel.text = [project objectForKey:@"ProjectName"];
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
        case SectionCreator:
            count = SectionCreatorRowCount;
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
        case SectionCreator:
            title = @"Creator";
            break;
        case SectionOtherApps:
            title = @"My Other Apps";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    
    switch (indexPath.section) {
        case SectionCreator:
            switch (indexPath.row) {
                case SectionCreatorRowName:
                    height = 52;
                    break;
                default:
                    break;
            }
            break;
        case SectionOtherApps:
            height = 64;
            break;
        default:
            break;
    }
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SectionCreator:
            switch (indexPath.row) {
                case SectionCreatorRowName: {
                    NSURL *url = [NSURL URLWithString:[self.data objectForKey:@"BPCreatorURL"]];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }   break;
                case SectionCreatorRowTwitter: {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", [self.data objectForKey:@"BPCreatorTwitter"]]];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }   break;
                default:
                    break;
            }
            break;
        case SectionOtherApps: {
            NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[app objectForKey:@"AppURL"]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [BPIndirectiTunesURLOpener openURL:url];
            }
        }   break;
        case SectionThanks: {
            id thank = [self.thanks objectAtIndex:indexPath.row];
            if ([thank isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = thank;
                NSString *thankURL = [dict objectForKey:@"ThankURL"];
                NSURL *url = [NSURL URLWithString:thankURL];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }   break;
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[project objectForKey:@"ProjectURL"]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }   break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionOpenSource: {
            NSDictionary *project = [self.projects objectAtIndex:indexPath.row];
            NSString *file = [project objectForKey:@"ProjectLicense"];
            NSURL *url = [[NSBundle mainBundle] URLForResource:[file stringByDeletingPathExtension] withExtension:[file pathExtension]];
            BPLicenseViewController *viewer = [[BPLicenseViewController alloc] init];
            viewer.licenseURL = url;
            [self.navigationController pushViewController:viewer animated:YES];
        }   break;
        default:
            break;
    }
}

@end
