//
//  BSLDetailViewController.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/19/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "BSLMasterViewController.h"

@interface BSLDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextViewDelegate, BSLMasterViewControllerDelegate>

@property (strong, nonatomic) Note *doc;
@property (weak) IBOutlet UITextView *noteView;

@end
