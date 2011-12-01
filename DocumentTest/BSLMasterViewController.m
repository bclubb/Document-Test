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
@synthesize managedObjectContext = _managedObjectContext;

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
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[self managedObjectContext]];

    note.date = [NSDate date];
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Tried to add a note and got this error %@, %@", error, [error userInfo]); 
    }
    [self loadNotes];
}
                                 
- (void)loadNotes{
    self.notes = [Note getAllNotesWith:[self managedObjectContext]];
    [self.tableView reloadData];
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
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

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadNotes];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
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

    Note *note = [self.notes objectAtIndex:indexPath.row];
    // Configure the cell.
    cell.textLabel.text = [note stringDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [self.notes objectAtIndex:indexPath.row];
    BSLDetailViewController *newBSLDetailViewController = [[BSLDetailViewController alloc] initWithNibName:nil bundle:nil];
    newBSLDetailViewController.note = note;
    newBSLDetailViewController.managedObjectContext = [self managedObjectContext];
    UINavigationController *navigationController = self.detailViewController.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:newBSLDetailViewController animated:NO];
}

@end
