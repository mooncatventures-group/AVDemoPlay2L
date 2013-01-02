//
//  Stream.h
//  CoreDataStorage
//
//  Created by Michelle Cannon on 12/2/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stream : NSManagedObject

@property (nonatomic, retain) NSString * streamDescription;
@property (nonatomic, retain) NSString * streamUrl;
@property (nonatomic, retain) NSString * streamName;

@end
