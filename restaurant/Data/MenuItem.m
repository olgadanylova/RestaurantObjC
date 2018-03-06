
#import "Backendless.h"
#import "MenuItem.h"

@implementation MenuItem

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.updated forKey:@"updated"];
    [coder encodeObject:self.created forKey:@"created"];
    [coder encodeObject:self.body forKey:@"body"];
    [coder encodeObject:self.isFeatured forKey:@"isFeatured"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.objectId forKey:@"objectId"];
    [coder encodeObject:self.ownerId forKey:@"ownerId"];
    [coder encodeObject:self.category forKey:@"category"];
    [coder encodeObject:self.extraOptions forKey:@"extraOptions"];
    [coder encodeObject:self.tags forKey:@"tags"];
    [coder encodeObject:self.prices forKey:@"prices"];
    [coder encodeObject:self.pictures forKey:@"pictures"];
    [coder encodeObject:self.thumb forKey:@"thumb"];
    [coder encodeObject:self.standardOptions forKey:@"standardOptions"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        self.updated = [coder decodeObjectForKey:@"updated"];
        self.created = [coder decodeObjectForKey:@"created"];
        self.body = [coder decodeObjectForKey:@"body"];
        self.isFeatured = [coder decodeObjectForKey:@"isFeatured"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.objectId = [coder decodeObjectForKey:@"objectId"];
        self.ownerId = [coder decodeObjectForKey:@"ownerId"];
        self.category = [coder decodeObjectForKey:@"category"];
        self.extraOptions = [coder decodeObjectForKey:@"extraOptions"];
        self.tags = [coder decodeObjectForKey:@"tags"];
        self.prices = [coder decodeObjectForKey:@"prices"];
        self.pictures = [coder decodeObjectForKey:@"pictures"];
        self.thumb = [coder decodeObjectForKey:@"thumb"];
        self.standardOptions = [coder decodeObjectForKey:@"standardOptions"];
    }
    return self;
}

@end
