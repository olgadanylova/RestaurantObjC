
#import <UIKit/UIKit.h>
#import "Business.h"
#import "OpenHoursInfo.h"

@interface AboutUsViewController : UITableViewController

@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSDictionary *openHours;

@end
