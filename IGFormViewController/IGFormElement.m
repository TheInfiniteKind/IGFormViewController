//
//  IGFormSection.m
//  CramberryPad
//
//  Created by Ishaan Gulrajani on 4/3/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import "IGFormElement.h"

@interface IGFormElement ()
@property(nonatomic, copy, readwrite) NSString *title;
@property(nonatomic, copy, readwrite) NSString *key;
@end

@implementation IGFormElement

-(id)initWithTitle:(NSString *)title forKey:(NSString *)key {
    NSParameterAssert(key != nil);
    
	if((self = [super init])) {
		self.title = title;
        self.key = key;
	}
	return self;
}

-(UIResponder *)control {return nil;}
-(void)setControl:(UIResponder *)newControl {}

@end
