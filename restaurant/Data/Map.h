
#import <Foundation/Foundation.h>
@class GeoPoint;

@interface Map: NSObject
              
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSNumber *zoomLevel;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) GeoPoint *origin;
@property (nonatomic, strong) NSMutableArray *annotations;
              
@end
            