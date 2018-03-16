
#import "AlertViewController.h"
#import "ColorHelper.h"

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(void)showErrorAlert:(Fault *)fault target:(UIViewController *)target handler:(void (^)(UIAlertAction *))actionHandler {
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

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target handler:(void(^)(UIAlertAction *))actionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    UIAlertAction *chatsAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:actionHandler];
    [alert addAction:chatsAction];
    [target presentViewController:alert animated:YES completion:nil];
}

+(void)showAddedToCartAlert:(NSString *)title message:(NSString *)message target:(UIViewController *)target handler1:(void(^)(UIAlertAction *))actionHandler1 handler2:(void (^)(UIAlertAction *))actionHandler2 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[colorHelper getColorFromHex:@"#FF9300" withAlpha:1]];
    UIAlertAction *contitueShopping = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:actionHandler1];
    UIAlertAction *goToCart = [UIAlertAction actionWithTitle:@"Go to cart" style:UIAlertActionStyleDefault handler:actionHandler2];
    [alert addAction:contitueShopping];
    [alert addAction:goToCart];
    [target presentViewController:alert animated:YES completion:nil];
}

@end
