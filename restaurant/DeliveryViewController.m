
#import "DeliveryViewController.h"
#import "AlertViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"
#import "ShoppingCart.h"
#import "MenuItem.h"
#import "Backendless.h"

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
    self.confirmButton.title = [NSString stringWithFormat:@"Confirm: $%@", shoppingCart.totalPrice];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationItem.title isEqualToString:HOME_DELIVERY]) {
        emailFields = [NSMutableDictionary dictionaryWithDictionary:@{@"Restaurant"     :   self.business,
                                                                      @"Full name"      :   @"",
                                                                      @"Email"          :   @"",
                                                                      @"Phone number"   :   @"",
                                                                      @"City"           :   @"",
                                                                      @"Address"        :   @""}];
    }
    else if ([self.navigationItem.title isEqualToString:TAKE_AWAY]) {
        emailFields = [NSMutableDictionary dictionaryWithDictionary:@{@"Restaurant"     :   self.business,
                                                                      @"Full name"      :   @"",
                                                                      @"Email"          :   @"",
                                                                      @"Phone number"   :   @""}];
    }
    else if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        emailFields = [NSMutableDictionary dictionaryWithDictionary:@{@"Restaurant"   :   self.business,
                                                                      @"Table"        :   @"",
                                                                      @"Email"        :   @"",
                                                                      @"Phone number" :   @"",
                                                                      ORDER_NOTES     :   @""}];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.navigationItem.title isEqualToString:HOME_DELIVERY] ||
        [self.navigationItem.title isEqualToString:TAKE_AWAY]) {
        return 2;
    }
    else if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
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
        return @"Order details";
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
        cell.textField.placeholder = [self.inputFields objectAtIndex:indexPath.row];
        if ([cell.textField.placeholder isEqualToString:@"Phone number"]) {
            [cell.textField setTextContentType:UITextContentTypeTelephoneNumber];
            [cell.textField setKeyboardType:UIKeyboardTypePhonePad];
        }
        else if ([cell.textField.placeholder isEqualToString:@"Email"]) {
            [cell.textField setTextContentType:UITextContentTypeEmailAddress];
            [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
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
    if ([self.navigationItem.title isEqualToString:HOME_DELIVERY]) {
        [self sendEmailConfirmationWithTitle:@"Home delivery" message:@"Hello, \nYou have ordered a home delivery in "];
    }
    else if ([self.navigationItem.title isEqualToString:TAKE_AWAY]) {
        [self sendEmailConfirmationWithTitle:@"Take-away order" message:@"Hello, \nYou have ordered a take-away in "];
    }
    else if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        [self sendEmailConfirmationWithTitle:@"Dine-in order" message:@"Hello, \nYou have reserved a table for dine-in in "];
    }
}

-(void)sendEmailConfirmationWithTitle:(NSString *)title message:(NSString *)message {
    BOOL readyToSend = YES;
    NSString *email = @"";
    NSString *emailMessage = message;
    
    Business *business = [emailFields valueForKey:@"Restaurant"];
    if (business) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"%@\n(%@)\n\nOrder info:", business.storeName, business.address]];
    }
    
    for (NSString *field in [emailFields allKeys]) {
        // full name, table, email, phone number, city, address
        if (![field isEqualToString:ORDER_NOTES] && ![field isEqualToString:@"Restaurant"]) {
            NSString *value = [emailFields valueForKey:field];
            if (![value isEqualToString:@""]) {
                if ([field isEqualToString:@"Full name"]) {
                    if ([value length] == 0) {
                        [AlertViewController showErrorAlert:[Fault fault:@"Full name is required"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                }
                if ([field isEqualToString:@"Table"]) {
                    if ([value length] < 3) {
                        [AlertViewController showErrorAlert:[Fault fault:@"Table field should be at least 3 characters"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                }
                if ([field isEqualToString:@"Email"]) {
                    if ([value length] < 5) {
                        [AlertViewController showErrorAlert:[Fault fault:@"Email field should be at least 5 characters"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                    else {
                        email = value;
                    }
                }
                if ([field isEqualToString:@"Phone number"]) {
                    if ([value length] < 9 || [value length] > 12) {
                        [AlertViewController showErrorAlert:[Fault fault:@"Phone number should have from 9 to 12 digits"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                }
                if ([field isEqualToString:@"City"]) {
                    if ([value length] == 0) {
                        [AlertViewController showErrorAlert:[Fault fault:@"City is requred"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                }
                if ([field isEqualToString:@"Address"]) {
                    if ([value length] == 0) {
                        [AlertViewController showErrorAlert:[Fault fault:@"Address is requred"] target:self handler:nil];
                        readyToSend = NO;
                        break;
                    }
                }
            }
            else {
                if ([emailFields valueForKey:@"City"] && [emailFields valueForKey:@"Address"]) {
                    [AlertViewController showErrorAlert:[Fault fault:@"Full name, Phone number, Email, City and Address are required"] target:self handler:nil];
                    readyToSend = NO;
                    break;
                }
                else if ([emailFields valueForKey:@"Table"]) {
                    [AlertViewController showErrorAlert:[Fault fault:@"Table, Phone number and Email are required"] target:self handler:nil];
                    readyToSend = NO;
                    break;
                }
                else if ([emailFields valueForKey:@"Full name"]) {
                    [AlertViewController showErrorAlert:[Fault fault:@"Full name, Phone number and Email are required"] target:self handler:nil];
                    readyToSend = NO;
                    break;
                }
            }
        }
    }
    
    if ([emailFields valueForKey:@"Full name"]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", @"Full name", [emailFields valueForKey:@"Full name"]]];
    }
    if ([emailFields valueForKey:@"Phone number"]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", @"Phone number", [emailFields valueForKey:@"Phone number"]]];
    }
    if ([emailFields valueForKey:@"City"]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", @"City", [emailFields valueForKey:@"City"]]];
    }
    if ([emailFields valueForKey:@"Address"]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", @"Address", [emailFields valueForKey:@"Address"]]];
    }
    if ([emailFields valueForKey:@"Table"]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", @"Table", [emailFields valueForKey:@"Table"]]];
    }
    if ([emailFields valueForKey:ORDER_NOTES] &&
        ![[emailFields valueForKey:ORDER_NOTES] isEqualToString:@""]) {
        emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", ORDER_NOTES, [emailFields valueForKey:ORDER_NOTES]]];
    }
    
    // shopping cart items
    emailMessage = [emailMessage stringByAppendingString:@"\n\nYou've ordered:"];
    NSArray *shoppingCartItems = shoppingCart.shoppingCartItems;
    for (ShoppingCartItem *shoppingCartItem in shoppingCartItems) {
        emailMessage = [emailMessage stringByAppendingString:
                       [NSString stringWithFormat:@"\n%@: $%@ x %@ = $%@",
                        shoppingCartItem.menuItem.title, shoppingCartItem.price, shoppingCartItem.quantity, [NSNumber numberWithDouble:([shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue])]]];
        
    }
    emailMessage = [emailMessage stringByAppendingString:[NSString stringWithFormat:@"\n--------------------\nTotal: $%@", shoppingCart.totalPrice]];
    
    if (readyToSend) {
        [backendless.messaging sendTextEmail:title body:emailMessage to:@[email] response:^(id response) {
            [AlertViewController showAlertWithTitle:@"Order complete" message:@"Order has been send to your email address" target:self handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"unwindToHomeVC" sender:nil];
                [shoppingCart clearCart];
            }];
        } error:^(Fault *fault) {
            [AlertViewController showErrorAlert:fault target:self handler:nil];
        }];
    }
}

@end
