//
//  FavoritesViewController.m
//Licensed under GPL version 2.0
#import "FavoritesViewController.h"
#import "StreamAddViewController.h"
#import "StreamDetailViewController.h"
#import "Stream.h"


@interface FavoritesViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation FavoritesViewController

@synthesize fetchedResultsController=fetchedResultsController_;
@synthesize managedObjectContext=managedObjectContext_;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"Streams"];
	[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] 
				 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
									  target:self 
									  action:@selector(addStream:)];
	[[self navigationItem] setRightBarButtonItem:addButtonItem];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}


// Implement viewWillAppear: to do additional setup before the 
// view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[self tableView] reloadData];
}


#pragma mark -
#pragma mark Action methods

- (void)addStream:(id)sender {
	StreamAddViewController *addController = 
	                    [[StreamAddViewController alloc] init]; 
	
	[addController setDelegate:self];
	
	UINavigationController *navigationController = 
	                    [[UINavigationController alloc] 
						initWithRootViewController:addController];
    [self presentModalViewController:navigationController animated:YES];
	
}

#pragma mark -
#pragma mark Delegate Action methods

- (void)saveStream:(StreamAddViewController *)sender {
	
	// Create a new instance of the entity managed by the 
	// fetched results controller.
    NSManagedObjectContext *context = 
	     [[self fetchedResultsController] managedObjectContext];
    NSEntityDescription *entity = 
	     [[[self fetchedResultsController] fetchRequest] entity];
    
    
    NSManagedObject *newManagedObject = 
	     [NSEntityDescription insertNewObjectForEntityForName:[entity name] 
									   inManagedObjectContext:context];
	
	[newManagedObject setValue:[[sender streamNameTextField] text] 
						forKey:@"streamName"];
	[newManagedObject setValue:[[sender streamUrlTextField] text] 
						forKey:@"streamUrl"];
	[newManagedObject setValue:[[sender streamDescriptionTextField] text] 
						forKey:@"streamDescription"];
	
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	[[self tableView] reloadData];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView 
                         numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = 
	         [[[self fetchedResultsController] sections] 
			  objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark -
#pragma mark TableView cell appearance

- (void)configureCell:(UITableViewCell *)cell 
		  atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = 
	     [[self fetchedResultsController] objectAtIndexPath:indexPath];
	[[cell textLabel] setText:[[managedObject valueForKey:@"streamName"] 
							   description]];
    cell.imageView.image = [UIImage imageNamed:@"streaming.png"]; 
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0]];
    [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    [cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];	
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = 
	     [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:CellIdentifier];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
                commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = 
		[[self fetchedResultsController] managedObjectContext];
        [context deleteObject:[[self fetchedResultsController] 
							   objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView 
                            didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Stream *stream = (Stream *)[[self fetchedResultsController] 
								objectAtIndexPath:indexPath];
	
	StreamDetailViewController *streamDetailViewController = 
	[[StreamDetailViewController alloc] 
	 initWithStyle:UITableViewStyleGrouped];
	[streamDetailViewController setStream:stream];
	
	[[self navigationController] pushViewController:streamDetailViewController 
										   animated:YES];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = 
	                  [NSEntityDescription entityForName:@"Stream" 
				      inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = 
	            [[NSSortDescriptor alloc] initWithKey:@"streamName"
											ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] 
								initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = 
	                        [[NSFetchedResultsController alloc] 
							 initWithFetchRequest:fetchRequest
							 managedObjectContext:[self managedObjectContext]
							 sectionNameKeyPath:nil cacheName:@"Root"];
	[aFetchedResultsController setDelegate:self];
	[self setFetchedResultsController:aFetchedResultsController];
    
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    

#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller 
                 didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                          atIndex:(NSUInteger)sectionIndex 
	                forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet 
						 indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet 
						 indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:
					 [NSArray arrayWithObject:newIndexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:
			         [NSArray arrayWithObject:indexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] 
					atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:
			         [NSArray arrayWithObject:indexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:
				     [NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}


/*
 // Implementing the above methods to update the table view in 
 response to individual changes may have performance implications 
 if a large number of changes are made simultaneously. 
 If this proves to be an issue, you can instead just implement 
 controllerDidChangeContent: which notifies the delegate that all 
 section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setFetchedResultsController:nil];
}



@end

