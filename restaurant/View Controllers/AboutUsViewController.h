
#import <UIKit/UIKit.h>
#import "Business.h"

@interface AboutUsViewController : UITableViewController

@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSArray *openHours;

@end
