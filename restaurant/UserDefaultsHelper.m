
#import "UserDefaultsHelper.h"
#import "ShoppingCartItem.h"

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

-(void)addItemToFavorites:(MenuItem *)menuItem {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (!favoriteItems) {
        favoriteItems = [NSMutableArray new];
    }
    [favoriteItems addObject:menuItem];
    data = [NSKeyedArchiver archivedDataWithRootObject:favoriteItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeItemFromFavorites:(MenuItem *)menuItem {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", menuItem.objectId];
    [favoriteItems removeObject:[favoriteItems filteredArrayUsingPredicate:predicate].firstObject];
    data = [NSKeyedArchiver archivedDataWithRootObject:favoriteItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FAVORITES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getFavoriteMenuItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
    NSMutableArray *favoriteItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (favoriteItems) {
        return favoriteItems;
    }
    return [NSMutableArray new];
}

-(void)addItemToShoppingCart:(MenuItem *)menuItem {
    ShoppingCartItem *shoppingCartItem = [ShoppingCartItem new];
    shoppingCartItem.menuItem = menuItem;
    shoppingCartItem.quantity = @1;
    
    Price *menuItemPrice = menuItem.prices.firstObject;
    NSNumber *price = menuItemPrice.value;
    NSArray *extraOptions = menuItem.extraOptions;
    NSNumber *extraPrice = @0;
    
    for (ExtraOption *extra in extraOptions) {
        if ([extra.selected  isEqual: @1]) {
            extraPrice = [NSNumber numberWithDouble:([extraPrice doubleValue] + [extra.value doubleValue])];
        }
    }
    shoppingCartItem.price = [NSNumber numberWithDouble:([price doubleValue] + [extraPrice doubleValue])];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (!shoppingCartItems) {
        shoppingCartItems = [NSMutableArray new];
    }
    [shoppingCartItems addObject:shoppingCartItem];
    data = [NSKeyedArchiver archivedDataWithRootObject:shoppingCartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeItemFromShoppingCart:(MenuItem *)menuItem {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"menuItem.objectId == %@", menuItem.objectId];
    [shoppingCartItems removeObject:[shoppingCartItems filteredArrayUsingPredicate:predicate].firstObject];
    data = [NSKeyedArchiver archivedDataWithRootObject:shoppingCartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getShoppingCartItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (shoppingCartItems) {
        return shoppingCartItems;
    }
    return [NSMutableArray new];
}

@end
