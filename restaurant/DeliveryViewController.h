
#import <UIKit/UIKit.h>
#import "Business.h"

@interface DeliveryViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmButton;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSArray *inputFields;

- (IBAction)pressedConfirmButton:(id)sender;

@end
