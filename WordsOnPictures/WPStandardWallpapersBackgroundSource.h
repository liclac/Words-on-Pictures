//
//  WPStandardWallpapersBackgroundSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPBackgroundSource.h"

@interface WPStandardWallpapersBackgroundSource : NSObject <WPBackgroundSource>
{
	NSMutableArray *urls;
}

@end
