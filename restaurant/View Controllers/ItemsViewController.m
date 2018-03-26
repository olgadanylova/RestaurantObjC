
#import "ItemsViewController.h"
#import "AlertViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"
#import "PictureHelper.h"
#import "Backendless.h"
#import "MenuItem.h"
#import "Article.h"

@interface ItemsViewController() {
    NSArray *items;
}
@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    if ([self.navigationItem.title isEqualToString:@"Favorites"]) {
        items = [userDefaultsHelper getFavoriteMenuItems];
        [self.tableView reloadData];
    }
    else if ([self.navigationItem.title isEqualToString:@"News"]) {
        [[backendless.data of:[Article class]] find:^(NSArray *articles) {
            items = articles;
            [self.tableView reloadData];
        } error:^(Fault *fault) {
            [AlertViewController showErrorAlert:fault target:self handler:nil];
        }];
        [self.tableView reloadData];
    }
    else {
        DataQueryBuilder *queryBuilder = [DataQueryBuilder new];
        [queryBuilder setWhereClause:[NSString stringWithFormat:@"category.title='%@'", self.navigationItem.title]];
        [[backendless.data of:[MenuItem class]] find:queryBuilder response:^(NSArray *menuItems) {
            items = menuItems;
            [self.tableView reloadData];
        } error:^(Fault *fault) {
            [AlertViewController showErrorAlert:fault target:self handler:nil];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    if ([items.firstObject isKindOfClass:[MenuItem class]]) {
        MenuItem *menuItem = [items objectAtIndex:indexPath.row];
        cell.titleLabel.text = menuItem.title;
        cell.descriptionLabel.text = menuItem.body;
        Picture *picture = menuItem.pictures.firstObject;
        [pictureHelper setSmallImageFromUrl:picture.url forCell:cell];
    }
    else if ([items.firstObject isKindOfClass:[Article class]]) {
        Article *article = [items objectAtIndex:indexPath.row];
        cell.titleLabel.text = article.title;
        cell.descriptionLabel.text = article.body;
        [pictureHelper setSmallImageFromUrl:article.picture.url forCell:cell];
    }    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.navigationItem.title isEqualToString:@"Favorites"]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MenuItem *menuItem = [items objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromFavorites:menuItem];
        items = [userDefaultsHelper getFavoriteMenuItems];
        [self.tableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowItemDetails"]) {
        ItemDetailsViewController *itemDetailsVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        itemDetailsVC.item = [items objectAtIndex:indexPath.row];
    }
}

-(IBAction)unwindToItemsVC:(UIStoryboardSegue *)segue {
}

@end
