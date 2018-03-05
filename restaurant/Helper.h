
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define helper [Helper sharedInstance]

@interface Helper : NSObject

+(instancetype)sharedInstance;

-(UIColor *)getColorFromHex:(NSString *)hexColor withAlpha:(CGFloat)alpha;
-(void)addObjectIdToFavorites:(NSString *)objectId;
-(void)removeObjectIdFromFavorites:(NSString *)objectId;
-(NSMutableArray *)getFavoriteObjectIds;
-(void)addObjectIdToShoppingCart:(NSString *)objectId;
-(void)removeObjectIdFromShoppingCart:(NSString *)objectId;
-(NSMutableArray *)getShoppingCartObjectIds;

@end
