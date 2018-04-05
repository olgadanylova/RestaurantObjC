
#import <UIKit/UIKit.h>
#import "Business.h"

@interface DeliveryViewController : UITableViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmButton;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSString *deliveryMethodName;
@property (strong, nonatomic) NSArray *inputFields;

- (IBAction)pressedConfirmButton:(id)sender;

@end
