//
//  WPStringSource.h
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPStringSource <NSObject>

+ (NSString *)sourceName;
+ (NSString *)sourceDescription;

- (NSString *)string;

@end
