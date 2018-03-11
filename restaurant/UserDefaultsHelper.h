
#import <Foundation/Foundation.h>
#import "MenuItem.h"
#import "ShoppingCartItem.h"

#define userDefaultsHelper [UserDefaultsHelper sharedInstance]

@interface UserDefaultsHelper : NSObject

+(instancetype)sharedInstance;

-(void)addItemToFavorites:(MenuItem *)menuItem;
-(void)removeItemFromFavorites:(MenuItem *)menuItem;
-(NSMutableArray *)getFavoriteMenuItems;

-(void)addItemToShoppingCart:(MenuItem *)menuItem;
-(void)removeItemFromShoppingCart:(MenuItem *)menuItem;
-(NSMutableArray *)getShoppingCartItems;

-(void)saveShoppingCartItem:(ShoppingCartItem *)shoppingCartItem;

@end
