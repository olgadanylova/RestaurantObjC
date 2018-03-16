
#import "ShoppingCart.h"
#import "UserDefaultsHelper.h"

@implementation ShoppingCart

+(instancetype)sharedInstance {
    static ShoppingCart *sharedCart;
    @synchronized(self) {
        if (!sharedCart) {
            sharedCart = [ShoppingCart new];
        }
    }
    return sharedCart;
}

-(void)clearCart {
    [userDefaultsHelper removeAllItemsFromShoppingCart];
}

@end
