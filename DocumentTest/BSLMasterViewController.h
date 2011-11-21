//
//  BSLMasterViewController.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol BSLMasterViewControllerDelegate;

@class BSLDetailViewController;

@interface BSLMasterViewController : UITableViewController

@property (strong) BSLDetailViewController *detailViewController;
@property (strong) NSMutableArray *notes;
@property (strong) NSMetadataQuery *query;
@property (weak) id<BSLMasterViewControllerDelegate> delegate;

-(void)loadNotes;

@end

@protocol BSLMasterViewControllerDelegate
- (void)bslMasterViewController:(BSLMasterViewController *)masterViewController choseNewNote:(Note *)doc;
@end

