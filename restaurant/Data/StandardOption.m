
#import "Backendless.h"
#import "StandardOption.h"
              
@implementation StandardOption

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.selected forKey:@"selected"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.updated forKey:@"updated"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.selected = [decoder decodeObjectForKey:@"selected"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.created = [decoder decodeObjectForKey:@"created"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
    }
    return self;
}

@end
