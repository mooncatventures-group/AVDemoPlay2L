//
//  StreamDetailViewController.h
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//Licensed under GPL version 2.0

#import <UIKit/UIKit.h>
#import <StreamMorePlay/GLPlayer.h>


@class Stream;
@class WToolbarController;
@class DetailViewController;

@interface StreamDetailViewController : UITableViewController <UIWebViewDelegate,UIActionSheetDelegate> {
    WToolbarController* theToolbarController;
    UIWebView *webView;
    GLPlayer *player;

}

@property (nonatomic, strong) Stream *stream;
@property (nonatomic, retain) WToolbarController* theToolbarController;
@property (nonatomic, retain) UIWebView *webView;
@property (strong, nonatomic) DetailViewController *detailViewController;


@end
