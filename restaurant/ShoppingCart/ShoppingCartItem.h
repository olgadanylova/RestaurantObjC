
#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface ShoppingCartItem : NSObject

@property (strong, nonatomic) MenuItem *menuItem;
@property (strong, nonatomic) NSNumber *quantity;
@property (strong, nonatomic) NSNumber *price;

@end


