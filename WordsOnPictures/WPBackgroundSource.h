//
//  WPBackgroundSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-05.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPBackgroundSource <NSObject>

@property (weak) id delegate;

+ (NSString *)sourceName;
+ (NSString *)sourceDescription;

- (void)startLoading;
- (NSImage *)image;

@end

@protocol WPBackgroundSourceDelegate <NSObject>

- (void)backgroundSourceDidFinishLoading:(id<WPBackgroundSource>)source;
- (void)backgroundSource:(id<WPBackgroundSource>)source didFailLoadingWithError:(NSString *)error;

@end
