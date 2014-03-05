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
	NSString *text = [[NSString alloc] initWithContentsOfFile:@"/usr/share/dict/words" encoding:NSUTF8StringEncoding error:NULL];
	words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	[self.delegate performSelector:@selector(stringSourceDidFinishLoading:) withObject:self afterDelay:0];
}

- (NSString *)string
{
	return [words objectAtIndex:arc4random_uniform((unsigned int)[words count]-1)];
}

@end
