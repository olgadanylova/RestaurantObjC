
#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import "UserDefaultsHelper.h"
#import "ShoppingCart.h"

@interface ShoppingCartViewController() {
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

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    shoppingCart.totalPrice = @0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shoppingCart.shoppingCartItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartCell" forIndexPath:indexPath];
    ShoppingCartItem *shoppingCartItem = [shoppingCart.shoppingCartItems objectAtIndex:indexPath.row];
    
    cell.quantityTextField.text = [NSString stringWithFormat:@"%@", shoppingCartItem.quantity];
    cell.shoppingCartItem = shoppingCartItem;
    Picture *picture = shoppingCartItem.menuItem.pictures.firstObject;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.pictureView.image = image;
        });
    });
    
    cell.titleLabel.text = shoppingCartItem.menuItem.title;
    cell.descriptionLabel.text = shoppingCartItem.menuItem.body;
    
    Price *price = shoppingCartItem.menuItem.prices.firstObject;
    
    cell.quantityTextField.text = [NSString stringWithFormat:@"%@", shoppingCartItem.quantity];
    cell.sizeAndQuantityLabel.text = [NSString stringWithFormat:@"%@%@ x %@ %@", price.currency, price.value, shoppingCartItem.quantity, price.name];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected = 1)"];
    NSMutableArray *standardOptions = [NSMutableArray arrayWithArray:[shoppingCartItem.menuItem.standardOptions filteredArrayUsingPredicate:predicate]];
    NSMutableArray *extraOptions = [NSMutableArray arrayWithArray:[shoppingCartItem.menuItem.extraOptions filteredArrayUsingPredicate:predicate]];
    
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
    cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@%@", price.currency, [NSNumber numberWithDouble:[shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue]]];
    
    shoppingCart.totalPrice = [NSNumber numberWithDouble:([shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue]) + [shoppingCart.totalPrice doubleValue]];
    self.proceedToPaymentButton.title = [NSString stringWithFormat:@"Proceed to payment: $%@", shoppingCart.totalPrice];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShoppingCartItem *shoppingCartItem = [shoppingCart.shoppingCartItems objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromShoppingCart:shoppingCartItem.menuItem];
        shoppingCart.shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
        [self.tableView reloadData];
    }
}

@end
