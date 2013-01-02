//
//  FavoritesViewController.h
//  CoreDataStorage
//
//Licensed under GPL version 2.0
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class StreamAddViewController;

@interface FavoritesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)addStream:(id)sender;
- (void)saveStream:(StreamAddViewController *)sender;
- (void)cancel;

@end
