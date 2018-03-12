
#import "AboutUsViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"

#define CALL_US @"✆ Call us"
#define SEND_EMAIL @"✉️ Send email"
#define FACEBOOK @"• Follow us on Facebook"
#define TWITTER @"• Follow us on Twitter"
#define INSTAGRAM @"• Follow us on Instagram"
#define PINTEREST @"• Follow us on Pinterest"

@interface AboutUsViewController() {
    NSArray *contacts;
    NSArray *socialNetworks;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contacts = @[CALL_US, SEND_EMAIL];
    socialNetworks = @[FACEBOOK, TWITTER, INSTAGRAM, PINTEREST];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    else if (section == 2) {
        return [self.openHours count];
    }
    else if (section == 3) {
        return [contacts count];
    }
    else if (section == 4) {
        return [socialNetworks count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"Open Hours";
    }
    else if (section == 3) {
        return @"Get in touch";
    }
    else if (section == 4) {
        return @"Social networks";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0 && section != 1) {
        return 1.5 * self.tableView.sectionHeaderHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [colorHelper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"RestaurantImageCell"];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waitingImage.png"]];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        uint32_t randomIndex = arc4random_uniform((uint32_t)[self.business.welcomeImages count]);
        Picture *picture = [self.business.welcomeImages objectAtIndex:randomIndex];
        if ([userDefaultsHelper getImageFromUserDefaults:picture.url]) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[userDefaultsHelper getImageFromUserDefaults:picture.url]];
            cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
                if (image && picture.url) {
                    NSLog(@"%@, %@", image, picture.url);
                    [userDefaultsHelper saveImageToUserDefaults:image withKey:picture.url];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
                });
            });
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        RestaurantInfoCell *cell = (RestaurantInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeNameLabel.text = self.business.storeName;
        cell.addressLabel.text = self.business.address;
        cell.descLabel.text = self.business.desc;
        return cell;
    }
    else if (indexPath.section == 2) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OpenHoursCell"];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[self.openHours allKeys] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.openHours objectForKey:[[self.openHours allKeys] objectAtIndex:indexPath.row]];
        return cell;
    }
    else if (indexPath.section == 3) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        cell.textLabel.text = [contacts objectAtIndex:indexPath.row];
        return cell;
    }
    else if (indexPath.section == 4) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
        cell.textLabel.text = [socialNetworks objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
        }
        else if (indexPath.row == 1) {
            NSString *emailString = [NSString stringWithFormat:@"mailto://%@", self.business.email];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailString]];
        }
    }
    else if (indexPath.section == 4) {
        NSURL *url;
        if (indexPath.row == 0) {
            url = [NSURL URLWithString:self.business.facebookPage];
        }
        else if (indexPath.row == 1) {
            url = [NSURL URLWithString:self.business.twitterPage];
        }
        else if (indexPath.row == 2) {
            url = [NSURL URLWithString:self.business.instagramPage];
        }
        else if (indexPath.row == 3) {
            url = [NSURL URLWithString:self.business.pinterestPage];
        }
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) { }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *mapVC = [segue destinationViewController];
    mapVC.restaurant = self.business;
}

@end
