
#import "Helper.h"

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

@end
