//
//  StreamDetailViewController.m
//Licensed under GPL version 2.0
//
//

#import "StreamDetailViewController.h"
#import "BDTableViewCell.h"
#import	"WToolbarController.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <FFmpegDecoder/libavdevice/avdevice.h>
#import "DetailViewController.h"
#import "Stream.h"


@implementation StreamDetailViewController

@synthesize stream;
@synthesize theToolbarController;
@synthesize detailViewController = _detailViewController;
@synthesize webView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    theToolbarController = [[WToolbarController alloc] init];
	theToolbarController.delegate = self;
	[self.view addSubview: theToolbarController.theToolbar];
	[theToolbarController.theToolbar release];

	[self setTitle:@"Stream Details"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [player closeStreams];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = [indexPath section];
	if (section  == 2)
		return 100;
	else
		return 30;
}



// Customize the Header Titles of the table view.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionTitle = nil;
	
	switch (section) {
		case 0:
			sectionTitle = @"Name";
			break;
		case 1:
			sectionTitle = @"Network Address";
			break;
        case 2:
			sectionTitle = @"Details";
			break;

		default:
			break;
	}
    return sectionTitle;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int section = [indexPath section];
	int row = [indexPath row];
	NSString *cellText = nil;
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
				 initWithStyle:UITableViewStyleGrouped
				 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	switch (section) {
		case 0:
			cellText = [stream streamName];
			break;
		case 1:
            cellText = [stream streamUrl];
            break;
        case 2:
                {
                    cell = [[BDTableViewCell alloc]initWithStyle:UITableViewStyleGrouped reuseIdentifier:CellIdentifier];
                 //   cell = [[BDTableViewCell alloc]initWithFrame:CGRectZero
                      //      reuseIdentifier:CellIdentifier];

                    [cell setFrame:CGRectZero];
                    UITextView *textView = [[UITextView alloc] init];
                    textView.text = [stream streamDescription];
                    ((BDTableViewCell *)cell).textView = textView;
                    break;
                }
				
		default:
			break;
	}
	
	[[cell textLabel] setText:cellText];
    
    return cell;
}

- (void)clickActionItem
{
	
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Email Link", 
								  @"Open in Safari", 
								  @"Cancel", nil];
	actionSheet.tag = 5;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 2;	
	[actionSheet showInView:self.view];
	[actionSheet release];
	
}


- (void)clickAddItem
{
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Email Link", 
								  @"Open in Safari", 
								  @"Cancel", nil];
	actionSheet.tag = 5;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 2;	
	[actionSheet showInView:self.view];
	[actionSheet release];
	
	
    
}



- (void)clickNextItem
{
    
	if (self.editing) return;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Play Stream",
								  @"Play as UDP stream",
								  @"Cancel", nil];
	actionSheet.tag = 4;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.cancelButtonIndex = 3;
	[actionSheet showInView:self.view];
	[actionSheet release];
	
    
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
	if(4 == actionSheet.tag)
	{
		if(0 == buttonIndex)//save page
		{    
            CGRect frame = CGRectMake(0, 0, 320, 480);
            player = [[GLPlayer alloc] initWithFrame:frame movie:[stream streamUrl] aspectRatio:(16.0/9.0) useTCP:YES];
                       
            [player setMaxAudioBuffer:(5*16*1024)];
            [player setMaxVideoBuffer:(5*25*1024)];
            
            
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            [detailViewController.view addSubview:player];
            [player release];
            
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];

            
        }
		else if(1 == buttonIndex)
		{
            CGRect frame = CGRectMake(0, 0, 320, 480);
            player = [[GLPlayer alloc] initWithFrame:frame movie:[stream streamUrl] aspectRatio:(16.0/9.0) useTCP:NO];
            
            [player setMaxAudioBuffer:(5*16*1024)];
            [player setMaxVideoBuffer:(5*25*1024)];
            
            
            DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            [detailViewController.view addSubview:player];
            [player release];
            
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            

                   
        }
		
        
        
		//}
        
	}
	
	else if(5 == actionSheet.tag)
	{
		if(0 == buttonIndex)//email link
			
		{ 
					}
		
		else if(1 == buttonIndex)//open in safari
		{
            //NSString* url = [[NSString alloc] initWithFormat:@"%@wiki/%@", http, page];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:book.url]];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            //[url release];
			
			
			//create a frame that will be used to size and place the web view
			CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
			webFrame.origin.y -= 20.0;	// shift the display up so that it covers the default open space from the content view
			//webFrame.size.height -=toolbarHeight;
			
			UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
			self.webView = aWebView;
			/*
			 *	Uncomment the following line if you want the HTML to scale to fit.  
			 *	This also allows the pinch zoom in and out functionality to work.
			 */
			aWebView.scalesPageToFit = YES;
			aWebView.autoresizesSubviews = YES;
			aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			//set the web view delegate for the web view to be itself
			[aWebView setDelegate:self];
			
			//determine the path the to the index.html file in the Resources directory
			//NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
			//build the URL and the request for the index.html file
			NSURL *aURL = [NSURL URLWithString:[stream streamUrl]];
			NSURLRequest *aRequest = [NSURLRequest requestWithURL:aURL];
			
			
			//load the index.html file into the web view.
			[aWebView loadRequest:aRequest];
			
			//add the web view to the content view
            [self.view addSubview:webView];
			
			
			
			
			
        }
		else if(2 == buttonIndex)//cancel
		{
            
            
		}
	}
	
	
}

- (void)dealloc {
	[theToolbarController release];
    [_detailViewController release];
    [super dealloc];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
	[self setStream:nil];
}



@end

