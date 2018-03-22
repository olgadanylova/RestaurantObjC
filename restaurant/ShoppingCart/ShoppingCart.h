
#import <Foundation/Foundation.h>
#import "ShoppingCartItem.h"

#define shoppingCart [ShoppingCart sharedInstance]

@interface ShoppingCart : NSObject

@property (strong, nonatomic) NSMutableArray *shoppingCartItems;
@property (strong, nonatomic) NSNumber *totalPrice;

+(instancetype)sharedInstance;
-(void)clearCart;

@end
