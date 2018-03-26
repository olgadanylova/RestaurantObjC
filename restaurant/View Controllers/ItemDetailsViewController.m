
#import "ItemDetailsViewController.h"
#import "AlertViewController.h"
#import "ItemInfoCell.h"
#import "OptionsAndExtrasCell.h"
#import "SizeAndPriceCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"
#import "PictureHelper.h"
#import "Article.h"
#import "MenuItem.h"

#define ADD_TO_FAV @"Add to favorites"
#define REMOVE_FROM_FAV @"Remove from favorites"

@interface ItemDetailsViewController() {
    MenuItem *menuItem;
    NSArray *menuItemOptions;
    NSArray *menuItemExtras;
    NSArray *menuItemPrices;
    NSIndexPath *cuttentPriceIndexPath;    
    Article *article;
}
@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.tableFooterView = [UIView new];
    if ([self.item isKindOfClass:[MenuItem class]]) {
        menuItem = self.item;
        menuItemOptions = menuItem.standardOptions;
        menuItemExtras = menuItem.extraOptions;
        menuItemPrices = menuItem.prices;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", menuItem.objectId];
        if ([[userDefaultsHelper getFavoriteMenuItems] filteredArrayUsingPredicate:predicate].firstObject) {
            self.addToFavoritesButton.title = REMOVE_FROM_FAV;
        }
    }
    else if ([self.item isKindOfClass:[Article class]]) {
        article = self.item;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.item isKindOfClass:[MenuItem class]]) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else {
        self.cartButton.enabled = NO;
        self.cartButton.tintColor = [UIColor clearColor];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

-(void)viewDidLayoutSubviews {
    [self selectPriceAutomatically];
}

-(void)selectPriceAutomatically {
    if (!cuttentPriceIndexPath) {
        cuttentPriceIndexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    }
    [self.table selectRowAtIndexPath:cuttentPriceIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.table didSelectRowAtIndexPath:cuttentPriceIndexPath];
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
        [self.table setAllowsSelection:YES];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"Options";
    }
    else if (section == 3) {
        return @"Extras";
    }
    else if (section == 4) {
        return @"Size and prices";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0 && section != 1) {
        return 1.5 * self.table.sectionHeaderHeight;
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
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        if ([self.item isKindOfClass:[MenuItem class]]) {
            Picture *picture = menuItem.pictures.firstObject;
            [pictureHelper setImagefFromUrl:picture.url forCell:cell];
        }
        else if ([self.item isKindOfClass:[Article class]]) {
            [pictureHelper setImagefFromUrl:article.picture.url forCell:cell];
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
        cell.optionLabel.text = [NSString stringWithFormat:@"%@: $%@", extra.name, extra.value];
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
        SizeAndPriceCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cuttentPriceIndexPath = indexPath;
    }
    else {
        [self selectPriceAutomatically];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        SizeAndPriceCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (IBAction)pressedAddToCart:(id)sender {
    @try {
        Price *selectedPrice = [menuItem.prices objectAtIndex:cuttentPriceIndexPath.row];
        menuItem.prices = [NSMutableArray arrayWithObject:selectedPrice];
        [userDefaultsHelper addItemToShoppingCart:menuItem];
        menuItem.prices = ((MenuItem *)self.item).prices;
        [AlertViewController showAddedToCartAlert:@"Shopping cart" message:@"Menu item added to cart" target:self handler1:^(UIAlertAction *continueShopping) {
            [self performSegueWithIdentifier:@"unwindToItemsVC" sender:nil];
        } handler2:^(UIAlertAction *goToCart) {
            self.addToCartButton.title = @"Already added to cart";
            [self.addToCartButton setEnabled:NO];
            [self.table setUserInteractionEnabled:NO];
            [self performSegueWithIdentifier:@"ShowCart" sender:nil];
        }];
    }
    @catch (NSException *exception) {
        Fault *fault = [Fault fault:exception.name detail:exception.reason];
        [AlertViewController showErrorAlert:fault target:self handler:nil];
    }    
}

- (IBAction)pressedAddToFavorites:(id)sender {
    if ([self.addToFavoritesButton.title isEqualToString:ADD_TO_FAV]) {
        self.addToFavoritesButton.title = REMOVE_FROM_FAV;
        [userDefaultsHelper addItemToFavorites:menuItem];
    }
    else {
        self.addToFavoritesButton.title = ADD_TO_FAV;
        [userDefaultsHelper removeItemFromFavorites:menuItem];
    }
}

- (IBAction)pressedGoToCart:(id)sender {
    [self performSegueWithIdentifier:@"ShowCart" sender:nil];
}

@end
