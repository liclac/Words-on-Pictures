//
//  WPUnixWordsStringSource.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WPUnixWordsStringSource.h"

@implementation WPUnixWordsStringSource
@synthesize delegate;

+ (NSString *)sourceName
{
	return @"Unix Words File";
}

+ (NSString *)sourceDescription
{
	return @"Random words picked from /usr/share/dict/words";
}

- (void)startLoading
{
	// Dispatch the (quite slow) loading of this massive file into a concurrent block
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSString *text = [[NSString alloc] initWithContentsOfFile:@"/usr/share/dict/words" encoding:NSUTF8StringEncoding error:NULL];
		words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		// Dispatch the delegate message back to the main thread; doing it from a block could mean trouble
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate stringSourceDidFinishLoading:self];
		});
		
	});
}

- (NSString *)string
{
	return [words objectAtIndex:arc4random_uniform((unsigned int)[words count]-1)];
}

@end
