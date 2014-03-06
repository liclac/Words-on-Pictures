//
//  util.m
//  WordsOnPictures
//
//  Created by Johannes Ekberg on 2014-03-04.
//  Copyright (c) 2014 MacaroniCode. All rights reserved.
//

CGRect boundsForString(NSString *str, NSString *fontName, CGFloat fontSize)
{
	NSFont *font = [NSFont fontWithName:fontName size:fontSize];
	NSAttributedString *attstr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: font}];
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attstr));
	CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(600, CGFLOAT_MAX), NULL);
	
	return CGRectMake(0, 0, size.width, size.height);
}
