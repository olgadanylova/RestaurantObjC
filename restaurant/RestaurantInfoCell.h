
#import <UIKit/UIKit.h>

@interface RestaurantInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (IBAction)pressedViewMap:(id)sender;

@end
