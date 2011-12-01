//
//  BSLDetailViewController.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLMasterViewController.h"
#import "Note.h"

@interface BSLDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextViewDelegate>

@property (strong) Note *note;
@property (weak) IBOutlet UITextView *noteView;
@property (strong) NSManagedObjectContext *managedObjectContext;

@end
