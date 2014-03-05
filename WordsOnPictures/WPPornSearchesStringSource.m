//
//  WPPornSearchesStringSource.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WPPornSearchesStringSource.h"

static const int kWPPornSearchesStringSourceReloadThreshold = 10;

@implementation WPPornSearchesStringSource
@synthesize delegate;

+ (NSString *)sourceName
{
	return @"Horse Ebooks Ipsum";
}

+ (NSString *)sourceDescription
{
	return @"Words of wisdom from http://horseebooksipsum.com/";
}

- (id)init
{
	if((self = [super init]))
	{
		manager = [AFHTTPRequestOperationManager manager];
		searches = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)startLoading
{
	[manager GET:@"http://www.pornmd.com/getliveterms"
	  parameters:@{@"orientation": @"s",
				   @"_": [NSNumber numberWithDouble:CFAbsoluteTimeGetCurrent()]}
		 success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSLog(@"%@", responseObject);
		 for (NSDictionary *dict in operation.responseObject)
			 [searches addObject:[dict objectForKey:@"keyword"]];
		 [self.delegate stringSourceDidFinishLoading:self];
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 [self.delegate stringSource:self didFailLoadingWithError:[error localizedDescription]];
	 }];
}

- (NSString *)string
{
	NSString *retval = nil;
	if([searches count] > 0)
	{
		retval = [searches lastObject];
		[searches removeLastObject];
	}
	
	if([searches count] < kWPPornSearchesStringSourceReloadThreshold)
		[self startLoading];
	
	return retval;
}

@end
