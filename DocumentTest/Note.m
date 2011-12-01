//
//  Note.m
//  DocumentTest
//
//  Created by Brian Clubb on 11/30/11.
//  Copyright (c) 2011 Bubblesort Laboratories LLC. All rights reserved.
//

#import "Note.h"


@implementation Note

@dynamic text;
@dynamic date;

-(NSString *)stringDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd hh:mm:ss"];
    return [NSString stringWithFormat:@"Entry from %@", [formatter stringFromDate:self.date]];
}

+ (NSArray *)getAllNotesWith:(NSManagedObjectContext *)context{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	[fetchRequest setEntity:entity];
	
	
	NSError *error;
	
	NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil) {
		NSLog(@"Couldn't fetch the records and got this error %@, %@", error, [error userInfo]);
	}
	return results;
}

@end
