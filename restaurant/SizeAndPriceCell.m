
#import "SizeAndPriceCell.h"

@implementation SizeAndPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;    
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end
