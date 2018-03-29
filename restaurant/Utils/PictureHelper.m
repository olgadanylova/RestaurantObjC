
#import "PictureHelper.h"
#import "UserDefaultsHelper.h"
#import "ItemCell.h"
#import "ShoppingCartCell.h"

@implementation PictureHelper

+(instancetype)sharedInstance {
    static PictureHelper *sharedHelper;
    @synchronized(self) {
        if (!sharedHelper)
            sharedHelper = [PictureHelper new];
    }
    return sharedHelper;
}

-(void)setImageFromUrl:(NSString *)url forCell:(UITableViewCell *)cell {
    if ([userDefaultsHelper getImageFromUserDefaults:url]) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[userDefaultsHelper getImageFromUserDefaults:url]];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            [userDefaultsHelper saveImageToUserDefaults:image withKey:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
            });
        });
    }
}

-(void)setSmallImageFromUrl:(NSString *)url forCell:(UITableViewCell *)cell {
    if ([cell isKindOfClass:[ItemCell class]]) {
        if ([userDefaultsHelper getImageFromUserDefaults:url]) {
            ((ItemCell *)cell).pictureView.image = [userDefaultsHelper getImageFromUserDefaults:url];
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                [userDefaultsHelper saveImageToUserDefaults:image withKey:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ((ItemCell *)cell).pictureView.image = image;
                });
            });
        }
    }    
    else if ([cell isKindOfClass:[ShoppingCartCell class]]) {
        if ([userDefaultsHelper getImageFromUserDefaults:url]) {
            ((ShoppingCartCell *)cell).pictureView.image = [userDefaultsHelper getImageFromUserDefaults:url];
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                [userDefaultsHelper saveImageToUserDefaults:image withKey:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ((ShoppingCartCell *)cell).pictureView.image = image;
                });
            });
        }
    }
}

@end
