
#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface OptionsAndExtrasCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectedSwitch;
@property (strong, nonatomic) MenuItem *menuItem;

- (IBAction)selectedSwitchAction:(id)sender;

@end
