//
//  Note.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/20/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize noteContent;

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    if([contents length] > 0){
        self.noteContent = [[NSString alloc] initWithBytes:[contents bytes] length:[contents length] encoding:NSUTF8StringEncoding];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" object:self];
    } else {
        self.noteContent = @"";
    }
    return YES;
}

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSLog(@"writting the contents of the note %@", self.noteContent);
    if([self.noteContent length] == 0){
        self.noteContent = @"";
    }
    return [NSData dataWithBytes:[self.noteContent UTF8String] length:[self.noteContent length]];
}

@end
