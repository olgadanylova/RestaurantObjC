
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
    if ([self.navigationItem.title isEqualToString:TAKE_AWAY]) {
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
    if ([self.navigationItem.title isEqualToString:TAKE_AWAY]) {
        [self takeAwayConfirmation];
    }
    else if ([self.navigationItem.title isEqualToString:DINE_IN]) {
        [self dineInConfirmation];
    }
}

-(void)takeAwayConfirmation {
    BOOL readyToSend = YES;
    NSString *email = @"";
    NSString *emailString = @"Hello, \nYou have ordered a take-away:\n";
    
    for (NSString *field in [emailFields allKeys]) {
        // restaurant
        if ([field isEqualToString:@"Restaurant"]) {
            Business *business = [emailFields valueForKey:field];
            if (business) {
                emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"%@\n(%@)\n", business.storeName, business.address]];
            }
        }
        // full name, email, phone number
        else if (![field isEqualToString:ORDER_NOTES]) {
            NSString *value = [emailFields valueForKey:field];
            if (![value isEqualToString:@""]) {
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
                emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", field, value]];
            }
            else {
                [AlertViewController showErrorAlert:[Fault fault:@"Full name, Phone number and Email are required"] target:self handler:nil];
                readyToSend = NO;
            }
        }
    }
    // shopping cart items
    emailString = [emailString stringByAppendingString:@"\n\nYou've ordered:"];
    NSArray *shoppingCartItems = shoppingCart.shoppingCartItems;
    for (ShoppingCartItem *shoppingCartItem in shoppingCartItems) {
        emailString = [emailString stringByAppendingString:
                       [NSString stringWithFormat:@"\n%@: $%@ x %@ = $%@",
                        shoppingCartItem.menuItem.title, shoppingCartItem.price, shoppingCartItem.quantity, [NSNumber numberWithDouble:([shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue])]]];
    }
    emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"\n--------------------\nTotal: $%@", shoppingCart.totalPrice]];
    
    if (readyToSend) {
        [backendless.messaging sendTextEmail:@"Take-away order" body:emailString to:@[email] response:^(id response) {
            [AlertViewController showAlertWithTitle:@"Take-away order complete" message:@"Order has been send to your email address" target:self handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"unwindToHomeVC" sender:nil];
                [shoppingCart clearCart];
            }];
        } error:^(Fault *fault) {
            [AlertViewController showErrorAlert:fault target:self handler:nil];
        }];
    }
}

-(void)dineInConfirmation {
    BOOL readyToSend = YES;
    NSString *email = @"";
    NSString *emailString = @"Hello, \nYou have reserved a table for Dine-in:\n";
    
    for (NSString *field in [emailFields allKeys]) {
        // restaurant
        if ([field isEqualToString:@"Restaurant"]) {
            Business *business = [emailFields valueForKey:field];
            if (business) {
                emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"%@\n(%@)\n", business.storeName, business.address]];
            }
        }
        // table, email, phone number
        else if (![field isEqualToString:ORDER_NOTES]) {
            NSString *value = [emailFields valueForKey:field];
            if (![value isEqualToString:@""]) {
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
                emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", field, value]];
            }
            else {
                [AlertViewController showErrorAlert:[Fault fault:@"Table, Phone number and Email are required"] target:self handler:nil];
                readyToSend = NO;
                break;
            }
        }
        // order notes
        else {
            NSString *value = [emailFields valueForKey:field];
            if (![value isEqualToString:@""]) {
                emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"\n%@: %@", field, value]];
            }
        }
    }
    // shopping cart items
    emailString = [emailString stringByAppendingString:@"\n\nYou've ordered:"];
    NSArray *shoppingCartItems = shoppingCart.shoppingCartItems;
    for (ShoppingCartItem *shoppingCartItem in shoppingCartItems) {
        emailString = [emailString stringByAppendingString:
                       [NSString stringWithFormat:@"\n%@: $%@ x %@ = $%@",
                        shoppingCartItem.menuItem.title, shoppingCartItem.price, shoppingCartItem.quantity, [NSNumber numberWithDouble:([shoppingCartItem.price doubleValue] * [shoppingCartItem.quantity integerValue])]]];
        
    }
    emailString = [emailString stringByAppendingString:[NSString stringWithFormat:@"\n--------------------\nTotal: $%@", shoppingCart.totalPrice]];
    
    if (readyToSend) {
        [backendless.messaging sendTextEmail:@"Dine-in order" body:emailString to:@[email] response:^(id response) {
            [AlertViewController showAlertWithTitle:@"Dine-in order complete" message:@"Order has been send to your email address" target:self handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"unwindToHomeVC" sender:nil];
                [shoppingCart clearCart];
            }];
        } error:^(Fault *fault) {
            [AlertViewController showErrorAlert:fault target:self handler:nil];
        }];
    }
}

@end
