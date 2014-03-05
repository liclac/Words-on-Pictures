//
//  WPStandardWallpapersBackgroundSource.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WPStandardWallpapersBackgroundSource.h"

static NSString * const kWPStandardWallpapersBackgroundSourceBasePath = @"/Library/Desktop Pictures/";

@implementation WPStandardWallpapersBackgroundSource
@synthesize delegate;

+ (NSString *)sourceName
{
	return @"Standard Wallpapers";
}

+ (NSString *)sourceDescription
{
	return @"Random selection from the wallpapers that came with the computer";
}

- (void)startLoading
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSFileManager *fm = [[NSFileManager alloc] init];
		NSError *error = nil;
		NSArray *items = [fm contentsOfDirectoryAtURL:[NSURL fileURLWithPath:kWPStandardWallpapersBackgroundSourceBasePath] includingPropertiesForKeys:@[NSURLIsRegularFileKey] options:0 error:&error];
		if(!error)
		{
			urls = [[NSMutableArray alloc] init];
			for (NSURL *url in items)
			{
				id value;
				if([url getResourceValue:&value forKey:NSURLIsRegularFileKey error:NULL] && [value boolValue])
					[urls addObject:url];
			}
			NSLog(@"%@", urls);
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate backgroundSourceDidFinishLoading:self];
			});
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate backgroundSource:self didFailLoadingWithError:[error localizedDescription]];
			});
		}
	});
}

- (void)loadImage
{
	/*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURL *url = [urls objectAtIndex:arc4random_uniform((unsigned int)[urls count]-1)];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		NSImage *img = [[NSImage alloc] initWithData:data];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate backgroundSource:self didLoadImage:img];
		});
	});*/
	NSURL *url = [urls objectAtIndex:arc4random_uniform((unsigned int)[urls count]-1)];
	[self.delegate backgroundSource:self didLoadImage:[[NSImage alloc] initWithContentsOfURL:url]];
}

@end
