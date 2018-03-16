
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
    self.enterTheAppButton.layer.cornerRadius = 20;
    self.enterTheAppButton.layer.masksToBounds = YES;
}

-(IBAction)unwindToLoginVC:(UIStoryboardSegue *)segue {
}

- (IBAction)pressedEnterTheApp:(id)sender {
    [self performSegueWithIdentifier:@"ShowRestaurant" sender:sender];
}

@end
