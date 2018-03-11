
#import "ShoppingCartCell.h"
#import "Picture.h"
#import "UserDefaultsHelper.h"

@implementation ShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)pressedDecreaseproperty:(id)sender {
    NSInteger quantity = [self.shoppingCartItem.quantity integerValue];
    if ( quantity >= 2) {
        quantity--;
    }
    self.shoppingCartItem.quantity = [NSNumber numberWithInteger:quantity];
    
    // resave shopping cart item
    [userDefaultsHelper saveShoppingCartItem:self.shoppingCartItem];
    
    self.quantityTextField.text = [NSString stringWithFormat:@"%@", self.shoppingCartItem.quantity];
    [((UITableView *)self.superview) reloadData];
}

- (IBAction)pressedIncreaseQuantity:(id)sender {
    NSInteger quantity = [self.shoppingCartItem.quantity integerValue];
    quantity++;
    self.shoppingCartItem.quantity = [NSNumber numberWithInteger:quantity];
    
    
    // resave shopping cart item
    [userDefaultsHelper saveShoppingCartItem:self.shoppingCartItem];
    
    
    self.quantityTextField.text = [NSString stringWithFormat:@"%@", self.shoppingCartItem.quantity];
    [((UITableView *)self.superview) reloadData];    
}

@end
