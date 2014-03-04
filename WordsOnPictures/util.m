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
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attstr);
	
	CGFloat ascent, descent, leading;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	
	CFRelease(line);
	
	return CGRectMake(0, descent, ceilf(width), ceilf(ascent + descent));
}
