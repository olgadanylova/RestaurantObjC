
#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface OptionsAndExtrasCell : UITableViewCell

@property (strong, nonatomic) MenuItem *menuItem;

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectedSwitch;

- (IBAction)selectedSwitchAction:(id)sender;

@end
