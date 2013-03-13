//
//  IGFormRadioOption.h
//  Programming
//
//  Created by Ishaan Gulrajani on 4/4/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGFormElement.h"

@interface IGFormRadioOption : IGFormElement {}
@property (nonatomic) BOOL selected;
@property (nonatomic, copy, readonly) id value;
-(id)initWithTitle:(NSString *)title value:(id <NSCopying>)value forKey:(NSString *)key;
@end
