//
//  Note.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/20/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "Note.h"
#import "FileRepresentation.h"

@implementation Note{
    NSString *_noteContents;
    UIImage *_image;
}

static NSString *TextFileName = @"note.txt";
static NSString *ImageFileName = @"image.png";
static NSString *FileExtension = @"notes";
static int TextFileEncoding = NSStringEncodingConversionAllowLossy;

@synthesize fileWrapper;
@synthesize delegate = _delegate;

+(id)newNote{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
    NSString *fileName = [NSString stringWithFormat:@"Note_%@.notes", [formatter stringFromDate:[NSDate date]]];
    // Always save local and then move to iCloud if the user has requested
    return [[Note alloc] initWithFileURL:[[FileRepresentation localDocumentsDirectory] URLByAppendingPathComponent:fileName]];
}

-(NSString *)noteContent{
    if(_noteContents == nil){
        _noteContents = [[NSString alloc] initWithData:[[[self.fileWrapper fileWrappers] objectForKey:TextFileName] regularFileContents] encoding:NSUTF8StringEncoding];
    }
    return _noteContents;
}

-(void)setNoteContent:(NSString *)noteContent{
    _noteContents = noteContent;
}

-(UIImage *)image{
    if(_image == nil){
        _image = [[UIImage alloc] initWithData:[[[self.fileWrapper fileWrappers] objectForKey:ImageFileName] regularFileContents]];
    }
    return _image;
}

-(void)setImage:(UIImage *)image{
    self.image = image;
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    self.fileWrapper = (NSFileWrapper *)contents;
    if([_delegate respondsToSelector:@selector(noteContentsUpdated:)]){
        [_delegate noteContentsUpdated:self];
    }
    return YES;
}

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    if(self.fileWrapper == nil){
        self.fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    
    NSLog(@"Saving %@", [self.fileURL lastPathComponent]);
    
    NSDictionary *fileWrappers = [self.fileWrapper fileWrappers];
    
    if (_noteContents != nil) {
        if([fileWrappers objectForKey:TextFileName] != nil){
            [self.fileWrapper removeFileWrapper:[fileWrappers objectForKey:TextFileName]];
        }
        NSLog(@"asking for contents: %@ \n for: %@", self.noteContent, [self.fileURL lastPathComponent]);
        NSData *textData = [_noteContents dataUsingEncoding:TextFileEncoding];
        NSFileWrapper *textFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:textData];
        [textFileWrapper setPreferredFilename:TextFileName];
        [self.fileWrapper addFileWrapper:textFileWrapper];
    }
    
    if ([fileWrappers objectForKey:ImageFileName] == nil && self.image != nil){
        if([fileWrappers objectForKey:ImageFileName] != nil){
            [self.fileWrapper removeFileWrapper:[fileWrappers objectForKey:ImageFileName]];
        }
        @autoreleasepool {
            NSData *imageData = UIImagePNGRepresentation(self.image);
            NSFileWrapper *imageFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:imageData];
            [imageFileWrapper setPreferredFilename:ImageFileName];
            [self.fileWrapper addFileWrapper:imageFileWrapper];
        }
    }
    
    return self.fileWrapper;
}

@end
