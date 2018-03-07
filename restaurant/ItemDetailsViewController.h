
#import <UIKit/UIKit.h>

@interface ItemDetailsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cartButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToFavoritesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToCartButton;
@property (strong, nonatomic) id item;

- (IBAction)pressedAddToCart:(id)sender;
- (IBAction)pressedAddToFavorites:(id)sender;

@end
