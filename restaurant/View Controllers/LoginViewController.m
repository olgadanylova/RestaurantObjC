
#import "LoginViewController.h"
#import "Backendless.h"

#define APPLICATION_ID @"37DA4B50-6A41-A157-FF0D-474B488B2300"
#define API_KEY @"8F51D5C8-18FB-1862-FFD6-1E0ED9A77700"
#define SERVER_URL @"https://api.backendless.com"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [backendless setHostUrl:SERVER_URL];
    [backendless initApp:APPLICATION_ID APIKey:API_KEY];
    
    [self.view bringSubviewToFront:self.enterTheAppButton];
    [self.view bringSubviewToFront:self.loginWithFacebookButton];
    
    self.loginWithFacebookButton.layer.cornerRadius = 20;
    self.loginWithFacebookButton.layer.masksToBounds = YES;
    self.enterTheAppButton.layer.cornerRadius = 20;
    self.enterTheAppButton.layer.masksToBounds = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)pressedEnterTheApp:(id)sender {
    [self performSegueWithIdentifier:@"ShowRestaurant" sender:sender];
}

- (IBAction)pressedLoginWithFacebook:(id)sender {
}

-(IBAction)unwindToLoginVC:(UIStoryboardSegue *)segue {
}

@end
