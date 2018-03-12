
#import "DineInAndTakeAwayViewController.h"
#import "AlertViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "InputCell.h"
#import "Backendless.h"

@interface DineInAndTakeAwayViewController() {
    NSArray *questions;
}
@end

@implementation DineInAndTakeAwayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.navigationItem.title isEqualToString:@"🥡 Take away"]) {
        questions = @[@"Full name", @"Email", @"Phone number"];
    }
    else if ([self.navigationItem.title isEqualToString:@"🍽 Dine in"]) {
        questions = @[@"Table", @"Email", @"Phone number", @"Order notes"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [questions count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RestaurantInfoCell *cell = (RestaurantInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeNameLabel.text = self.restaurant.storeName;
        cell.addressLabel.text = self.restaurant.address;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
        cell.titleLabel.text = [questions objectAtIndex:indexPath.row];
        cell.inputField.placeholder = [questions objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMap"]) {
        MapViewController *mapVC = [segue destinationViewController];
        mapVC.restaurant = self.restaurant;
    }
}


@end
