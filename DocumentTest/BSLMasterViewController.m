//
//  BSLMasterViewController.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "BSLMasterViewController.h"

#import "BSLDetailViewController.h"

@implementation BSLMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize notes = _notes;
@synthesize query = _query;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Notes";//NSLocalizedString(@"Master", @"Master");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

- (void)addNote:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
    NSString *fileName = [NSString stringWithFormat:@"Note_%@", [formatter stringFromDate:[NSDate date]]];
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiqPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:fileName];
    Note *doc = [[Note alloc] initWithFileURL:ubiqPackage];
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if(success){
            [self.notes addObject:doc];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadData:(NSMetadataQuery *)query{
    [self.notes removeAllObjects];
    for (NSMetadataItem *item in [query results]) {
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc] initWithFileURL:url];
        [doc openWithCompletionHandler:^(BOOL success){
            if(success){
                [self.notes addObject:doc];
                [self.tableView reloadData];
            } else {
                NSLog(@"Failed to open from iCloud");
            }
        }];
    }
}

- (void)queryDidFinishGathering:(NSNotification *)notification{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [self loadData:query];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    
    self.query = nil;
}
                                 
- (void)loadNotes{
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if(ubiq){
        self.query = [[NSMetadataQuery alloc] init];
        [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like 'Note_*'", NSMetadataItemFSNameKey];
        [self.query setPredicate:predicate];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:self.query];
        [self.query startQuery];
    } else {
        NSLog(@"No iCloud access");
    }
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.notes = [[NSMutableArray alloc] init];
    self.title = @"Notes";
    UIBarButtonItem *addNoteItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = addNoteItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotes) name:UIApplicationDidBecomeActiveNotification object:nil];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(loadNotes)];
    self.navigationItem.leftBarButtonItem= refreshItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Note *note = [_notes objectAtIndex:indexPath.row];
    // Configure the cell.
    cell.textLabel.text = note.fileURL.lastPathComponent;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[BSLDetailViewController alloc] initWithNibName:@"BSLDetailViewController" bundle:nil];
    }
    Note *note = [self.notes objectAtIndex:indexPath.row];
    [self.delegate bslMasterViewController:self choseNewNote:note];
    self.detailViewController.doc = note;
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
