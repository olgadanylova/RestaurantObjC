
#import "ShoppingCartItem.h"

@implementation ShoppingCartItem

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.menuItem forKey:@"menuItem"];
    [encoder encodeObject:self.quantity forKey:@"quantity"];
    [encoder encodeObject:self.price forKey:@"price"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.menuItem = [decoder decodeObjectForKey:@"menuItem"];
        self.quantity = [decoder decodeObjectForKey:@"quantity"];
        self.price = [decoder decodeObjectForKey:@"price"];
    }
    return self;
}

@end
