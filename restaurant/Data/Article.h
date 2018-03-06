
#import <Foundation/Foundation.h>
#import "Picture.h"

@interface Article: NSObject
              
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) Picture *picture;
@property (nonatomic, strong) Picture *thumb;                       
              
@end
            
