
#import "ShoppingCartViewController.h"
#import "AlertViewController.h"
#import "DeliveryMethodsViewController.h"
#import "ShoppingCartCell.h"
#import "UserDefaultsHelper.h"
#import "PictureHelper.h"
#import "ShoppingCart.h"
#import "DeliveryMethod.h"
#import "Backendless.h"

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    shoppingCart.totalPrice = @0;
    shoppingCart.shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
    [self proceedToPaymentButtonEnabled];
}

-(void)proceedToPaymentButtonEnabled {
    if ([shoppingCart.shoppingCartItems count] > 0) {
        self.proceedToPaymentButton.enabled = YES;
    }
    else {
        self.proceedToPaymentButton.enabled = NO;
    }
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
    cell.titleLabel.text = shoppingCartItem.menuItem.title;
    cell.descriptionLabel.text = shoppingCartItem.menuItem.body;
    
    Picture *picture = shoppingCartItem.menuItem.pictures.firstObject;
    [pictureHelper setSmallImageFromUrl:picture.url forCell:cell];
    
    Price *price = shoppingCartItem.menuItem.prices.firstObject;
    cell.sizeAndQuantityLabel.text = [NSString stringWithFormat:@"%@%.2f x %@ %@", price.currency, [price.value doubleValue], shoppingCartItem.quantity, price.name];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected = 1)"];
    NSMutableArray *standardOptions = [NSMutableArray arrayWithArray:[shoppingCartItem.menuItem.standardOptions filteredArrayUsingPredicate:predicate]];
    NSMutableArray *extraOptions = [NSMutableArray arrayWithArray:[shoppingCartItem.menuItem.extraOptions filteredArrayUsingPredicate:predicate]];
    NSString *optionsString = @"";
    for (StandardOption *standardOption in standardOptions) {
        optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $0\n", standardOption.name]];
    }
    for (ExtraOption *extraOption in extraOptions) {
        optionsString = [optionsString stringByAppendingString:[NSString stringWithFormat:@"%@: $%.2f\n", extraOption.name, [extraOption.value doubleValue]]];
    }
    if ([optionsString length] > 0) {
        optionsString = [optionsString substringToIndex:[optionsString length] - 1];
    }
    cell.optionsLabel.text = optionsString;
    cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@%.2f", price.currency, [shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue]];
    shoppingCart.totalPrice = [NSNumber numberWithDouble:([shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue] + [shoppingCart.totalPrice doubleValue])];    
    self.proceedToPaymentButton.title = [NSString stringWithFormat:@"Proceed to payment: $%.2f", [shoppingCart.totalPrice doubleValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShoppingCartItem *shoppingCartItem = [shoppingCart.shoppingCartItems objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromShoppingCart:shoppingCartItem.menuItem];
        shoppingCart.totalPrice = @0;
        shoppingCart.shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
        self.proceedToPaymentButton.title = [NSString stringWithFormat:@"Proceed to payment: $%@", shoppingCart.totalPrice];
        [self proceedToPaymentButtonEnabled];
        [self.tableView reloadData];        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[backendless.data of:[DeliveryMethod class]] find:^(NSArray *deliveryMethods) {
        DeliveryMethodsViewController *deliveryMethodsVC = [segue destinationViewController];  
        deliveryMethodsVC.deliveryMethods = deliveryMethods;
        [deliveryMethodsVC.tableView reloadData];
    } error:^(Fault *fault) {
        [AlertViewController showErrorAlert:fault target:self handler:nil];
    }];
}

@end
