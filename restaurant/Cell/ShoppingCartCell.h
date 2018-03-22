
#import <UIKit/UIKit.h>
#import "ShoppingCartItem.h"

@interface ShoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeAndQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) ShoppingCartItem *shoppingCartItem;

- (IBAction)pressedDecreaseproperty:(id)sender;
- (IBAction)pressedIncreaseQuantity:(id)sender;

@end
