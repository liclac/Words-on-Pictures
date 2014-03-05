//
//  WordsOnPicturesView.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import "WordsOnPicturesView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
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
		
		//[self setAnimationTimeInterval:1/30.0];
		[self setLayer:[CALayer layer]];
		[self setWantsLayer:YES];
		self.layer.opaque = YES;
		self.layer.frame = NSRectToCGRect(self.bounds);
		self.layer.backgroundColor = [[NSColor blackColor] CGColor];
		
		[stringSourceClasses addObject:[WPUnixWordsStringSource class]];
		
		Class stringSourceClass = [stringSourceClasses objectAtIndex:0];
		stringSource = [[stringSourceClass alloc] init];
		
		maxWordLayers = 10;
		while([textLayers count] <= maxWordLayers)
			[self spawnLayer];
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
		[layer addAnimation:animation forKey:@"exitAnimation"];
	}
	[CATransaction commit];
	
	[self.layer addSublayer:layer];
	[textLayers addObject:layer];
	
	NSLog(@"Spawned Layer: %@ (%f, %f)", layer.string, layer.position.x, layer.position.y);
}

@end
