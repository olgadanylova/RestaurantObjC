
#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import "UserDefaultsHelper.h"
#import "ShoppingCart.h"

@interface ShoppingCartViewController() {
    //NSArray *menuItems;
    ShoppingCart *shoppingCart;
}
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    shoppingCart = [ShoppingCart new];
    shoppingCart.shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shoppingCart.shoppingCartItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartCell" forIndexPath:indexPath];
    ShoppingCartItem *item = [shoppingCart.shoppingCartItems objectAtIndex:indexPath.row];
    Picture *picture = item.menuItem.pictures.firstObject;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.pictureView.image = image;
        });
    });
    
    cell.titleLabel.text = item.menuItem.title;
    cell.descriptionLabel.text = item.menuItem.body;
    
    Price *price = item.menuItem.prices.firstObject;
    cell.sizeAndQuantityLabel.text = [NSString stringWithFormat:@"%@%@ x %@ %@", price.currency, price.value, item.quantity, price.name];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected = 1)"];
        NSMutableArray *standardOptions = [NSMutableArray arrayWithArray:[item.menuItem.standardOptions filteredArrayUsingPredicate:predicate]];
        NSMutableArray *extraOptions = [NSMutableArray arrayWithArray:[item.menuItem.extraOptions filteredArrayUsingPredicate:predicate]];
    
        NSString *optionsString = @"";
    
        for (StandardOption *standardOption in standardOptions) {
            optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $0\n", standardOption.name]];
        }
        for (ExtraOption *extraOption in extraOptions) {
            optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $%@\n", extraOption.name, extraOption.value]];
        }
        if ([optionsString length] > 0) {
            optionsString = [optionsString substringToIndex:[optionsString length] - 1];
        }
    
        cell.optionsLabel.text = optionsString;
        cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@%@", price.currency, item.price];
    
    // *****************************************
    
    
    
    
    //    MenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
    //
    //    Picture *picture = menuItem.pictures.firstObject;
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            cell.pictureView.image = image;
    //        });
    //    });
    //
    //    cell.titleLabel.text = menuItem.title;
    //    cell.descriptionLabel.text = menuItem.body;
    //
    //    Price *price = menuItem.prices.firstObject;
    //    NSNumber *quantity = @1;
    //    NSNumber *pricePerOne = price.value;
    //    cell.sizeAndQuantityLabel.text = [NSString stringWithFormat:@"%@%@ x %@ %@", price.currency, pricePerOne, quantity, price.name];
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected = 1)"];
    //    NSMutableArray *standardOptions = [NSMutableArray arrayWithArray:[menuItem.standardOptions filteredArrayUsingPredicate:predicate]];
    //    NSMutableArray *extraOptions = [NSMutableArray arrayWithArray:[menuItem.extraOptions filteredArrayUsingPredicate:predicate]];
    //
    //    NSString *optionsString = @"";
    //
    //    for (StandardOption *standardOption in standardOptions) {
    //        optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $0\n", standardOption.name]];
    //    }
    //    for (ExtraOption *extraOption in extraOptions) {
    //        optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $%@\n", extraOption.name, extraOption.value]];
    //    }
    //    if ([optionsString length] > 0) {
    //        optionsString = [optionsString substringToIndex:[optionsString length] - 1];
    //    }
    //
    //    cell.optionsLabel.text = optionsString;
    //    cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@%@", price.currency, [NSNumber numberWithDouble:([quantity doubleValue] * [pricePerOne doubleValue])]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        MenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
//        [userDefaultsHelper removeItemFromShoppingCart:menuItem];
//        menuItems = [userDefaultsHelper getShoppingCartItems];
        
        ShoppingCartItem *item = [shoppingCart.shoppingCartItems objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromShoppingCart:item.menuItem];
        shoppingCart.shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
        [self.tableView reloadData];
    }
}

@end
