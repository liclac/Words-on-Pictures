//
//  WPHorseEbooksStringSource.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WPHorseEbooksStringSource.h"

static const int kWPHorseEbooksStringSourceReloadThreshold = 10;

@implementation WPHorseEbooksStringSource
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
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		sentences = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)startLoading
{
	[manager GET:@"http://horseebooksipsum.com/api/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[sentences addObjectsFromArray:[operation.responseString componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]]];
		[self.delegate stringSourceDidFinishLoading:self];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self.delegate stringSource:self didFailLoadingWithError:[error localizedDescription]];
	}];
}

- (NSString *)string
{
	NSString *retval = [sentences lastObject];
	[sentences removeLastObject];
	
	if([sentences count] < kWPHorseEbooksStringSourceReloadThreshold)
		[self startLoading];
	
	return retval;
}

@end
