
#import <Foundation/Foundation.h>
#import "MenuItem.h"

#define userDefaultsHelper [UserDefaultsHelper sharedInstance]

@interface UserDefaultsHelper : NSObject

+(instancetype)sharedInstance;

-(void)addItemToFavorites:(MenuItem *)item;
-(void)removeItemFromFavorites:(MenuItem *)item;
-(NSMutableArray *)getFavoriteItems;

//-(void)addItemToShoppingCart:(MenuItem *)item;
//-(void)removeItemFromShoppingCart:(NSString *)item;
//-(NSMutableArray *)getShoppingCartItems;

@end
