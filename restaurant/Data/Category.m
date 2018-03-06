
#import "Backendless.h"
#import "Category.h"
              
@implementation Category

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.featured forKey:@"featured"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.thumb forKey:@"thumb"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.featured = [decoder decodeObjectForKey:@"featured"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.created = [decoder decodeObjectForKey:@"created"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.thumb = [decoder decodeObjectForKey:@"thumb"];
    }
    return self;
}

@end
            
