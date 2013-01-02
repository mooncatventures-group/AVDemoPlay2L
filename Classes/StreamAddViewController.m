//
//  StreamAddViewController.m
//  CoreDataStorage
//
//Licensed under GPL version 2.0
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StreamAddViewController.h"
#import "FavoritesViewController.h"


@implementation StreamAddViewController

@synthesize streamNameTextField;
@synthesize streamUrlTextField;
@synthesize streamDescriptionTextField;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Configure the navigation bar
    self.navigationItem.title = @"Add Stream";
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] 
											initWithTitle:@"Cancel" 
											style:UIBarButtonItemStyleBordered 
											target:self 
											action:@selector(cancel)];
    [[self navigationItem] setLeftBarButtonItem:cancelBarButtonItem];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] 
										  initWithTitle:@"Save" 
										  style:UIBarButtonItemStyleDone 
										  target:self 
										  action:@selector(save)];
    [[self navigationItem] setRightBarButtonItem:saveBarButtonItem];
    
    [streamNameTextField becomeFirstResponder];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Action methods

- (void)save {
    [[self delegate] saveStream:self];
}

- (void)cancel {
    [[self delegate] cancel];
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setStreamNameTextField:nil];
    [self setStreamUrlTextField:nil];
    [self setStreamDescriptionTextField:nil];
    [super viewDidUnload];
}


@end
