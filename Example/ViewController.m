//
//  ViewController.m
//  Example
//
//  Created by Ishaan Gulrajani on 7/18/12.
//  Copyright (c) 2012 Ishaan Gulrajani. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(void)configure {
    [self addSectionWithTitle:@"Switches" footer:nil];
    [self addSwitch:@"Toggle switch" forKey:@"toggle_switch" enabled:YES];

    [self addSectionWithTitle:@"Buttons" footer:@"The first button does nothing"];
    [self addButton:@"This does nothing"
        detailTitle:nil
               type:IGFormButtonTypeDisclosure
             action:nil];
    [self addButton:@"Do something"
        detailTitle:nil
               type:IGFormButtonTypeNormal
             action:^{
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello!" 
                                                       message:@"You pressed a button."
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil];
        [alert show];
    }];
    
    [self addSectionWithTitle:@"Radio Group" footer:nil];
    [self addRadioOptionWithTitle:@"Option 1" value:@"option-1" key:@"radio_group" selected:YES];
    [self addRadioOptionWithTitle:@"Option 2" value:@"option-1" key:@"radio_group" selected:NO];
    [self addRadioOptionWithTitle:@"Option 3" value:@"option-1" key:@"radio_group" selected:NO];
    
    [self addSectionWithTitle:@"Single-Line Text" footer:nil];
    [self addTextFieldWithTitle:nil forKey:@"text_field_1" placeholder:@"Placeholder text"];
    [self addTextFieldWithTitle:@"Don't Eat Yellow Snow" forKey:@"text_field_2" placeholder:nil];
    [self addTextViewWithTitle:@"Multi-Line Text" forKey:@"text_view" value:@"No man is an island. \n\nExcept Fred Madagascar."];
    
    [self addSectionWithTitle:nil footer:nil];
    
    __weak ViewController *weakSelf = self;
    [self addButton:@"Log Data"
        detailTitle:@"To Console"
               type:IGFormButtonTypeNormal
             action:^{
        NSDictionary *formData = [weakSelf formData];
        NSLog(@"formData: %@", formData);        
    }];
}

@end
