//
//  IGFormSection.h
//  CramberryPad
//
//  Created by Ishaan Gulrajani on 4/3/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGFormViewController.h"

@interface IGFormElement : NSObject {}
@property(nonatomic, copy, readonly) NSString *title;
@property(nonatomic, copy, readonly) NSString *key;

-(id)initWithTitle:(NSString *)title forKey:(NSString *)key;
@end
