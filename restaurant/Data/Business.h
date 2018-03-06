
#import <Foundation/Foundation.h>
#import "GeoPoint.h"
#import "Picture.h"

@interface Business: NSObject
              
@property (nonatomic, strong) NSString *pinterestPage;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *facebookPage;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *twitterPage;
@property (nonatomic, strong) NSString *instagramPage;
@property (nonatomic, strong) NSMutableArray *welcomeImages;
@property (nonatomic, strong) GeoPoint *officeLocation;
              
@end
            
