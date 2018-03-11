
#import "SplitViewController.h"
#import "ItemsViewController.h"

@implementation SplitViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    });
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[ItemsViewController class]]) {
        return YES;
    }
    return NO;
}

@end
