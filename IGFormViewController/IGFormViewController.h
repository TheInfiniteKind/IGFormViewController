//
//  FormViewController.h
//  FormViewController
//
//  Created by Ishaan Gulrajani on 3/28/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGFormElement.h"
#import "IGFormSection.h"
#import "IGFormTextField.h"
#import "IGFormTextView.h"
#import "IGFormRadioOption.h"
#import "IGFormSwitch.h"
#import "IGFormButton.h"

@interface IGFormViewController : UITableViewController <UIPopoverControllerDelegate, UITextFieldDelegate> {
	UINavigationController *popoverNavigationController;
	NSMutableArray *elements;
}
@property(weak, nonatomic,readonly) UINavigationController *popoverNavigationController;

// Always init with this method
-(id)initWithDefaults;

// Subclasses should override this method to configure fields, etc...
-(void)configure;

// return the current values
-(NSDictionary *)formData;

// return elements matching key
- (NSArray *)elementsForKey:(NSString *)key;

// Subclasses should override this method to determine whether the data is valid.
// If valid, return nil. If not, return an error message.
-(NSString *)validateData:(NSDictionary *)formData;

// Subclasses should override this method to save the given data. You can assume that the data is valid according to validateData:.
-(void)saveData:(NSDictionary *)formData;

// Creates a new section in the form with the given title and footer
-(void)addSectionWithTitle:(NSString *)title footer:(NSString *)footer;

// Single line text field with placeholder & default value
-(void)addTextFieldWithTitle:(NSString *)title forKey:(NSString *)key placeholder:(NSString *)placeholder;

// Multi-line text entry
-(void)addTextViewWithTitle:(NSString *)fieldName forKey:(NSString *)key value:(NSString *)value;

// Adds a radio option (a row with a checkbox to the right). Call this multiple times with the same key for each set of options.
-(void)addRadioOptionWithTitle:(NSString *)title value:(id <NSCopying>)value key:(NSString *)key selected:(BOOL)selected;

// Adds a toggle switch and sets the default value
-(void)addSwitch:(NSString *)title forKey:(NSString *)key enabled:(BOOL)enabled;

// Adds a button that executes the given block when pressed
-(void)addButton:(NSString *)title forKey:(NSString *)key detailTitle:(NSString *)detailTitle type:(IGFormButtonType)type action:(void (^)(void))action;

@end
