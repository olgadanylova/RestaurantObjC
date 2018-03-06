
#import <Foundation/Foundation.h>

@interface Tag: NSObject
              
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objectId;
              
@end
            
