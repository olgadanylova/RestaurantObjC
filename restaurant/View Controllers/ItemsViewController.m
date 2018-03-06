
#import "ItemsViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemCell.h"
#import "MenuItem.h"
#import "Article.h"
#import "Backendless.h"
#import "ColorHelper.h"
#import "UserDefaultsHelper.h"

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    if ([self.navigationItem.title isEqualToString:@"Favorites"]) {
        [self getFavoriteItems];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if ([self.items.firstObject isKindOfClass:[MenuItem class]]) {
        MenuItem *menuItem = [self.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = menuItem.title;
        cell.descriptionLabel.text = menuItem.body;
        Picture *picture = menuItem.pictures.firstObject;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.pictureView.image = image;
            });
        });
    }
    
    else if ([self.items.firstObject isKindOfClass:[Article class]]) {
        Article *article = [self.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = article.title;
        cell.descriptionLabel.text = article.body;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:article.picture.url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.pictureView.image = image;
            });
        });
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
        MenuItem *menuItem = [self.items objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromFavorites:menuItem];
        [self getFavoriteItems];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowItemDetails"]) {
        ItemDetailsViewController *itemDetailsVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        itemDetailsVC.item = [self.items objectAtIndex:indexPath.row];
    }
}

-(void)getFavoriteItems {
    NSArray *favoriteItems = [userDefaultsHelper getFavoriteItems];
    self.items = favoriteItems;
    [self.tableView reloadData];
}

@end
