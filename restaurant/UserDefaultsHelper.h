
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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
-(void)removeAllItemsFromShoppingCart;
-(NSMutableArray *)getShoppingCartItems;
-(void)saveShoppingCartItem:(ShoppingCartItem *)shoppingCartItem atIndex:(NSInteger)index;

-(void)saveImageToUserDefaults:(UIImage *)image withKey:(NSString *)key;
-(UIImage *)getImageFromUserDefaults:(NSString *)key;

@end
