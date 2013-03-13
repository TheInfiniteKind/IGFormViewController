//
//  IGFormRadioOption.m
//  Programming
//
//  Created by Ishaan Gulrajani on 4/4/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import "IGFormRadioOption.h"

@interface IGFormRadioOption ()
@property (nonatomic, copy, readwrite) id value;
@end

@implementation IGFormRadioOption
-(id)initWithTitle:(NSString *)title value:(id <NSCopying>)value forKey:(NSString *)key {
    
    self = [super initWithTitle:title forKey:key];
    if (self) {
        self.value = value;
    }
    return self;
    
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" - title: %@, value: %@, key: %@", self.title, self.value, self.key];
}

@end
