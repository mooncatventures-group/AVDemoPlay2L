//
//  WToolbarController.h
//
//  Copyright 2009 __mooncatventures.com__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WToolbarController : NSObject{
	
	UIToolbar* theToolbar;
	id delegate;
	UIBarButtonItem* previousItem;
	UIBarButtonItem* nextItem;
	UIBarButtonItem* cancelandrefreshItem;
	NSUInteger cancelandrefreshItemType; //0: refresh ; 1: stop
}

@property (nonatomic, retain) UIToolbar* theToolbar;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIBarButtonItem* previousItem;
@property (nonatomic, retain) UIBarButtonItem* nextItem;
@property (nonatomic, retain) UIBarButtonItem* cancelandrefreshItem;
@property (assign) NSUInteger cancelandrefreshItemType;

- (void)createToolbarItems;
- (void)clickPreviousItem;
- (void)clickNextItem;
- (void)clickCancelAndRefreshItem;
- (void)clickRefreshItem;
- (void)clickCancelItem;
- (void)clickAddItem;
- (void)clickActionItem;
- (void)changeToRefreshItem;
- (void)changeToCancelItem;

@end
