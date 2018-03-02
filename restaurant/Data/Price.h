
#import <Foundation/Foundation.h>

@interface Price: NSObject
              
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *name;
              
@end
            