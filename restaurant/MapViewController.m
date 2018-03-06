
#import "MapViewController.h"
#import "MapPin.h"

@interface MapViewController() {
    CLLocationDistance regionRadius;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setShowsScale:YES];
    [self.mapView setShowsCompass:YES];
    
    regionRadius = 250;
    GeoPoint *officeLocation = self.restaurant.officeLocation;
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:[officeLocation.latitude doubleValue] longitude:[officeLocation.longitude doubleValue]];
    [self centerMapOnLocation:initialLocation];
    
    CLLocationCoordinate2D restaurantCoordinates = CLLocationCoordinate2DMake([officeLocation.latitude doubleValue], [officeLocation.longitude doubleValue]);
    MapPin *mapPin = [[MapPin alloc] initWithCoordinates:restaurantCoordinates placeName:self.restaurant.storeName description:self.restaurant.address];
    [self.mapView addAnnotation:mapPin];
}

-(void)centerMapOnLocation:(CLLocation *)location {
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius);
    [self.mapView setRegion:coordinateRegion animated:YES];
}

@end
