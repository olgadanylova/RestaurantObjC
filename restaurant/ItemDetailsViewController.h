
#import <UIKit/UIKit.h>

@interface ItemDetailsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;
@property (strong, nonatomic) id item;

- (IBAction)pressedAddToCart:(id)sender;
- (IBAction)pressedAddToFavorites:(id)sender;

@end
