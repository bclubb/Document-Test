//
//  BSLMasterViewController.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "FileRepresentation.h"

@class BSLDetailViewController;

@interface BSLMasterViewController : UITableViewController

@property (strong) BSLDetailViewController *detailViewController;
@property (strong) NSMutableArray *notes;
@property (strong) NSMetadataQuery *query;

- (void)loadNotes;
- (void)moveFileToiCloud:(FileRepresentation *)fileToMove;
- (void)moveFileToLocal:(FileRepresentation *)fileToMove;

@end
