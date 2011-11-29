//
//  FileRepresentation.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/28/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "FileRepresentation.h"

@implementation FileRepresentation

@synthesize fileURL = _fileURL;
@synthesize fileName = _fileName;

-(id)initWithFileName:(NSString *)fileName url:(NSURL *)fileURL{
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.fileURL = fileURL;
    }
    return self;
}

- (id)initWithUIDocument:(UIDocument *)document{
    return [[FileRepresentation alloc] initWithFileName:[document.fileURL lastPathComponent] url:document.fileURL];
}

-(id)fileRepresentationWithFileName:(NSString *)fileName url:(NSURL *)fileURL{
    return [[FileRepresentation alloc] initWithFileName:fileName url:fileURL];
}

+ (NSURL*)localDocumentsDirectory{
    static NSURL *localDocumentDirectory = nil;
    if(localDocumentDirectory == nil){
        NSString *documentDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"Initial Documents Path: %@", documentDirectoryPath);
        localDocumentDirectory = [[NSURL fileURLWithPath:documentDirectoryPath] URLByAppendingPathComponent:@"Documents"];
        NSLog(@"Final Documents Path: %@", localDocumentDirectory);
    }
    
    return localDocumentDirectory;
}

@end
