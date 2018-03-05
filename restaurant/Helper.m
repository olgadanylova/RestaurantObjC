
#import "Helper.h"

#define FAVORITES_KEY @"restaurantFavorites"
#define SHOPPING_CART_KEY @"restaurantShoppingCart"

@implementation Helper

+(instancetype)sharedInstance {
    static Helper *sharedHelper;
    @synchronized(self) {
        if (!sharedHelper)
            sharedHelper = [Helper new];
    }
    return sharedHelper;
}

-(UIColor *)getColorFromHex:(NSString *)hexColor withAlpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexColor];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

-(void)addObjectIdToFavorites:(NSString *)objectId {
    NSMutableArray *favoriteObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITES_KEY] mutableCopy];
    if (!favoriteObjects) {
        favoriteObjects = [NSMutableArray new];
    }
    [favoriteObjects addObject:objectId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteObjects forKey:FAVORITES_KEY];    
}

-(void)removeObjectIdFromFavorites:(NSString *)objectId {
    NSMutableArray *favoriteObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITES_KEY] mutableCopy];
    [favoriteObjects removeObject:objectId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteObjects forKey:FAVORITES_KEY];
}

-(NSMutableArray *)getFavoriteObjectIds {
    NSMutableArray *favorites = [[[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITES_KEY] mutableCopy];
    if (favorites) {
        return favorites;
    }
    return [NSMutableArray new];
}

-(void)addObjectIdToShoppingCart:(NSString *)objectId {
    NSMutableArray *favoriteObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:SHOPPING_CART_KEY] mutableCopy];
    if (!favoriteObjects) {
        favoriteObjects = [NSMutableArray new];
    }
    [favoriteObjects addObject:objectId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteObjects forKey:SHOPPING_CART_KEY];
}

-(void)removeObjectIdFromShoppingCart:(NSString *)objectId {
    NSMutableArray *favoriteObjects = [[[NSUserDefaults standardUserDefaults] arrayForKey:SHOPPING_CART_KEY] mutableCopy];
    [favoriteObjects removeObject:objectId];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteObjects forKey:SHOPPING_CART_KEY];
}

-(NSMutableArray *)getShoppingCartObjectIds {
    NSMutableArray *favorites = [[[NSUserDefaults standardUserDefaults] arrayForKey:SHOPPING_CART_KEY] mutableCopy];
    if (favorites) {
        return favorites;
    }
    return [NSMutableArray new];
}

@end
