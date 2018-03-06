
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface MapViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Business *restaurant;

@end
