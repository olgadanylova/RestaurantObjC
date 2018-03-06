
#import "Backendless.h"
#import "Tag.h"
              
@implementation Tag

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.created = [decoder decodeObjectForKey:@"created"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

@end
