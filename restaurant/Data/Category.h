
#import <Foundation/Foundation.h>
#import "Picture.h"

@interface Category: NSObject
              
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSNumber *featured;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) Picture *thumb;                        
              
@end
            
