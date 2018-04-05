
#import "DeliveryMethodsViewController.h"
#import "AlertViewController.h"
#import "DeliveryViewController.h"
#import "DeliveryMethod.h"
#import "DeliveryViewController.h"
#import "Backendless.h"

@implementation DeliveryMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deliveryMethods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryMethodCell" forIndexPath:indexPath];
    DeliveryMethod *deliveryMethod = [self.deliveryMethods objectAtIndex:indexPath.row];
    cell.textLabel.text = deliveryMethod.name;
    cell.detailTextLabel.text = deliveryMethod.details;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowDineInOrTakeAway" sender:cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    DeliveryMethod *deliveryMethod = [self.deliveryMethods objectAtIndex:indexPath.row];
    DeliveryViewController *deliveryVC = [segue destinationViewController];
    deliveryVC.navigationItem.title = deliveryMethod.name;
    deliveryVC.deliveryMethodName = deliveryMethod.name;
    deliveryVC.inputFields = deliveryMethod.inputFields;
    [[backendless.data of:[Business class]] findFirst:^(Business *business) {
        deliveryVC.business = business;
        [deliveryVC.tableView reloadData];
    } error:^(Fault *fault) {
        [AlertViewController showErrorAlert:fault target:self handler:nil];
    }];
}

@end
