
#import <Foundation/Foundation.h>

@interface Picture: NSObject
              
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *objectId;
              
@end
            
