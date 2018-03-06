
#import "Backendless.h"
#import "ExtraOption.h"
              
@implementation ExtraOption

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.selected forKey:@"selected"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.created = [decoder decodeObjectForKey:@"created"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.selected = [decoder decodeObjectForKey:@"selected"];
        self.value = [decoder decodeObjectForKey:@"value"];
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

@end
