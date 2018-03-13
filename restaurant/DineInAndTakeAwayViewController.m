
#import "DineInAndTakeAwayViewController.h"
#import "AlertViewController.h"
#import "MapViewController.h"
#import "RestaurantInfoCell.h"
#import "InputCell.h"
#import "ColorHelper.h"
#import "Backendless.h"

@implementation DineInAndTakeAwayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [self.questionsForDelivery count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Order info";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 1.5 * self.tableView.sectionHeaderHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [colorHelper getColorFromHex:@"#FF9300" withAlpha:1];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
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
        cell.titleLabel.text = [self.questionsForDelivery objectAtIndex:indexPath.row];
        cell.inputView.text = [self.questionsForDelivery objectAtIndex:indexPath.row];
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
