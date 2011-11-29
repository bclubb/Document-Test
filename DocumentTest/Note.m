//
//  Note.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/20/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "Note.h"

@implementation Note

static NSString *TextFileName = @"text.notes";
static NSString *ImageFileName = @"image.png";
static NSString *FileExtension = @"notes";
static int TextFileEncoding = NSStringEncodingConversionAllowLossy;

@synthesize noteContent, image, fileWrapper;
@synthesize delegate = _delegate;

#warning Not supporting local yet
+(id)newNote{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
    NSString *fileName = [NSString stringWithFormat:@"Note_%@", [formatter stringFromDate:[NSDate date]]];
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiqPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:fileName];
    return [[Note alloc] initWithFileURL:ubiqPackage]; 
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
    
    NSDictionary *fileWrappers = [self.fileWrapper fileWrappers];
    
    if ([fileWrappers objectForKey:TextFileName] == nil && self.noteContent != nil) {
        NSData *textData = [self.noteContent dataUsingEncoding:TextFileEncoding];
        NSFileWrapper *textFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:textData];
        [textFileWrapper setPreferredFilename:TextFileName];
        [self.fileWrapper addFileWrapper:textFileWrapper];
    }
    
    if ([fileWrappers objectForKey:ImageFileName] == nil && self.image != nil){
        @autoreleasepool {
            NSData *imageData = UIImagePNGRepresentation(image);
            NSFileWrapper *imageFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:imageData];
            [imageFileWrapper setPreferredFilename:ImageFileName];
            [self.fileWrapper addFileWrapper:imageFileWrapper];
        }
    }
    
    return self.fileWrapper;
}

@end
