
#import <Foundation/Foundation.h>
#import "Category.h"
#import "ExtraOption.h"
#import "Tag.h"
#import "Price.h"
#import "Picture.h"
#import "StandardOption.h"

@interface MenuItem: NSObject
              
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSNumber *isFeatured;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) Category *category;
@property (nonatomic, strong) NSMutableArray *extraOptions;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *prices;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) Picture *thumb;                        
@property (nonatomic, strong) NSMutableArray *standardOptions;

- (void) encodeWithCoder : (NSCoder *)encode ;
- (id) initWithCoder : (NSCoder *)decode;
              
@end
            
