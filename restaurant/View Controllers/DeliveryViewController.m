
#import "DeliveryViewController.h"
#import "AlertViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import "UserDefaultsHelper.h"
#import "ColorHelper.h"
#import "ShoppingCart.h"
#import "Backendless.h"
#import "DeliveryInputField.h"
#import "MenuItem.h"

@interface DeliveryViewController() {
    BOOL readyToSendEmail;
    NSArray *singleLineInputFields;
    NSArray *multiLineInputFields;
    NSMutableDictionary *singleLineInputFieldsDictionary;
    NSMutableDictionary *multiLineInputFieldsDictionary;
}
@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.confirmButton.title = [NSString stringWithFormat:@"Confirm: $%.2f", [shoppingCart.totalPrice doubleValue]];
    singleLineInputFields = [NSArray arrayWithArray:[self.inputFields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(multilineInput = 0)"]]];
    multiLineInputFields = [NSArray arrayWithArray:[self.inputFields filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(multilineInput = 1)"]]];
    
    singleLineInputFieldsDictionary = [NSMutableDictionary new];
    for (DeliveryInputField *inputField in singleLineInputFields) {
        [singleLineInputFieldsDictionary setObject:[NSNull null] forKey:inputField.title];
    }
    multiLineInputFieldsDictionary = [NSMutableDictionary new];
    for (DeliveryInputField *inputField in multiLineInputFields) {
        [multiLineInputFieldsDictionary setObject:[NSNull null] forKey:inputField.title];
    }
    readyToSendEmail = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    if ([singleLineInputFields count] > 0 && [multiLineInputFields count] > 0) {
    //        return 3;
    //    }
    //    else if (([singleLineInputFields count] > 0 && [multiLineInputFields count] == 0) ||
    //             ([singleLineInputFields count] == 0 && [multiLineInputFields count] > 0)) {
    //        return 2;
    //    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [singleLineInputFields count];
    }
    else if (section == 2) {
        return [multiLineInputFields count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    }
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RestaurantInfoCell *cell = [tableView dequeueReusableCellWithIdentifier: @"RestaurantInfoCell"];
        cell.storeNameLabel.text = self.business.storeName;
        cell.addressLabel.text = self.business.address;
        return cell;
    }
    else if (indexPath.section == 1) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
        cell.textField.placeholder = ((DeliveryInputField *)[singleLineInputFields objectAtIndex:indexPath.row]).title;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    else if (indexPath.section == 2) {
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.text = ((DeliveryInputField *)[multiLineInputFields objectAtIndex:indexPath.row]).title;
        cell.textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
        return cell;
    }
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField becomeFirstResponder];
    return NO;
}

-(void)textFieldDidChange:(UITextField *)textField {
    [singleLineInputFieldsDictionary setObject:textField.text forKey:textField.placeholder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textView.superview.superview];
    if ([textView.text isEqualToString:((DeliveryInputField *)[multiLineInputFields objectAtIndex:indexPath.row]).title]) {
        textView.text = @"";
        textView.textColor = [colorHelper getColorFromHex:@"#2C3E50" withAlpha:1];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textView.superview.superview];
        textView.text = ((DeliveryInputField *)[multiLineInputFields objectAtIndex:indexPath.row]).title;
        textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textView.superview.superview];
    if(textView.text.length == 0) {
        textView.text = ((DeliveryInputField *)[multiLineInputFields objectAtIndex:indexPath.row]).title;
        textView.textColor = [colorHelper getColorFromHex:@"#C7C7CD" withAlpha:1];
        [textView resignFirstResponder];
    }
    else {
        [multiLineInputFieldsDictionary setObject:textView.text forKey:((DeliveryInputField *)[multiLineInputFields objectAtIndex:indexPath.row]).title];
    }
    CGPoint currentOffset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [self.tableView setContentOffset:currentOffset animated:NO];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: 0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        MapViewController *mapVC = [segue destinationViewController];
        mapVC.business = self.business;
    }
}

- (IBAction)pressedConfirmButton:(id)sender {
    NSString *emailText = [NSString stringWithFormat:@"%@\n%@\n%@\n\nYou have ordered a %@\n\nOrdered items:",
                           self.business.storeName, self.business.address, self.business.phoneNumber, self.deliveryMethodName];
    
    // Shopping cart items
    for (ShoppingCartItem *item in shoppingCart.shoppingCartItems) {
        NSString *itemOptions = @"";
        for (StandardOption *option in item.menuItem.standardOptions) {
            if ([option.selected isEqual:@1]) {
                itemOptions = [itemOptions stringByAppendingString:[NSString stringWithFormat:@"%@, ", option.name]];
            }
        }
        [emailText substringToIndex:[emailText length] - 2];
        for (ExtraOption *option in item.menuItem.extraOptions) {
            if ([option.selected isEqual:@1]) {
                itemOptions = [itemOptions stringByAppendingString:[NSString stringWithFormat:@"%@, ", option.name]];
            }
        }
        itemOptions = [itemOptions substringToIndex:[itemOptions length] - 2];
        emailText = [emailText stringByAppendingString:[NSString stringWithFormat:@"\n• %@(%@) = $%.2f ", item.menuItem.title, itemOptions, [item.price doubleValue]]];
    }
    emailText = [emailText stringByAppendingString:[NSString stringWithFormat:@"\n----------\nTotal:$%.2f\n\nCustomers' info:", [shoppingCart.totalPrice doubleValue]]];
    
    for (NSString *field in [singleLineInputFieldsDictionary allKeys]) {
        NSString *value = [singleLineInputFieldsDictionary valueForKey:field];
        if ([value isKindOfClass:[NSNull class]] || [value isEqualToString:@""]) {
            Fault *fault = [Fault fault:[NSString stringWithFormat:@"Field '%@' is required", field]];
            [AlertViewController showErrorAlert:fault target:self handler:nil];
            readyToSendEmail = NO;
            break;
        }
        else {
            emailText = [emailText stringByAppendingString:[NSString stringWithFormat:@"\n• %@: %@", field, [singleLineInputFieldsDictionary valueForKey:field]]];
            readyToSendEmail = YES;
        }
    }
    
    for (NSString *field in [multiLineInputFieldsDictionary allKeys]) {
        NSString *value = [multiLineInputFieldsDictionary valueForKey:field];
        if (![value isKindOfClass:[NSNull class]]) {
            emailText = [emailText stringByAppendingString:[NSString stringWithFormat:@"\n• %@: %@", field, [multiLineInputFieldsDictionary valueForKey:field]]];
        }
    }
    
    if (readyToSendEmail) {
        [AlertViewController showSendEmailAlert:@"Order confirmation" body:emailText target:self handler:^{
            [AlertViewController showAlertWithTitle:@"Order confirmation" message:@"Confirmation send" target:self handler:^(UIAlertAction *action) {
                [shoppingCart clearCart];
                [self performSegueWithIdentifier:@"unwindToHomeVC" sender:nil];
            }];
        }];
    }
}

@end
