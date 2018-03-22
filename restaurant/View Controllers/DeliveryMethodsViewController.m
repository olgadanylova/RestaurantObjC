
#import "DeliveryMethodsViewController.h"
#import "AlertViewController.h"
#import "DeliveryViewController.h"
#import "DeliveryMethod.h"
#import "Backendless.h"

#define HOME_DELIVERY @"🚗 Home delivery"
#define TAKE_AWAY @"🥡 Take away"
#define DINE_IN @"🍽 Dine in"

@interface DeliveryMethodsViewController() {
    NSArray *deliveryMethods;
}
@end

@implementation DeliveryMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDeliveryMethods];
    self.tableView.tableFooterView = [UIView new];
}

-(void)setupDeliveryMethods { 
    DeliveryMethod *homeDelivery = [DeliveryMethod new];
    homeDelivery.name = HOME_DELIVERY;
    homeDelivery.details = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit";
    
    DeliveryMethod *takeAway = [DeliveryMethod new];
    takeAway.name = TAKE_AWAY;
    takeAway.details = @"Itaque ab amet quaerat dolor nisi alias cupiditate, adipisci, impedit sequi eaque laborum";
    
    DeliveryMethod *dineIn = [DeliveryMethod new];
    dineIn.name = DINE_IN;
    dineIn.details = @"Itaque ab amet quaerat dolor nisi alias cupiditate, adipisci, impedit sequi eaque laborum";
    
    deliveryMethods = @[homeDelivery, takeAway, dineIn];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [deliveryMethods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMethodCell" forIndexPath:indexPath];
    DeliveryMethod *deliveryMethod = [deliveryMethods objectAtIndex:indexPath.row];
    cell.textLabel.text = deliveryMethod.name;
    cell.detailTextLabel.text = deliveryMethod.details;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowDineInOrTakeAway" sender:cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    [[backendless.data of:[Business class]] findFirst:^(Business *business) {
        DeliveryViewController *deliveryVC = [segue destinationViewController];
        deliveryVC.business = business;
        if ([cell.textLabel.text isEqualToString:HOME_DELIVERY]) {
            deliveryVC.navigationItem.title = HOME_DELIVERY;
            deliveryVC.inputFields = @[@"Full name", @"Email", @"Phone number", @"City", @"Address"];
        }
        else if ([cell.textLabel.text isEqualToString:TAKE_AWAY]) {
            deliveryVC.navigationItem.title = TAKE_AWAY;
            deliveryVC.inputFields = @[@"Full name", @"Email", @"Phone number"];
        }
        else if ([cell.textLabel.text isEqualToString:DINE_IN]) {
            deliveryVC.navigationItem.title = DINE_IN;
            deliveryVC.inputFields = @[@"Table", @"Email", @"Phone number"];
        }
        [deliveryVC.tableView reloadData];
    } error:^(Fault *fault) {
        [AlertViewController showErrorAlert:fault target:self handler:nil];
    }];
}

@end
