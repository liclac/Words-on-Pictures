//
//  WPStringSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPStringSource <NSObject>

@property (weak) id delegate;

+ (NSString *)sourceName;
+ (NSString *)sourceDescription;

- (void)startLoading;
- (NSString *)string;

@end

@protocol WPStringSourceDelegate <NSObject>

- (void)stringSourceDidFinishLoading:(id<WPStringSource>)source;
- (void)stringSource:(id<WPStringSource>)source didFailLoadingWithError:(NSString *)error;

@end
