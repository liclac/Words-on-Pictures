//
//  WPWallbaseBackgroundSource.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WPWallbaseBackgroundSource.h"

@implementation WPWallbaseBackgroundSource
@synthesize delegate;

+ (NSString *)sourceName
{
	return @"Wallbase.cc";
}

+ (NSString *)sourceDescription
{
	return @"Images scraped from Wallbase.cc";
}

- (id)init
{
	if((self = [super init]))
	{
		manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		urls = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)startLoading
{
	[manager GET:@"http://wallbase.cc/search"
	  parameters:@{ @"q": @"scenic", @"color": @"", @"section": @"wallpapers", @"res_opt": @"eqeq", @"res": @"0x0", @"order_mode": @"desc", @"order": @"random", @"thpp": @"60", @"purity": @"100", @"board": @"2", @"aspect": @"0.00" }
		 success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"rozne/thumb-([0-9]+\\.[a-zA-Z]+)"
																			  options:NSRegularExpressionCaseInsensitive error:NULL];
		 [exp enumerateMatchesInString:operation.responseString options:0 range:NSMakeRange(0, [operation.responseString length])
							usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		  {
			  NSString *s = [operation.responseString substringWithRange:[result rangeAtIndex:1]];
			  [urls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://wallpapers.wallbase.cc/rozne/wallpaper-%@", s]]];
		  }];
		 
		 [self.delegate backgroundSourceDidFinishLoading:self];
		 
		 if(loadAnImageOnceDataFinishesLoading)
		 {
			 loadAnImageOnceDataFinishesLoading = NO;
			 [self loadImage];
		 }
	 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 [self.delegate backgroundSource:self didFailLoadingWithError:[error localizedDescription]];
	 }];
}

- (void)loadImage
{
	// If there's no data, load some
	if([urls count] < 1)
	{
		loadAnImageOnceDataFinishesLoading = YES;
		[self startLoading];
		return;
	}
	
	NSURL *url = [urls lastObject];
	AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:url]
																  success:NULL failure:NULL];
	op.responseSerializer = [AFImageResponseSerializer serializer];
	
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self.delegate backgroundSource:self didLoadImage:responseObject];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self.delegate backgroundSource:self didFailToLoadImageWithError:[error localizedDescription]];
	}];
	
	[op start];
}

@end
