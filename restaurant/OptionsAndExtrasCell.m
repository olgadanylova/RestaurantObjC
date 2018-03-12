
#import "OptionsAndExtrasCell.h"
#import "Backendless.h"

@implementation OptionsAndExtrasCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (IBAction)selectedSwitchAction:(id)sender {
    NSIndexPath *indexPath = [((UITableView *)self.superview) indexPathForCell:self];
    if (indexPath.section == 2) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.optionLabel.text];
        StandardOption *standardOption = [self.menuItem.standardOptions filteredArrayUsingPredicate:predicate].firstObject;
        if ([self.selectedSwitch isOn]) {
            standardOption.selected = @1;
        }
        else {
            standardOption.selected = @0;
        }
    }
    else if (indexPath.section == 3) {        
        NSRange range = [self.optionLabel.text rangeOfString:@":"];
        NSString *predicateString = [self.optionLabel.text substringToIndex:range.location];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", predicateString];
        ExtraOption *extraOption = [self.menuItem.extraOptions filteredArrayUsingPredicate:predicate].firstObject;
        if ([self.selectedSwitch isOn]) {
            extraOption.selected = @1;
        }
        else {
            extraOption.selected = @0;
        }
    }
}

@end
