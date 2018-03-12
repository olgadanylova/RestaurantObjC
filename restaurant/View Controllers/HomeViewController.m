
#import "HomeViewController.h"
#import "AlertViewController.h"
#import "ItemsViewController.h"
#import "AboutUsViewController.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"
#import "Backendless.h"
#import "MenuItem.h"
#import "Article.h"
#import "Category.h"
#import "Business.h"
#import "OpenHoursInfo.h"

#define FAVORITES @"★ Favorites"
#define SHOPPING_CART @"🛒 Shopping Cart"
#define ABOUT @"ℹ About us"
#define LOGOUT @"← Logout"
#define ARTICLES @"📰 Articles"

@interface HomeViewController() {
    NSArray *favoritesAndCart;
    NSMutableArray *categories;
    NSArray *news;
    NSArray *other;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [[backendless.data of:[Category class]] find:^(NSArray *categotyArray) {
        categories = [NSMutableArray new];
        for (Category *category in categotyArray) {
            [categories addObject: [NSString stringWithFormat:@"• %@", category.title]];
        }
        [self.tableView reloadData];
    } error:^(Fault *fault) {
        [AlertViewController showErrorAlert:fault target:self handler:nil];
    }];
    favoritesAndCart = @[FAVORITES, SHOPPING_CART];
    news = @[ARTICLES];
    other = @[ABOUT, LOGOUT];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [favoritesAndCart count];
    }
    else if (section == 1) {
        return [categories count];
    }
    else if (section == 2) {
        return [news count];
    }
    else if (section == 3) {
        return [other count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Categories";
    }
    else if (section == 2) {
        return @"News";
    }
    else if (section == 3) {
        return @"Other";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 1.5 * self.tableView.sectionHeaderHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [colorHelper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = [favoritesAndCart objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2) {
        cell.textLabel.text = [news objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 3) {
        cell.textLabel.text = [other objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"ShowItems" sender:cell];
        }
        else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"ShowCart" sender:cell];
        }
    }
    else if (indexPath.section == 1 || indexPath.section == 2) {
        [self performSegueWithIdentifier:@"ShowItems" sender:cell];
    }
    else if (indexPath.section == 3 && [cell.textLabel.text isEqualToString:LOGOUT]) {
        [self performSegueWithIdentifier:@"unwindToLoginVC" sender:cell];
    }
    else if (indexPath.section == 3 && [cell.textLabel.text isEqualToString:ABOUT]) {
        [self performSegueWithIdentifier:@"ShowAbout" sender:cell];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        UINavigationController *navController = [segue destinationViewController];
        if ([segue.identifier isEqualToString:@"ShowItems"]) {
            ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
            itemsVC.navigationItem.title = @"Favorites";
        }
    }
    else if (indexPath.section == 1) {
        UINavigationController *navController = [segue destinationViewController];
        ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
        itemsVC.navigationItem.title = [cell.textLabel.text substringFromIndex:2];
    }
    else if (indexPath.section == 2) {
        UINavigationController *navController = [segue destinationViewController];
        ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
        itemsVC.navigationItem.title = @"News";
    }
    else if (indexPath.section == 3 && [segue.identifier isEqualToString:@"ShowAbout"]) {
        [[backendless.data of:[Business class]] findFirst:^(Business *business) {
            [[backendless.data of:[OpenHoursInfo class]] find:^(NSArray *openHours) {
                UINavigationController *navController = [segue destinationViewController];
                AboutUsViewController *aboutUsVC = (AboutUsViewController *)[navController topViewController];
                aboutUsVC.business = business;
                aboutUsVC.openHours = [self convertOpenHoursArrayToDictionary:openHours];
                [aboutUsVC.tableView reloadData];
            } error:^(Fault *f) {
            }];
        } error:^(Fault *f) {
        }];
    }
}

-(NSDictionary *)convertOpenHoursArrayToDictionary:(NSArray *)openHoursArray {
    NSMutableDictionary *openHoursDictionary = [NSMutableDictionary new];    
    for (OpenHoursInfo *openHoursInfo in openHoursArray) {
        NSNumber *day = openHoursInfo.day;
        NSDate *openAt = openHoursInfo.openAt;
        NSDate *closeAt = openHoursInfo.closeAt;
        if (![openHoursDictionary objectForKey:day]) {
            NSString *openClose = [NSString stringWithFormat:@"%@ - %@", [self stringFromDate:openAt], [self stringFromDate:closeAt]];
            [openHoursDictionary setObject:openClose forKey:[self stringFromWeekday:[day integerValue]]];
        }
        else {
            NSString *openClose = [openHoursDictionary objectForKey:[self stringFromWeekday:[day integerValue]]];
            openClose = [openClose stringByAppendingString:[NSString stringWithFormat:@" / %@ - %@", [self stringFromDate:openAt], [self stringFromDate:closeAt]]];
            [openHoursDictionary setObject:openClose forKey:day];
        }
    }
    return openHoursDictionary;
}

-(NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}

- (NSString *)stringFromWeekday:(NSInteger)weekday {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter.shortWeekdaySymbols[weekday];
}

@end
