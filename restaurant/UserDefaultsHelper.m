
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

@end
