
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *enterTheAppButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithFacebookButton;

- (IBAction)pressedEnterTheApp:(id)sender;
- (IBAction)pressedLoginWithFacebook:(id)sender;

@end
