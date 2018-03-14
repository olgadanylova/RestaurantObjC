
#import "DeliveryViewController.h"
#import "AlertViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"

#define HOME_DELIVERY @"🚗 Home delivery"
#define TAKE_AWAY @"🥡 Take away"
#define DINE_IN @"🍽 Dine in"
#define ORDER_NOTES @"Order notes"

@interface DeliveryViewController() {
    NSMutableDictionary *emailFields;
}
@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.confirmButton.title = [NSString stringWithFormat:@"Confirm: $%@", [self getItemsPrice]];
}

-(NSNumber *)getItemsPrice {
    NSNumber *price = @0;
    NSArray *shoppingCartItems = [userDefaultsHelper getShoppingCartItems];
    for (ShoppingCartItem *item in shoppingCartItems) {
        price = [NSNumber numberWithDouble:([item.price doubleValue] + [price doubleValue] )];
    }
    return price;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    emailFields = [NSMutableDictionary dictionaryWithDictionary:@{@"Restaurant"   :   [NSNull null],
                                                                  @"Table"        :   @"",
                                                                  @"Email"        :   @"",
                                                                  @"Phone number" :   @"",
                                                                  ORDER_NOTES     :   @""}];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.navigationItem.title isEqualToString:HOME_DELIVERY]) {
        return 0;
    }
    if ([self.navigationItem.title isEqualToString:TAKE_AWAY]) {
        return 2;
    }
    else if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.navigationItem.title isEqualToString:HOME_DELIVERY]) {
            return 0;
        }
        return 1;
    }
    else if (section == 1) {
        return [self.inputFields count];
    }
    else if (section == 2) {
        return 1;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Fill the necessary fields";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 1.5 * self.tableView.sectionHeaderHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [colorHelper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RestaurantInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantInfoCell" forIndexPath:indexPath];
        cell.storeNameLabel.text = self.business.storeName;
        cell.addressLabel.text = self.business.address;
        [emailFields setObject:self.business forKey:@"Restaurant"];
        return cell;
    }
    else if (indexPath.section == 1) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
        cell.textField.delegate = self;
        cell.textField.placeholder = [self.inputFields objectAtIndex:indexPath.row];
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    else if (indexPath.section == 2) {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.text = ORDER_NOTES;
        cell.textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
        return cell;
    }
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        MapViewController *mapVC = [segue destinationViewController];
        mapVC.business = self.business;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:ORDER_NOTES]) {
        textView.text = @"";
        textView.textColor = [colorHelper getColorFromHex:@"#2C3E50" withAlpha:1];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = ORDER_NOTES;
        textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
    }
    [textView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField becomeFirstResponder];
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if(textView.text.length == 0){
        textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
        textView.text = ORDER_NOTES;
        [textView resignFirstResponder];
    }
    CGPoint currentOffset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [self.tableView setContentOffset:currentOffset animated:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [emailFields setObject:textView.text forKey:ORDER_NOTES];
}

-(void)textFieldDidChange:(UITextField *)textField {
    [emailFields setObject:textField.text forKey:textField.placeholder];
}

- (IBAction)pressedConfirmButton:(id)sender {
    
    
    // DINE_IN
    if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        for (NSString *field in [emailFields allKeys]) {
            if ([field isEqualToString:@"Restaurant"] && [emailFields valueForKey:field]) {
                NSLog(@"%@ (%@)", ((Business *)[emailFields valueForKey:field]).storeName, ((Business *)[emailFields valueForKey:field]).address);
            }
            else if (![field isEqualToString:ORDER_NOTES]) {
                NSString *value = [emailFields valueForKey:field];
                if (![value isEqualToString:@""]) {
                    NSLog(@"%@ - %@", field, value);
                }
                else {
                    NSLog(@"Field %@ is necessary", field);
                }
            }
            else {
                NSLog(@"%@ - %@", field, [emailFields valueForKey:field]);
            }
        
    }
}
}

@end
