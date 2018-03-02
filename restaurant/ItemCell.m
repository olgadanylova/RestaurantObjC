
#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];    
    self.titleLabel.text = @"";
    self.descriptionLabel.text = @"";
}

@end
