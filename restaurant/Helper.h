
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define helper [Helper sharedInstance]

@interface Helper : NSObject

+(instancetype)sharedInstance;
-(UIColor *)getColorFromHex:(NSString *)hexColor withAlpha:(CGFloat)alpha;

@end
