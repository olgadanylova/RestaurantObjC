
#import "ItemDetailsViewController.h"
#import "ItemInfoCell.h"
#import "OptionsAndExtrasCell.h"
#import "SizeAndPriceCell.h"
#import "ColorHelper.h"
#import "UserDefaultsHelper.h"
#import "Article.h"
#import "MenuItem.h"

#define ADD_TO_FAV @"Add to favorites"
#define REMOVE_FROM_FAV @"Remove from favorites"


@interface ItemDetailsViewController() {
    MenuItem *menuItem;
    NSArray *menuItemOptions;
    NSArray *menuItemExtras;
    NSArray *menuItemPrices;
    
    Article *article;
}
@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.item isKindOfClass:[MenuItem class]]) {
        menuItem = self.item;
        menuItemOptions = menuItem.standardOptions;
        menuItemExtras = menuItem.extraOptions;
        menuItemPrices = menuItem.prices;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", menuItem.objectId];
        if ([[userDefaultsHelper getFavoriteItems] filteredArrayUsingPredicate:predicate].firstObject) {
            self.favoritesButton.title = REMOVE_FROM_FAV;
        }
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else if ([self.item isKindOfClass:[Article class]]) {
        article = self.item;
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.item isKindOfClass:[MenuItem class]]) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [self.table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.table didSelectRowAtIndexPath:indexPath];
    }
    else {
        self.cartButton.enabled = NO;
        self.cartButton.tintColor = [UIColor clearColor];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.item isKindOfClass:[MenuItem class]]) {
        return 5;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 ||section == 1) {
        return 1;
    }
    else if (section == 2) {
        if ([self.item isKindOfClass:[MenuItem class]]) {
            return [menuItemOptions count];
        }
    }
    else if (section == 3) {
        if ([self.item isKindOfClass:[MenuItem class]]) {
            return [menuItemExtras count];
        }
    }
    else if (section == 4) {
        if ([self.item isKindOfClass:[MenuItem class]]) {
            return [menuItemPrices count];
        }
        [self.tableView setAllowsSelection:YES];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"Options";
    }
    if (section == 3) {
        return @"Extras";
    }
    if (section == 4) {
        return @"Size and prices";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0 && section != 1) {
        return 1.5 * self.tableView.sectionHeaderHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [colorHelper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ItemImageCell"];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waitingImage.png"]];
        if ([self.item isKindOfClass:[MenuItem class]]) {
            Picture *picture = menuItem.pictures.firstObject;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
                });
            });
        }
        else if ([self.item isKindOfClass:[Article class]]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:article.picture.url]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
                });
            });
        }
        return cell;
    }
    
    else if (indexPath.section == 1) {
        ItemInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemInfoCell" forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.item isKindOfClass:[MenuItem class]]) {
            cell.titleLabel.text = menuItem.title;
            
            NSString *tagsString = @"• ";
            for (Tag *tag in menuItem.tags) {
                tagsString = [tagsString stringByAppendingString:[NSString stringWithFormat:@"%@, ", tag.name]];
            }
            if ([tagsString length] > 0) {
                tagsString = [tagsString substringToIndex:[tagsString length] - 2];
            }
            cell.tagsLabel.text = tagsString;
            cell.bodyLabel.text = menuItem.body;
        }
        else if ([self.item isKindOfClass:[Article class]]) {
            cell.titleLabel.text = article.title;
            cell.tagsLabel.hidden = YES;
            cell.bodyLabel.text = article.body;
        }
        return cell;
    }
    
    else if (indexPath.section == 2) {
        OptionsAndExtrasCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuItem = menuItem;
        StandardOption *option = [menuItemOptions objectAtIndex:indexPath.row];
        cell.optionLabel.text = option.name;
        [cell.selectedSwitch setOn:[option.selected boolValue]];
        return cell;
    }
    
    else if (indexPath.section == 3) {
        OptionsAndExtrasCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExtraCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuItem = menuItem;
        ExtraOption *extra = [menuItemExtras objectAtIndex:indexPath.row];
        cell.optionLabel.text = extra.name;
        [cell.selectedSwitch setOn: [extra.selected boolValue]];
        return cell;
    }
    
    else if (indexPath.section == 4) {
        SizeAndPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SizeAndPriceCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Price *price = [menuItemPrices objectAtIndex:indexPath.row];
        cell.sizeAndPriceLabel.text = [NSString stringWithFormat:@"%@: $%@", price.name, price.value];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (IBAction)pressedAddToCart:(id)sender {
    NSLog(@"Menu item: %@", menuItem);
}

- (IBAction)pressedAddToFavorites:(id)sender {
    if ([self.favoritesButton.title isEqualToString:ADD_TO_FAV]) {
        self.favoritesButton.title = REMOVE_FROM_FAV;
        [userDefaultsHelper addItemToFavorites:menuItem];
    }
    else {
        self.favoritesButton.title = ADD_TO_FAV;
        [userDefaultsHelper removeItemFromFavorites:menuItem];
    }
}

@end
