//
//  WordsOnPicturesView.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "WPStringSource.h"
#import "WPBackgroundSource.h"

@interface WordsOnPicturesView : ScreenSaverView <WPStringSourceDelegate, WPBackgroundSourceDelegate>
{
	NSMutableArray *stringSourceClasses, *backgroundSourceClasses;
	
	id<WPStringSource> stringSource;
	id<WPBackgroundSource> backgroundSource;
	BOOL stringSourceReady, backgroundSourceReady;
	
	CATextLayer *loadingLayer;
	NSMutableArray *textLayers;
	
	unsigned int maxWordLayers;
}

- (void)spawnLayer;

@end
