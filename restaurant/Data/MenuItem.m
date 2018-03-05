
#import "Backendless.h"
#import "MenuItem.h"
              
@implementation MenuItem

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.objectId forKey:@"objectId"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        self.objectId = [coder decodeObjectForKey:@"objectId"];
    }
    return self;
}

@end
            
