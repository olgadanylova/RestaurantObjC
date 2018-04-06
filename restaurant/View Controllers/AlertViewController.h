
#import <UIKit/UIKit.h>
#import "Responder.h"

@interface AlertViewController : UIViewController

+(void)showErrorAlert:(Fault *)fault target:(UIViewController *)target actionHandler:(void(^)(UIAlertAction *))actionHandler;
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target actionHandler:(void(^)(UIAlertAction *))actionHandler;
+(void)showAddedToCartAlert:(NSString *)title message:(NSString *)message target:(UIViewController *)target actionHandler1:(void(^)(UIAlertAction *))actionHandler1 actionHandler2:(void(^)(UIAlertAction *))actionHandler2;
+(void)showSendEmailAlert:(NSString *)title body:(NSString *)body target:(UIViewController *)target actionHandler:(void(^)(void))actionHandler;

@end
