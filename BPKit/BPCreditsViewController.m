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
#import "UIColor+BPKit.h"
#import "BPIndirectItunesURLOpener.h"
#import "BPiTunesStoreClient.h"
#import "BPImageDownloader.h"

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
static NSString * const kAppInstalledURLScheme = @"InstalledURLScheme";

static NSString * const kProjectName = @"Name";
static NSString * const kProjectLicense = @"License";
static NSString * const kProjectURL = @"URL";

#define PERSON_IMAGE_SIZE CGSizeMake(24, 24)
#define APP_IMAGE_SIZE CGSizeMake(57, 57)

typedef enum {
    SectionCreators,
    SectionApps,
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

@property (nonatomic, strong) NSCache *imageCache;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)loadImagesForVisibleRows;
- (void)loadImageAtURL:(NSURL *)url forIndexPath:(NSIndexPath *)indexPath;
- (void)didLoadImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath;

- (NSString *)iTunesArtworkKeyForCurrentDevice;
- (NSString *)twitterAvatarSizeForCurrentDevice;
- (NSURL *)avatarURLForTwitterUser:(NSString *)username withSize:(NSString *)size;

@end

@implementation BPCreditsViewController

@synthesize data;
@synthesize creators;
@synthesize apps;
@synthesize thanks;
@synthesize projects;
@synthesize imageCache;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Credits";
    
    self.data = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBPCreditsViewControllerContent];
    self.creators = [self.data objectForKey:kCreators];
    self.apps = [self.data objectForKey:kOtherApps];
    self.thanks = [self.data objectForKey:kThanks];
    self.projects = [self.data objectForKey:kOSSProjects];

    self.imageCache = [[NSCache alloc] init];
    
    // TODO: validate required keys
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadImagesForVisibleRows];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionCreators: {
            NSDictionary *creator = [self.creators objectAtIndex:indexPath.row];
            cell.textLabel.text = [creator objectForKey:kPersonName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }   break;
        case SectionApps: {
            NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
            cell.textLabel.text = [app objectForKey:kAppName];
            cell.detailTextLabel.text = [app objectForKey:kAppSubtitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = [self accessoryViewForApp:app atIndexPath:indexPath];
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
    
    UIImage *image = [self.imageCache objectForKey:indexPath];
    cell.imageView.image = image;
    cell.imageView.layer.cornerRadius = image.size.width * 10.0 / 57.0;
    cell.imageView.layer.borderWidth = 1;
    cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.63 alpha:1].CGColor;
    cell.imageView.clipsToBounds = YES;
}

- (UIButton *)accessoryViewForApp:(NSDictionary *)app atIndexPath:(NSIndexPath *)indexPath {
    NSString *scheme = [app objectForKey:kAppInstalledURLScheme];
    NSURL *testURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@:", scheme]];
    
    NSString *title = nil;
    UIColor *titleColor = nil;
    UIColor *shadowColor = nil;
    UIImage *image = nil;
    UIImage *highlightImage = nil;
    BOOL enabled = YES;
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        title = @"INSTALLED";
        titleColor = [UIColor bp_colorWithHex:@"#737376"];
        image = [[UIImage imageNamed:@"PurchasedAlready"] stretchableImageWithLeftCapWidth:3 topCapHeight:0];
        enabled = NO;
    } else {
        title = @"APP STORE";
        titleColor = [UIColor whiteColor];
        shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        image = [[UIImage imageNamed:@"PurchaseConfirmButton"] stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        highlightImage = [[UIImage imageNamed:@"PurchaseConfirmButtonPressed"] stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        enabled = YES;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button setFrame:CGRectMake(0, 0, 86, 25)];
    button.enabled = enabled;
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(appAccessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
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
        case SectionApps:
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
    UITableViewCellStyle cellStyle = (indexPath.section == SectionApps) ? UITableViewCellStyleSubtitle : UITableViewCellStyleValue1;
    
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
        case SectionApps:
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
    
    switch (indexPath.section) {
        case SectionApps:
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
        case SectionCreators: {
            NSDictionary *creator = [self.creators objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:[creator objectForKey:kPersonURL]];
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

- (void)appAccessoryButtonTapped:(UIButton *)button {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:SectionApps];
    NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[app objectForKey:kAppURL]];
    [[UIApplication sharedApplication] bp_attemptOpenURL:url];
}

#pragma mark - Image Downloading

- (void)loadImagesForVisibleRows {
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        if ([self.imageCache objectForKey:indexPath] != nil) {
            // Already cached, no need to proceed.
            continue;
        }

        switch (indexPath.section) {
            case SectionCreators: {
                NSDictionary *creator = [self.creators objectAtIndex:indexPath.row];
                NSString *twitter = [creator objectForKey:kPersonTwitter];
                NSURL *url = [self avatarURLForTwitterUser:twitter withSize:[self twitterAvatarSizeForCurrentDevice]];
                [self loadImageAtURL:url forIndexPath:indexPath];
            }   break;
            case SectionApps: {
                // Lookup the app in the store...
                NSDictionary *app = [self.apps objectAtIndex:indexPath.row];
                NSString *storeId = [app objectForKey:kAppStoreId];
                [BPiTunesStoreClient retrieveDataForAppWithId:storeId
                                                   completion:^(NSDictionary *iTunesItem) {
                                                       // ... and determine the right icon to use based on if this is a retina device or not.
                                                       NSString *urlString = [iTunesItem objectForKey:[self iTunesArtworkKeyForCurrentDevice]];
                                                       NSURL *url = [NSURL URLWithString:urlString];
                                                       [self loadImageAtURL:url forIndexPath:indexPath];
                                                   } error:nil];
            }   break;
            case SectionThanks: {
                NSDictionary *thank = [self.thanks objectAtIndex:indexPath.row];
                NSString *twitter = [thank objectForKey:kPersonTwitter];
                NSURL *url = [self avatarURLForTwitterUser:twitter withSize:[self twitterAvatarSizeForCurrentDevice]];
                [self loadImageAtURL:url forIndexPath:indexPath];
            }   break;
            default:
                break;
        }
    }
}

- (void)loadImageAtURL:(NSURL *)url forIndexPath:(NSIndexPath *)indexPath {
    [BPImageDownloader imageForURL:url completion:^(UIImage *image) {
        [self didLoadImage:image forIndexPath:indexPath];
    } error:nil];
}

- (void)didLoadImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath {
    if (image == nil) {
        return;
    }
    
    switch (indexPath.section) {
        case SectionCreators:
        case SectionThanks:
            image = [UIImage bp_imageWithImage:image scaledToSize:PERSON_IMAGE_SIZE];
            break;
        case SectionApps:
            image = [UIImage bp_imageWithImage:image scaledToSize:APP_IMAGE_SIZE];
            break;
        default:
            break;
    }
    
    // Cache the image and reload the cell so it gets applied.
    [self.imageCache setObject:image forKey:indexPath];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Utils

- (NSString *)iTunesArtworkKeyForCurrentDevice {
    return ([UIScreen mainScreen].scale == 2.0) ? @"artworkUrl512" : @"artworkUrl60";
}

- (NSString *)twitterAvatarSizeForCurrentDevice {
    return ([UIScreen mainScreen].scale == 2.0) ? @"normal" : @"mini";
}

/*
 Returns a URL to a Twitter avatar image.
 Valid values for size are:
     bigger - 73px by 73px
     normal - 48px by 48px
     mini - 24px by 24px
     original - undefined
 */
- (NSURL *)avatarURLForTwitterUser:(NSString *)username withSize:(NSString *)size {
    if (size == nil) {
        size = @"normal";
    }
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=%@", username, size];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForVisibleRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForVisibleRows];
}

@end
