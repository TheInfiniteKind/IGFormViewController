//
//  FormViewController.m
//  FormViewController
//
//  Created by Ishaan Gulrajani on 3/28/10.
//  Copyright 2010 Ishaan Gulrajani. All rights reserved.
//

#import "IGFormViewController.h"
#import "IGFormElement.h"
#import "IGFormSection.h"
#import "IGFormTextField.h"
#import "IGFormTextView.h"
#import "IGFormRadioOption.h"
#import "IGFormSwitch.h"
#import "IGFormButton.h"

@interface IGFormViewController ()

// Private methods. Don't use these!
-(NSInteger)tableViewHeight;
-(NSDictionary *)formData;
-(void)saveAndExit;
-(void)saveButtonPressed;
-(IGFormElement *)elementAtIndexPath:(NSIndexPath *)indexPath;

@end


@implementation IGFormViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithDefaults {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		elements = [[NSMutableArray alloc] init];
	}
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configure]; // let the subclass set up form data
	
	self.tableView.showsVerticalScrollIndicator = YES;
    self.clearsSelectionOnViewWillAppear = YES;
    
	// if this is taller than possible (e.g. landscape with keyboard), the popover will do its own scrolling, which is badly broken
	NSInteger minHeight = ([self tableViewHeight]<282 ? [self tableViewHeight] : 282);
	
    self.contentSizeForViewInPopover = CGSizeMake(320, minHeight);		
		
    if([self.navigationController.viewControllers objectAtIndex:0]==self) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(saveButtonPressed)];
        self.navigationItem.rightBarButtonItem = doneButton;
    } else {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                    target:self
                                                                                    action:@selector(saveButtonPressed)];
        self.navigationItem.rightBarButtonItem = saveButton;
    }
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
	if([elements count] >= 2) {
		NSObject *element = [elements objectAtIndex:1];
	
		if([element isKindOfClass:[IGFormTextField class]]) {
			[[(IGFormTextField *)element textField] becomeFirstResponder];
		} else if([element isKindOfClass:[IGFormTextView class]]) {
			[[(IGFormTextView *)element textView] becomeFirstResponder];
		}
	}
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

#pragma mark -
#pragma mark Popover support

-(UINavigationController *)popoverNavigationController {
	if(popoverNavigationController==nil)
		popoverNavigationController = [[UINavigationController alloc] initWithRootViewController:self];
	
	return popoverNavigationController;
}

#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad) || (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark API & support

-(void)configure {
	// nop; should be overriden
}

-(NSString *)validateData:(NSDictionary *)formData {
	return nil; // should be overriden
}

-(void)saveData:(NSDictionary *)formData {
	// nop; should be overriden
}

#pragma mark -
#pragma mark Sections

-(void)addDefaultSectionIfNeeded {
	if([elements count]==0)
		[self addSectionWithTitle:nil];
}

-(void)addSectionWithTitle:(NSString *)aTitle {
	IGFormSection *section = [[IGFormSection alloc] initWithTitle:aTitle forKey:@""];
	[elements addObject:section];
}

-(void)addSectionWithTitle:(NSString *)aTitle footer:(NSString *)footer {
	IGFormSection *section = [[IGFormSection alloc] initWithTitle:aTitle forKey:@""];
    section.footer = footer;
	[elements addObject:section];
}

#pragma mark -
#pragma mark Adding text inputs

-(void)addTextFieldWithTitle:(NSString *)title forKey:(NSString *)key placeholder:(NSString *)placeholder {
    
	[self addDefaultSectionIfNeeded];
	
	IGFormTextField *textField = [[IGFormTextField alloc] initWithTitle:title forKey:key];
	textField.textField.delegate = self;
	
	[elements addObject:textField];
	
	textField.textField.placeholder = placeholder;
}

-(void)addTextViewWithTitle:(NSString *)title forKey:(NSString *)key value:(NSString *)value {
	if(![[elements lastObject] isKindOfClass:[IGFormSection class]]) {
		[self addSectionWithTitle:title];
	}
	
	IGFormTextView *textView = [[IGFormTextView alloc] initWithTitle:title forKey:key];
	textView.textView.text = value;
	[elements addObject:textView];
}

#pragma mark -
#pragma mark Adding other form elements

-(void)addRadioOptionWithTitle:(NSString *)title value:(id <NSCopying>)value key:(NSString *)key selected:(BOOL)selected {
	[self addDefaultSectionIfNeeded];
	
	IGFormRadioOption *radioOption = [[IGFormRadioOption alloc] initWithTitle:title value:value forKey:key];
    [radioOption setSelected:selected];
    
	[elements addObject:radioOption];
}

-(void)addSwitch:(NSString *)title forKey:(NSString *)key enabled:(BOOL)enabled {
    [self addDefaultSectionIfNeeded];
    
    IGFormSwitch *formSwitch = [[IGFormSwitch alloc] initWithTitle:title forKey:key enabled:enabled];
    [elements addObject:formSwitch];
}

-(void)addButton:(NSString *)title detailTitle:(NSString *)detailTitle type:(IGFormButtonType)type action:(void (^)(void))action {
    [self addDefaultSectionIfNeeded];
    
    IGFormButton *button = [[IGFormButton alloc] initWithTitle:title
                                                   detailTitle:detailTitle
                                                        action:action];
    button.type = type;
    [elements addObject:button];
}

#pragma mark -
#pragma mark Custom methods


-(NSInteger)tableViewHeight {
	[self.tableView layoutIfNeeded];
	return (NSInteger)([self.tableView contentSize].height) - 62;
}

-(IGFormElement *)elementAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger currentSection = -1;
	NSInteger currentRow = -1;
	for(IGFormElement *element in elements) {
		if([element isKindOfClass:[IGFormSection class]])
			currentSection++;
		else if([indexPath section]==currentSection) {
			currentRow++;
			if(currentRow == [indexPath row]) {
				return element;
			}
		}
	}
	return nil;
}

#pragma mark -
#pragma mark Saving

-(NSDictionary *)formData {
	NSMutableDictionary *formData = [[NSMutableDictionary alloc] init];
	
	for(NSObject *element in elements) {
		if([element isKindOfClass:[IGFormTextField class]]) {
			IGFormTextField *textField = (IGFormTextField *)element;
			
			NSString *value = (textField.textField.text ? textField.textField.text : @""); // replace nil with @""
			[formData setObject:value forKey:textField.key];
		} else if([element isKindOfClass:[IGFormRadioOption class]]) {
			IGFormRadioOption *radioOption = (IGFormRadioOption *)element;
			
			if(radioOption.value) {
				[formData setObject:radioOption.value forKey:radioOption.key];
			}
		} else if([element isKindOfClass:[IGFormTextView class]]) {
			IGFormTextView *textView = (IGFormTextView *)element;
			
			NSString *value = (textView.textView.text ? textView.textView.text : @""); // replace nil with @""
			[formData setObject:value forKey:textView.key];
		} else if([element isKindOfClass:[IGFormSwitch class]]) {
            IGFormSwitch *formSwitch = (IGFormSwitch *)element;
            
            [formData setObject:[NSNumber numberWithBool:formSwitch.switchControl.on] forKey:formSwitch.key];
        }
	}
	
	NSDictionary *immFormData = [formData copy];

	return immFormData;
}

-(void)saveAndExit {
	[self saveData:[self formData]];
	
	// IGPopoverController might not exist (iPhone-only project), so check if it does first
	Class popoverControllerClass = NSClassFromString(@"IGPopoverController");
	if(popoverControllerClass && popoverNavigationController) {
		[[popoverControllerClass performSelector:@selector(currentPopoverController)] dismissPopoverAnimated:YES];
	} else {
        if(![self.navigationController popViewControllerAnimated:YES])
            [self dismissModalViewControllerAnimated:YES];
	}
}

-(void)saveButtonPressed {
	NSDictionary *formData = [self formData];

	NSString *validationResult = [self validateData:formData];
	if(validationResult==nil) {
		[self saveAndExit];
	} else {
		// validation failed, display error message
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:validationResult 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"OK",nil];
		[alert show];
	}

}

#pragma mark -
#pragma mark Text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];

	if([self validateData:[self formData]]==nil) {
		[self saveAndExit];
	}

	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger ret = 0;
	for(NSObject *element in elements) {
		if([element isKindOfClass:[IGFormSection class]])
			ret++;
	}
	return ret;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger currentSection = -1;
	for(NSObject *element in elements) {
		if([element isKindOfClass:[IGFormSection class]]) {
			currentSection++;
			
			if(section == currentSection)
				return [(IGFormSection *)element title];

		}
	}
	
	return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	NSInteger currentSection = -1;
	for(NSObject *element in elements) {
		if([element isKindOfClass:[IGFormSection class]]) {
			currentSection++;
			
			if(section == currentSection)
				return [(IGFormSection *)element footer];
            
		}
	}
	
	return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSInteger currentSection = -1;
	NSInteger ret = 0;
	for(NSObject *element in elements) {
		if([element isKindOfClass:[IGFormSection class]])
			currentSection++;
		else if(section == currentSection)
			ret++;
	}
	
	return ret;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *DefaultCellIdentifier = @"Default";
    static NSString *Value1CellIdentifier = @"Value1";
    
	// find the appropriate element
	NSObject *e = [self elementAtIndexPath:indexPath];
    
    UITableViewCell *cell;
    if([e isKindOfClass:[IGFormButton class]] && ((IGFormButton *)e).detailTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:Value1CellIdentifier];
        if(!cell)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Value1CellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
        if(!cell)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier];
    }
    
    // set default cell attributes to be overriden based on the element below
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;    
	
	if([e isKindOfClass:[IGFormTextField class]]) {
		IGFormTextField *textField = (IGFormTextField *)e;
		textField.textField.frame = CGRectMake(12, 0, 286, 44);
		textField.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[cell.contentView addSubview:textField.textField];
        
	} else if([e isKindOfClass:[IGFormRadioOption class]]) {
		IGFormRadioOption *radioOption = (IGFormRadioOption *)e;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if(radioOption.selected)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.text = [radioOption title];
        
	} else if([e isKindOfClass:[IGFormTextView class]]) {
		IGFormTextView *textView = (IGFormTextView *)e;
		textView.textView.frame = CGRectMake(0, 0, 300, 140);
		[cell.contentView addSubview:textView.textView];
        
	} else if([e isKindOfClass:[IGFormSwitch class]]) {
        IGFormSwitch *formSwitch = (IGFormSwitch *)e;
        cell.textLabel.text = formSwitch.title;
        cell.accessoryView = formSwitch.switchControl;
        
    } else if([e isKindOfClass:[IGFormButton class]]) {
        IGFormButton *formButton = (IGFormButton *)e;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = formButton.title;
        cell.detailTextLabel.text = formButton.detailTitle;
        if(formButton.type == IGFormButtonTypeDisclosure)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        else
            cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	IGFormElement *e = [self elementAtIndexPath:indexPath];
	if([e isKindOfClass:[IGFormTextView class]])
		return 140.0f;
	else
		return 44.0f;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *e = [self elementAtIndexPath:indexPath];
	if([e isKindOfClass:[IGFormRadioOption class]]) {
		IGFormRadioOption *radioOption = (IGFormRadioOption *)e;

		// deselect all in that category
		for(NSObject *element in elements) {
			if([element isKindOfClass:[IGFormRadioOption class]] && [[(IGFormRadioOption *)element key] isEqualToString:radioOption.key])
				[(IGFormRadioOption *)element setSelected:NO];
		}
		
		// select only that one
		[radioOption setSelected:YES];
		
		// show and animate changes
		[self.tableView reloadData];
		[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	} else if([e isKindOfClass:[IGFormButton class]]) {
        // execute the form button action
        IGFormButton *button = (IGFormButton *)e;
        if(button.action)
            button.action();
        if(button.type == IGFormButtonTypeNormal)
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

@end

