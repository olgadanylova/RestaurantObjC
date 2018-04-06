
#import "AlertViewController.h"
#import "ColorHelper.h"
#import "Backendless.h"

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(void)showErrorAlert:(Fault *)fault target:(UIViewController *)target actionHandler:(void (^)(UIAlertAction *))actionHandler {
    NSString *errorTitle = @"Error";
    if (fault.faultCode) {
        errorTitle = [NSString stringWithFormat:@"Error %@", fault.faultCode];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorTitle message:fault.message preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:actionHandler];
    [alert addAction:dismissAction];
    [target presentViewController:alert animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target actionHandler:(void(^)(UIAlertAction *))actionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    UIAlertAction *chatsAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:actionHandler];
    [alert addAction:chatsAction];
    [target presentViewController:alert animated:YES completion:nil];
}

+(void)showAddedToCartAlert:(NSString *)title message:(NSString *)message target:(UIViewController *)target actionHandler1:(void(^)(UIAlertAction *))actionHandler1 actionHandler2:(void (^)(UIAlertAction *))actionHandler2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    UIAlertAction *contitueShopping = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:actionHandler1];
    [alert addAction:contitueShopping];
    UIAlertAction *goToCart = [UIAlertAction actionWithTitle:@"Go to cart" style:UIAlertActionStyleDefault handler:actionHandler2];
    [alert addAction:goToCart];
    [target presentViewController:alert animated:YES completion:nil];
}

+(void)showSendEmailAlert:(NSString *)title body:(NSString *)body target:(UIViewController *)target actionHandler:(void(^)(void))actionHandler {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"Send order confirmation"
                                                                              message: @"Input your email"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"email";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *sendConfirmation) {
        if ([alert.textFields.firstObject.text length] > 0) {
            [backendless.messaging sendTextEmail:title body:body to:@[alert.textFields.firstObject.text] response:^(MessageStatus *status) {
                actionHandler();
            } error:^(Fault *fault) {
                [self showErrorAlert:false target:target actionHandler:nil];
            }];
        }
    }];
    [alert addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [target presentViewController:alert animated:YES completion:nil];
}

@end
