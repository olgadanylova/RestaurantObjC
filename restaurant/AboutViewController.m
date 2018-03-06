
#import "AboutViewController.h"
#import "ColorHelper.h"
#import "RestaurantInfoCell.h"

#define CALL_US @"✆ Call us"
#define SEND_EMAIL @"✉️ Send email"

@interface AboutViewController() {
    NSArray *contactArray;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contactArray = @[CALL_US, SEND_EMAIL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return [self.openHours count];
    }
    else if (section == 2) {
        return 2;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Open Hours";
    }
    if (section == 2) {
        return @"Get in touch";
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
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
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeNameLabel.text = self.business.storeName;
        cell.addressLabel.text = self.business.address;
        cell.descLabel.text = self.business.desc;
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OpenHoursCell"];
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[self.openHours allKeys] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.openHours objectForKey:[[self.openHours allKeys] objectAtIndex:indexPath.row]];
        return cell;
    }
    else if (indexPath.section == 2) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        cell.textLabel.text = [contactArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
        }
        else if (indexPath.row == 1) {
            NSString *emailString = [NSString stringWithFormat:@"mailto://%@", self.business.email];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailString]];
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
