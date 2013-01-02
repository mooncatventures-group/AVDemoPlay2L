//
//  StreamAddViewController.h
//  CoreDataStorage
//
//Licensed under GPL version 2.0
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StreamAddViewController : UIViewController <UITextFieldDelegate> {
}

@property (nonatomic, strong) IBOutlet UITextField *streamNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *streamUrlTextField;
@property (nonatomic, strong) IBOutlet UITextView *streamDescriptionTextField;
@property (nonatomic, strong) id delegate;

@end
