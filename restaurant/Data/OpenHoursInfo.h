
#import <Foundation/Foundation.h>

@interface OpenHoursInfo: NSObject
              
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *openAt;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSDate *closeAt;
              
@end
            