//
//  BPSupportViewController.m
//  BPKit
//
//  Created by Brian Partridge on 3/17/12.
//  Copyright (c) 2012 Brian Partridge. All rights reserved.
//

#import "BPSupportViewController.h"
#import "BPCreditsViewController.h"

#pragma mark - Plist Keys
static NSString * const kBPSupportViewControllerContent = @"BPSupportViewControllerContent";

static NSString * const kSupportEmail = @"SupportEmail";
static NSString * const kSupportEmailImage = @"SupportEmailImage";
static NSString * const kSupportTwitter = @"SupportTwitter";
static NSString * const kSupportTwitterImage = @"SupportTwitterImage";

static NSString * const kRateURL = @"RateURL";
static NSString * const kRateImage = @"RateImage";
static NSString * const kUpgradeMessage = @"UpgradeMessage";
static NSString * const kUpgradeURL = @"UpgradeURL";
static NSString * const kUpgradeImage = @"UpgradeImage";
static NSString * const kUpgradeDescription = @"UpgradeDescription";

static NSString * const kCopyrightHolder = @"CopyrightHolder";
static NSString * const kCopyrightYear = @"CopyrightYear";
static NSString * const kCreditsImage = @"CreditsImage";

typedef enum {
    SectionSupport,
    SectionLike,
    SectionAbout,
    SectionCount,
} Sections;

typedef enum {
    SectionSupportRowEmail,
    SectionSupportRowTwitter,
    SectionSupportRowCount,
    SectionSupportRowCountNoTwitter = SectionSupportRowTwitter,
} SectionSupportRows;

typedef enum {
    SectionLikeRowRate,
    SectionLikeRowUpgrade,
    SectionLikeRowCount,
    SectionLikeRowCountNoUpgrade = SectionLikeRowUpgrade,
} SectionLikeRows;

typedef enum {
    SectionAboutRowApp,
    SectionAboutRowCredits,
    SectionAboutRowCount,
} SectionAboutRows;

@interface BPSupportViewController ()

@property (nonatomic, strong) NSDictionary *data;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BPSupportViewController

@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Support";
    
    self.data = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBPSupportViewControllerContent];
    
    // TODO: check for required keys
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionSupport:
            switch (indexPath.row) {
                case SectionSupportRowEmail:
                    cell.textLabel.text = @"Contact Support";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:[self.data objectForKey:kSupportEmailImage]];
                    break;
                case SectionSupportRowTwitter: {
                    NSString *twitter = [self.data objectForKey:kSupportTwitter];
                    cell.textLabel.text = [NSString stringWithFormat:@"@%@", twitter];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:[self.data objectForKey:kSupportTwitterImage]];
                }   break;
                default:
                    break;
            }
            break;
        case SectionLike:
            switch (indexPath.row) {
                case SectionLikeRowRate:
                    cell.textLabel.text = [NSString stringWithFormat:@"I Love It!", [NSBundle mainBundle].bp_name];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:[self.data objectForKey:kRateImage]];
                    break;
                case SectionLikeRowUpgrade: {
                    NSString *upgradeMessage = [self.data objectForKey:kUpgradeMessage];
                    cell.textLabel.text = ([NSString bp_isNilOrEmpty:upgradeMessage]) ? @"Upgrade" : upgradeMessage;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:[self.data objectForKey:kUpgradeImage]];
                }   break;
                default:
                    break;
            }
            break;
        case SectionAbout:
            switch (indexPath.row) {
                case SectionAboutRowApp:
                    cell.textLabel.text = [NSBundle mainBundle].bp_name;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", [NSBundle mainBundle].bp_version];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case SectionAboutRowCredits:
                    cell.textLabel.text = @"Credits";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:[self.data objectForKey:kCreditsImage]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)openURL:(NSURL *)url {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        // The URL (especially the upgrade URL) is probably an affiliate link, so use the indirect url opener to handle any redirects.
        if ([BPIndirectiTunesURLOpener isRedirectURL:url]) {
            [BPIndirectiTunesURLOpener openURL:url];
        } else {
            [app openURL:url];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    
    switch (section) {
        case SectionSupport:
            count = ([NSString bp_isNilOrEmpty:[self.data objectForKey:kSupportTwitter]]) ?
                     SectionSupportRowCountNoTwitter : SectionSupportRowCount;
            break;
        case SectionLike:
            count = ([NSString bp_isNilOrEmpty:[self.data objectForKey:kUpgradeURL]]) ?
                      SectionLikeRowCountNoUpgrade : SectionLikeRowCount;
            break;
        case SectionAbout:
            count = SectionAboutRowCount;
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    switch (section) {
        case SectionSupport:
            title = @"Found a problem?";
            break;
        case SectionLike:
            title = [NSString stringWithFormat:@"Like %@?", [NSBundle mainBundle].bp_name];
            break;
        default:
            break;
    }
    
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *title = nil;
    
    switch (section) {
        case SectionLike:
            title = [self.data objectForKey:kUpgradeDescription];
            break;
        case SectionAbout:
            title = [NSString stringWithFormat:@"‌© %@ %@", 
                     [self.data objectForKey:kCopyrightYear], 
                     [self.data objectForKey:kCopyrightHolder]];
            break;
        default:
            break;
    }
    
    return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case SectionSupport:
            switch (indexPath.row) {
                case SectionSupportRowEmail: {
                    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                    mailer.mailComposeDelegate = self;
                    [mailer setSubject:[NSString stringWithFormat:@"[%@ Support] ", [[NSBundle mainBundle] bp_name]]];
                    [mailer setToRecipients:[NSArray arrayWithObject:[self.data objectForKey:kSupportEmail]]];
                    NSString *body = [NSString stringWithFormat:@"\n\nThis message was generated by %@ v%@.", 
                                      [[NSBundle mainBundle] bp_name], 
                                      [[NSBundle mainBundle] bp_version]];
                    [mailer setMessageBody:body isHTML:NO];
                    [self presentModalViewController:mailer animated:YES];
                }   break;
                case SectionSupportRowTwitter: {
                    NSString *twitter = [self.data objectForKey:kSupportTwitter];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", twitter]];
                    [[UIApplication sharedApplication] bp_attemptOpenURL:url];
                }   break;
                default:
                    break;
            }
            break;
        case SectionLike:
            switch (indexPath.row) {
                case SectionLikeRowRate: {
                    NSURL *url = [NSURL URLWithString:[self.data objectForKey:kRateURL]];
                    [[UIApplication sharedApplication] bp_attemptOpenURL:url];
                }   break;
                case SectionLikeRowUpgrade: {
                    NSURL *url = [NSURL URLWithString:[self.data objectForKey:kUpgradeURL]];
                    [[UIApplication sharedApplication] bp_attemptOpenURL:url];
                }   break;
                default:
                    break;
            }
            break;
        case SectionAbout: {
            switch (indexPath.row) {
                case SectionAboutRowCredits: {
                    BPCreditsViewController *credits = [[BPCreditsViewController alloc] initWithStyle:self.tableView.style];
                    [self shareBlocksWithController:credits];
                    if (self.navigationController != nil) {
                        [self.navigationController pushViewController:credits animated:YES];
                    } else {
                        [self presentModalViewController:credits animated:YES];
                    }
                }   break;
                default:
                    break;
            }
        }   break;
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
}

@end
