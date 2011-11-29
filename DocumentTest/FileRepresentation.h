//
//  FileRepresentation.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/28/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileRepresentation : NSObject

@property (strong) NSString *fileName;
@property (strong) NSURL *fileURL;

- (id)initWithFileName:(NSString *)fileName url:(NSURL *)fileURL;
- (id)initWithUIDocument:(UIDocument *)document;
- (id)fileRepresentationWithFileName:(NSString *)fileName url:(NSURL *)fileURL;
+ (NSURL*)localDocumentsDirectory;
@end
