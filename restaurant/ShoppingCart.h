
#import <Foundation/Foundation.h>
#import "ShoppingCartItem.h"

@interface ShoppingCart : NSObject

@property (strong, nonatomic) NSMutableArray *shoppingCartItems;
@property (strong, nonatomic) NSNumber *totalPrice;

@end
