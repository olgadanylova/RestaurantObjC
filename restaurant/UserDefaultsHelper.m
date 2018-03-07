
#import "UserDefaultsHelper.h"

#define FAVORITES_KEY @"restaurantFavorites"
#define SHOPPING_CART_KEY @"restaurantShoppingCart"

@implementation UserDefaultsHelper

+(instancetype)sharedInstance {
    static UserDefaultsHelper *sharedHelper;
    @synchronized(self) {
        if (!sharedHelper)
            sharedHelper = [UserDefaultsHelper new];
    }
    return sharedHelper;
}

-(void)addItemToFavorites:(MenuItem *)item {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (!favoriteItems) {
        favoriteItems = [NSMutableArray new];
    }
    [favoriteItems addObject:item];
    data = [NSKeyedArchiver archivedDataWithRootObject:favoriteItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeItemFromFavorites:(MenuItem *)item {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", item.objectId];
    [favoriteItems removeObject:[favoriteItems filteredArrayUsingPredicate:predicate].firstObject];
    data = [NSKeyedArchiver archivedDataWithRootObject:favoriteItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getFavoriteItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (favoriteItems) {
        return favoriteItems;
    }
    return [NSMutableArray new];
}

-(void)addItemToShoppingCart:(MenuItem *)item {
    ShoppingCartItem *shoppingCartItem = [ShoppingCartItem new];
    shoppingCartItem.menuItem = item;
    shoppingCartItem.quantity = @1;
    
    Price *price = item.prices.firstObject;
    NSNumber *p = price.value;
    NSArray *extraOpts = item.extraOptions;
    NSNumber *pp = @0;
    for (ExtraOption *extra in extraOpts) {
        pp = [NSNumber numberWithDouble:([pp doubleValue] + [extra.value doubleValue])];
    }    
    shoppingCartItem.price = [NSNumber numberWithDouble:([p doubleValue] + [pp doubleValue])];
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *cartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (!cartItems) {
        cartItems = [NSMutableArray new];
    }
    [cartItems addObject:shoppingCartItem];
    data = [NSKeyedArchiver archivedDataWithRootObject:cartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeItemFromShoppingCart:(MenuItem *)item {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *cartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"menuItem.objectId == %@", item.objectId];
    [cartItems removeObject:[cartItems filteredArrayUsingPredicate:predicate].firstObject];
    data = [NSKeyedArchiver archivedDataWithRootObject:cartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getShoppingCartItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *cartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (cartItems) {
        return cartItems;
    }
    return [NSMutableArray new];
}

@end
