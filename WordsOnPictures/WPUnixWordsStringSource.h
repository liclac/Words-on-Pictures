//
//  WPUnixWordsStringSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPStringSource.h"

@interface WPUnixWordsStringSource : NSObject <WPStringSource>
{
	NSArray *words;
}

- (id)init;

@end
