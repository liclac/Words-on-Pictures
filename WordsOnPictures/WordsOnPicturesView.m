//
//  WordsOnPicturesView.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WordsOnPicturesView.h"
#import "WPUnixWordsStringSource.h"
#import "util.h"

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
		loadingLayer.font = CFSTR("Helvetica");
		loadingLayer.fontSize = 50;
		loadingLayer.foregroundColor = [NSColor whiteColor].CGColor;
		loadingLayer.bounds = boundsForString(loadingLayer.string, @"Helvetica", loadingLayer.fontSize);
		loadingLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		loadingLayer.anchorPoint = CGPointMake(0.5, 0.5);
		[self.layer addSublayer:loadingLayer];
		
		// Register Source classes
		[stringSourceClasses addObject:[WPUnixWordsStringSource class]];
		
		// Create Sources
		Class stringSourceClass = [stringSourceClasses objectAtIndex:0];
		stringSource = [[stringSourceClass alloc] init];
		stringSource.delegate = self;
		[stringSource startLoading];
	}
	
	return self;
}

- (void)startAnimation
{
	[super startAnimation];
}

- (void)stopAnimation
{
	[super stopAnimation];
}

/*- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
}*/

- (void)animateOneFrame
{
	return;
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
	CATextLayer *layer = [CATextLayer layer];
	layer.string = [stringSource string];
	layer.font = CFSTR("Helvetica");
	layer.fontSize = SSRandomFloatBetween(10, 40);
	layer.foregroundColor = [[NSColor whiteColor] CGColor];
	layer.bounds = boundsForString(layer.string, @"Helvetica", layer.fontSize);
	layer.position = NSPointToCGPoint(SSRandomPointForSizeWithinRect(NSSizeFromCGSize(layer.bounds.size), self.bounds));
	layer.masksToBounds = NO;
	
	[CATransaction begin];
	[CATransaction setAnimationDuration:SSRandomFloatBetween(1, 2)];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[CATransaction setCompletionBlock:^{
		[layer removeFromSuperlayer];
		[self spawnLayer];
	}];
	{
		layer.opacity = 0.0f;
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animation.fromValue = @1.0f;
		animation.beginTime = CACurrentMediaTime() + SSRandomFloatBetween(0.0, 2);
		[layer addAnimation:animation forKey:@"exitAnimation"];
	}
	[CATransaction commit];
	
	[self.layer addSublayer:layer];
	[textLayers addObject:layer];
	
	NSLog(@"Spawned Layer: %@ (%f, %f)", layer.string, layer.position.x, layer.position.y);
}

- (void)stringSourceDidFinishLoading:(id<WPStringSource>)source
{
	stringSourceReady = YES;
	[loadingLayer removeFromSuperlayer];
	
	maxWordLayers = 10;
	while([textLayers count] <= maxWordLayers)
		[self spawnLayer];
}

- (void)stringSource:(id<WPStringSource>)source didFailLoadingWithError:(NSString *)error
{
	loadingLayer.string = error;
}

@end
