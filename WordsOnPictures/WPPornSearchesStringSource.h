//
//  WPPornSearchesStringSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WPStringSource.h"

@interface WPPornSearchesStringSource : NSObject <WPStringSource>
{
	AFHTTPRequestOperationManager *manager;
	NSMutableArray *searches;
}

@end
