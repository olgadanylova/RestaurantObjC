
#import <UIKit/UIKit.h>
#import "Business.h"

@interface DineInAndTakeAwayViewController : UITableViewController

@property (strong, nonatomic) Business *restaurant;
@property (strong, nonatomic) NSArray *questionsForDelivery;

@end
