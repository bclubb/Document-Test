//
//  BSLMasterViewController.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "BSLMasterViewController.h"
#import "FileRepresentation.h"
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
    Note *note = [Note newNote];
    [note saveToURL:[note fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if(success){
            [self.notes addObject:[[FileRepresentation alloc] initWithFileName:[note.fileURL lastPathComponent] url:note.fileURL]];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadData:(NSMetadataQuery *)query{
    [self.notes removeAllObjects];
    for (NSMetadataItem *item in [query results]) {
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        [self.notes addObject:[[FileRepresentation alloc] initWithFileName:[url lastPathComponent] url:url]];
        [self.tableView reloadData];
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
        NSArray *localDocuments = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[FileRepresentation localDocumentsDirectory] path] error:nil];
        [self.notes removeAllObjects];
        for (NSString *file in localDocuments) {
            [self.notes addObject:[[FileRepresentation alloc] initWithFileName:[file lastPathComponent] url:[NSURL fileURLWithPath:[[[FileRepresentation localDocumentsDirectory] path] stringByAppendingPathComponent:file]]]];
        }
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

    FileRepresentation *fileRepresentation = [self.notes objectAtIndex:indexPath.row];
    // Configure the cell.
    cell.textLabel.text = fileRepresentation.fileName;
    NSLog(@"Adding file to table: %@", fileRepresentation.fileURL);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *noteURL = [[self.notes objectAtIndex:indexPath.row] fileURL];
    Note *note = [[Note alloc] initWithFileURL:noteURL];
    [note openWithCompletionHandler:^(BOOL success){
        if(success){
            [self.delegate bslMasterViewController:self choseNewNote:note];
            NSLog(@"Opened document at URL: %@", noteURL);
        } else {
            NSLog(@"Failed to open document");
        }
    }];
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
