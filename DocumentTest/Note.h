//
//  Note.h
//  DocumentTest
//
//  Created by Brian Clubb on 11/30/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *date;

- (NSString *)stringDate;
+ (NSArray *)getAllNotesWith:(NSManagedObjectContext *)context;

@end
