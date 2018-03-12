
#import "UserDefaultsHelper.h"

#define FAVORITES_KEY @"restaurantFavorites"
#define SHOPPING_CART_KEY @"restaurantShoppingCart"
#define IMAGES_KEY @"restaurantImages"

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
    
    BOOL preventAdd = YES;
    if ([shoppingCartItems count] > 0) {
        for (ShoppingCartItem *item in shoppingCartItems) {
            preventAdd = [self preventFromAdd:menuItem shoppingCartItem:item];
            if (preventAdd) {
                break;
            }
        }
    }
    if ([shoppingCartItems count] == 0 || !preventAdd) {
        [shoppingCartItems addObject:shoppingCartItem];
        data = [NSKeyedArchiver archivedDataWithRootObject:shoppingCartItems];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(BOOL)preventFromAdd:(MenuItem *)menuItem shoppingCartItem:(ShoppingCartItem *)shoppingCartItem {
    BOOL prevent = YES;
    
    // если цены не совпадают - добавляем в корзину
    
    NSNumber *menuItemBasicPrice = ((Price *)menuItem.prices.firstObject).value;
    NSNumber *shoppingCartItemBasicPrice = ((Price *)shoppingCartItem.menuItem.prices.firstObject).value;
    
    if (![menuItemBasicPrice isEqual:shoppingCartItemBasicPrice]) {
        prevent = NO;
        return prevent;
    }
    
    
    else {
        // если цены совпадают - проверяем стандартные опции
        
        NSArray *menuItemStandardOptions = menuItem.standardOptions;
        NSArray *shoppingCartItemStandardOptions = shoppingCartItem.menuItem.standardOptions;
        
        if (([menuItemStandardOptions count] == 0 && [shoppingCartItemStandardOptions count] > 0) ||
            ([menuItemStandardOptions count] > 0 && [shoppingCartItemStandardOptions count] == 0)) {
            prevent = NO;
            return prevent;
        }
        
        else {
            // проверяем стандартные опции на совпадение
            for (StandardOption *menuItemStandardOption in menuItemStandardOptions) {
                NSPredicate *p1 = [NSPredicate predicateWithFormat:@"selected = %@", menuItemStandardOption.selected];
                NSPredicate *p2 = [NSPredicate predicateWithFormat:@"name = %@", menuItemStandardOption.name];
                NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
                NSArray *existingItems = [shoppingCartItemStandardOptions filteredArrayUsingPredicate:predicate];
                if ([existingItems count] == 0) {
                    prevent = NO;
                    return prevent;
                }
            }
            
            // если стандартные опции совпадают - проверяем нестандартные опции
            
            NSArray *menuItemExtraOptions = menuItem.extraOptions;
            NSArray *shoppingCartItemExtraOptions = shoppingCartItem.menuItem.extraOptions;
            
            if (([menuItemExtraOptions count] == 0 && [shoppingCartItemExtraOptions count] > 0) ||
                ([menuItemExtraOptions count] > 0 && [shoppingCartItemExtraOptions count] == 0)) {
                prevent = NO;
                return prevent;
            }
            
            else {
                
                // проверяем нестандартные опции на совпадение
                for (ExtraOption *menuItemExtraOption in menuItemExtraOptions) {
                    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"selected = %@", menuItemExtraOption.selected];
                    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"name = %@", menuItemExtraOption.name];
                    NSPredicate *p3 = [NSPredicate predicateWithFormat:@"value = %@", menuItemExtraOption.value];
                    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2, p3]];
                    NSArray *existingItems = [shoppingCartItemExtraOptions filteredArrayUsingPredicate:predicate];
                    
                    if ([existingItems count] == 0) {
                        prevent = NO;
                        return prevent;
                    }
                }
            }
        }
    }
    return prevent;
}

-(void)removeItemFromShoppingCart:(MenuItem *)menuItem {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    BOOL preventDelete = YES;
    NSMutableArray *itemsToDelete = [NSMutableArray new];
    
    for (ShoppingCartItem *item in shoppingCartItems) {
        preventDelete = [self preventFromDelete:menuItem shoppingCartItem:item];
        if (!preventDelete) {
            [itemsToDelete addObject:item];
            break;
        }
    }
    [shoppingCartItems removeObjectsInArray:itemsToDelete];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:shoppingCartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)preventFromDelete:(MenuItem *)menuItem shoppingCartItem:(ShoppingCartItem *)shoppingCartItem {
    __block BOOL prevent = YES;
    
    BOOL(^checkExtraOptions)(void) = ^{
        // проверяем нестандартные опции
        NSArray *menuItemExtraOptions = menuItem.extraOptions;
        NSArray *shoppingCartItemExtraOptions = shoppingCartItem.menuItem.extraOptions;
        
        if ([menuItemExtraOptions count] == [shoppingCartItemExtraOptions count]) {
            if ([menuItemExtraOptions count] > 0) {
                // проверяем нестандартные опции на совпадение
                for (ExtraOption *menuItemExtraOption in menuItemExtraOptions) {
                    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"selected = %@", menuItemExtraOption.selected];
                    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"name = %@", menuItemExtraOption.name];
                    NSPredicate *p3 = [NSPredicate predicateWithFormat:@"value = %@", menuItemExtraOption.value];
                    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2, p3]];
                    NSArray *existingItems = [shoppingCartItemExtraOptions filteredArrayUsingPredicate:predicate];
                    
                    if ([existingItems count] > 0) {
                        prevent = NO;
                        return prevent;
                    }
                }
            }
            else {
                prevent = NO;
                return prevent;
            }
        }
        return prevent;
    };
    
    // если цены не совпадают - сразу не катит
    
    NSNumber *menuItemBasicPrice = ((Price *)menuItem.prices.firstObject).value;
    NSNumber *shoppingCartItemBasicPrice = ((Price *)shoppingCartItem.menuItem.prices.firstObject).value;
    
    if ([menuItemBasicPrice isEqual:shoppingCartItemBasicPrice]) {
        // проверяем стандартные опции
        
        NSArray *menuItemStandardOptions = menuItem.standardOptions;
        NSArray *shoppingCartItemStandardOptions = shoppingCartItem.menuItem.standardOptions;
        
        if ([menuItemStandardOptions count] == [shoppingCartItemStandardOptions count]) {
            if ([menuItemStandardOptions count] > 0) {
                // проверяем стандартные опции на совпадение
                for (StandardOption *menuItemStandardOption in menuItemStandardOptions) {
                    NSPredicate *p1 = [NSPredicate predicateWithFormat:@"selected = %@", menuItemStandardOption.selected];
                    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"name = %@", menuItemStandardOption.name];
                    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[p1, p2]];
                    NSArray *existingItems = [shoppingCartItemStandardOptions filteredArrayUsingPredicate:predicate];
                    if ([existingItems count] > 0) {
                        checkExtraOptions();
                    }
                }
            }
            else {
                checkExtraOptions();
            }
        }
    }
    return prevent;
}

-(NSMutableArray *)getShoppingCartItems {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (shoppingCartItems) {
        return shoppingCartItems;
    }
    return [NSMutableArray new];
}

-(void)saveShoppingCartItem:(ShoppingCartItem *)shoppingCartItem atIndex:(NSInteger)index {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SHOPPING_CART_KEY];
    NSMutableArray *shoppingCartItems = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    // ищем в shoppingCartItems нужный объект (по индексу)
    ShoppingCartItem *cartItem = [shoppingCartItems objectAtIndex:index];
    cartItem.quantity = shoppingCartItem.quantity;
    
    data = [NSKeyedArchiver archivedDataWithRootObject:shoppingCartItems];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHOPPING_CART_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveImageToUserDefaults:(UIImage *)image withKey:(NSString *)key { 
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:IMAGES_KEY];
    NSMutableDictionary *images = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (!images) {
        images = [NSMutableDictionary new];
    }
    if (![images objectForKey:key]) {
        [images setObject:image forKey:key];
        data = [NSKeyedArchiver archivedDataWithRootObject:images];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:IMAGES_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(UIImage *)getImageFromUserDefaults:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:IMAGES_KEY];
    NSMutableDictionary *images = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    if (images) {
        return [images valueForKey:key];
    }
    return nil;
}

@end
