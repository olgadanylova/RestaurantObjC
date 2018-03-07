
#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import "UserDefaultsHelper.h"

@interface ShoppingCartViewController() {
    NSArray *menuItems;
}
@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuItems = [userDefaultsHelper getShoppingCartItems];
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
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartCell" forIndexPath:indexPath];
    MenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
    
    Picture *picture = menuItem.pictures.firstObject;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.pictureView.image = image;
        });
    });
    
    cell.titleLabel.text = menuItem.title;
    cell.descriptionLabel.text = menuItem.body;
    
    Price *price = menuItem.prices.firstObject;
    NSNumber *quantity = @1;
    NSNumber *pricePerOne = price.value;
    cell.sizeAndQuantityLabel.text = [NSString stringWithFormat:@"%@%@ x %@ %@", price.currency, pricePerOne, quantity, price.name];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(selected = 1)"];
    NSMutableArray *standardOptions = [NSMutableArray arrayWithArray:[menuItem.standardOptions filteredArrayUsingPredicate:predicate]];
    NSMutableArray *extraOptions = [NSMutableArray arrayWithArray:[menuItem.extraOptions filteredArrayUsingPredicate:predicate]];    
    
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
    cell.totalLabel.text = [NSString stringWithFormat:@"Total: %@%@", price.currency, [NSNumber numberWithDouble:([quantity doubleValue] * [pricePerOne doubleValue])]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MenuItem *menuItem = [menuItems objectAtIndex:indexPath.row];
        [userDefaultsHelper removeItemFromShoppingCart:menuItem];
        menuItems = [userDefaultsHelper getShoppingCartItems];
        [self.tableView reloadData];
    }
}

@end
