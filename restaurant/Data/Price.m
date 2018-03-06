
#import "Backendless.h"
#import "Price.h"

@implementation Price

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.ownerId forKey:@"ownerId"];
    [encoder encodeObject:self.updated forKey:@"updated"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.created forKey:@"created"];
    [encoder encodeObject:self.currency forKey:@"currency"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.ownerId = [decoder decodeObjectForKey:@"ownerId"];
        self.updated = [decoder decodeObjectForKey:@"updated"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.value = [decoder decodeObjectForKey:@"value"];
        self.created = [decoder decodeObjectForKey:@"created"];
        self.currency = [decoder decodeObjectForKey:@"currency"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end

