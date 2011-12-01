//
//  BSLMasterViewController.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSLDetailViewController;

@interface BSLMasterViewController : UITableViewController

@property (strong) BSLDetailViewController *detailViewController;
@property (strong) NSArray *notes;
@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)loadNotes;

@end
