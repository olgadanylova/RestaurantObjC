
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define pictureHelper [PictureHelper sharedInstance]

@interface PictureHelper : NSObject

+(instancetype)sharedInstance;
-(void)setImageFromUrl:(NSString *)url forCell:(UITableViewCell *)cell;
-(void)setSmallImageFromUrl:(NSString *)url forCell:(UITableViewCell *)cell;

@end
