
#import "Backendless.h"
#import "Picture.h"
              
@implementation Picture

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.created = [decoder decodeObjectForKey:@"created"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

@end
            
