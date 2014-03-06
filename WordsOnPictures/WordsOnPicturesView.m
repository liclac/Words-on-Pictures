//
//  WordsOnPicturesView.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WordsOnPicturesView.h"
#import "WPUnixWordsStringSource.h"
#import "WPHorseEbooksStringSource.h"
#import "WPPornSearchesStringSource.h"
#import "WPStandardWallpapersBackgroundSource.h"
#import "WPWallbaseBackgroundSource.h"
#import "util.h"

#define kFontName "Helvetica-Bold"

@implementation WordsOnPicturesView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	if((self = [super initWithFrame:frame isPreview:isPreview]))
	{
		stringSourceClasses = [[NSMutableArray alloc] init];
		backgroundSourceClasses = [[NSMutableArray alloc] init];
		textLayers = [[NSMutableArray alloc] init];
		
		// Setup Host Layer
		// Note that -[setLayer:] must be called before -[setWantsLayer:], otherwise we end up
		// with a layer-backed view instead of a layer-hosting view
		[self setLayer:[CALayer layer]];
		[self setWantsLayer:YES];
		self.layer.opaque = YES;
		self.layer.frame = NSRectToCGRect(self.bounds);
		self.layer.backgroundColor = [[NSColor blackColor] CGColor];
		
		// Setup Loading Layer
		loadingLayer = [CATextLayer layer];
		loadingLayer.string = @"Loading...";
		loadingLayer.font = CFSTR(kFontName);
		loadingLayer.fontSize = 36;
		loadingLayer.foregroundColor = [NSColor whiteColor].CGColor;
		loadingLayer.bounds = boundsForString(loadingLayer.string, @kFontName, loadingLayer.fontSize);
		loadingLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		loadingLayer.anchorPoint = CGPointMake(0.5, 0.5);
		[self.layer addSublayer:loadingLayer];
		
		// Setup Background Layer
		backgroundLayer = [CALayer layer];
		backgroundLayer.position = CGPointMake(0, 0);
		backgroundLayer.anchorPoint = CGPointMake(0, 0);
		backgroundLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		backgroundLayer.contentsGravity = kCAGravityResizeAspectFill;
		[self.layer addSublayer:backgroundLayer];
		
		// Register Source classes
		[stringSourceClasses addObject:[WPUnixWordsStringSource class]];
		[stringSourceClasses addObject:[WPPornSearchesStringSource class]];
		[stringSourceClasses addObject:[WPHorseEbooksStringSource class]];
		
		[backgroundSourceClasses addObject:[WPStandardWallpapersBackgroundSource class]];
		[backgroundSourceClasses addObject:[WPWallbaseBackgroundSource class]];
		
		// Create Sources
		Class stringSourceClass = [stringSourceClasses lastObject];
		stringSource = [[stringSourceClass alloc] init];
		stringSource.delegate = self;
		
		Class backgroundSourceClass = [backgroundSourceClasses lastObject];
		backgroundSource = [[backgroundSourceClass alloc] init];
		backgroundSource.delegate = self;
	}
	
	return self;
}

- (void)startAnimation
{
	[super startAnimation];
	
	[stringSource startLoading];
	[backgroundSource startLoading];
}

- (void)stopAnimation
{
	[super stopAnimation];
}

- (BOOL)hasConfigureSheet
{
	return NO;
}

- (NSWindow*)configureSheet
{
	return nil;
}

- (void)spawnLayer
{
	NSString *string = [stringSource string];
	if(!string) return;
	
	CATextLayer *layer = [CATextLayer layer];
	layer.string = string;
	layer.font = CFSTR(kFontName);
	layer.fontSize = SSRandomFloatBetween(20, 40);
	layer.foregroundColor = [[NSColor whiteColor] CGColor];
	layer.shadowColor = [[NSColor blackColor] CGColor];
	layer.shadowOpacity = 1;
	layer.shadowRadius = 2;
	layer.shadowOffset = CGSizeMake(1, -1);
	layer.bounds = CGRectIntegral(boundsForString(layer.string, @kFontName, layer.fontSize));
	layer.anchorPoint = CGPointMake(0, 0);
	layer.position = NSPointToCGPoint(SSRandomPointForSizeWithinRect(NSSizeFromCGSize(layer.bounds.size), self.bounds));
	layer.masksToBounds = NO;
	layer.shouldRasterize = YES;
	
	[CATransaction begin];
	[CATransaction setAnimationDuration:([layer.string length]*0.1) + 0.5];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[CATransaction setCompletionBlock:^{
		[layer removeFromSuperlayer];
		[self spawnLayer];
	}];
	{
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.toValue = @0.0f;
		animation.beginTime = CACurrentMediaTime() + SSRandomFloatBetween(0.0, 1);
		[layer addAnimation:animation forKey:@"exitAnimation"];
	}
	[CATransaction commit];
	
	[self.layer addSublayer:layer];
	[textLayers addObject:layer];
	
	//NSLog(@"Spawned Layer: %@ (%f, %f)", layer.string, layer.position.x, layer.position.y);
}

- (void)stringSourceDidFinishLoading:(id<WPStringSource>)source
{
	stringSourceReady = YES;
	[loadingLayer removeFromSuperlayer];
	
	maxWordLayers = ceilf(MIN(self.frame.size.height, self.frame.size.width)/1000.0) * 5;
	while([textLayers count] <= maxWordLayers)
		[self spawnLayer];
}

- (void)stringSource:(id<WPStringSource>)source didFailLoadingWithError:(NSString *)error
{
	loadingLayer.string = error;
	loadingLayer.bounds = boundsForString(loadingLayer.string, @kFontName, loadingLayer.fontSize);
}

- (void)backgroundSourceDidFinishLoading:(id<WPBackgroundSource>)source
{
	backgroundSourceReady = YES;
	[backgroundSource loadImage];
}

- (void)backgroundSource:(id<WPBackgroundSource>)source didFailLoadingWithError:(NSString *)error
{
	loadingLayer.string = error;
	loadingLayer.bounds = boundsForString(loadingLayer.string, @kFontName, loadingLayer.fontSize);
}

- (void)backgroundSource:(id<WPBackgroundSource>)source didLoadImage:(NSImage *)image
{
	[CATransaction begin];
	[CATransaction setAnimationDuration:1];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	{
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.fromValue = @0.0f;
		animation.toValue = @1.0f;
		[backgroundLayer addAnimation:animation forKey:@"fadeAnimation"];
		
		backgroundLayer.contents = image;
	}
	[CATransaction commit];
}

- (void)backgroundSource:(id<WPBackgroundSource>)source didFailToLoadImageWithError:(NSString *)error
{
	loadingLayer.string = error;
	loadingLayer.bounds = boundsForString(loadingLayer.string, @kFontName, loadingLayer.fontSize);
}

@end
