
#import <Foundation/Foundation.h>
#import "DeliveryInputField.h"

@interface DeliveryMethod: NSObject
              
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSMutableArray *inputFields;
              
@end
            
