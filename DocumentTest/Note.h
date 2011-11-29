//
//  Note.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/20/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteDelegate;

@interface Note : UIDocument

@property (strong) NSString *noteContent;
@property (strong) UIImage *image;
@property (strong) NSFileWrapper *fileWrapper;
@property (weak) id<NoteDelegate> delegate;

+(id) newNote;

@end

@protocol NoteDelegate <NSObject>
-(void)noteContentsUpdated:(Note *)note;
@end