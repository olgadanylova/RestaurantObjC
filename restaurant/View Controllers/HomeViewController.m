
#import "HomeViewController.h"
#import "ItemsViewController.h"
#import "Helper.h"
#import "Backendless.h"
#import "MenuItem.h"
#import "Category.h"
#import "Article.h"

#define FAVORITES @"★ Favorites"
#define SHOPPING_CART @"🛒 Shopping Cart"
#define CONTACT_US @"✆ Contact us"
#define MAP @"📍 Map"
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
        
    }];
    
    favoritesAndCart = @[FAVORITES, SHOPPING_CART];
    news = @[ARTICLES];
    other = @[CONTACT_US, MAP, LOGOUT];
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
    if (section == 2) {
        return @"News";
    }
    if (section == 3) {
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
    view.tintColor = [helper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [favoritesAndCart objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = [news objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 3) {
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
            // shopping cart
        }
    }
    else if (indexPath.section == 1 || indexPath.section == 2) {
        [self performSegueWithIdentifier:@"ShowItems" sender:cell];
    }
    else if (indexPath.section == 3 && [cell.textLabel.text isEqualToString:LOGOUT]) {
        [self performSegueWithIdentifier:@"unwindToLoginVC" sender:cell];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        UINavigationController *navController = [segue destinationViewController];
        ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
        itemsVC.navigationItem.title = @"Favorites";
    }
    
    else if (indexPath.section == 1) {
        NSString *categoryName = [cell.textLabel.text substringFromIndex:2];
        DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
        [queryBuilder setWhereClause:[NSString stringWithFormat:@"category.title='%@'", categoryName]];
        UINavigationController *navController = [segue destinationViewController];
        ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
        itemsVC.navigationItem.title = categoryName;
        [[backendless.data of:[MenuItem class]] find:queryBuilder response:^(NSArray *menuItems) {
            itemsVC.items = menuItems;
            [itemsVC.tableView reloadData];
        } error:^(Fault *fault) {
            
        }];
    }
    
    else if (indexPath.section == 2) {
        [[backendless.data of:[Article class]] find:^(NSArray *articles) {
            UINavigationController *navController = [segue destinationViewController];
            ItemsViewController *itemsVC = (ItemsViewController *)[navController topViewController];
            itemsVC.navigationItem.title = @"News";
            itemsVC.items = articles;
            [itemsVC.tableView reloadData];
        } error:^(Fault *fault) {
            
        }];
    }
}

@end
