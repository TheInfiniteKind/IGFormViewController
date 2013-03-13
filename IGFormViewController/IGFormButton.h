//
//  IGFormButton.h
//  Example
//
//  Created by Ishaan Gulrajani on 7/18/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import "IGFormElement.h"

typedef enum _IGFormButtonType {
    IGFormButtonTypeNormal,
    IGFormButtonTypeDisclosure
} IGFormButtonType;

@interface IGFormButton : IGFormElement
@property(nonatomic, strong) void(^action)(void);
@property(nonatomic, strong) NSString *detailTitle;
@property(nonatomic, assign) IGFormButtonType type;

-(id)initWithTitle:(NSString *)aTitle forKey:(NSString *)key detailTitle:(NSString*)aDetailTitle action:(void(^)(void))anAction;

@end
