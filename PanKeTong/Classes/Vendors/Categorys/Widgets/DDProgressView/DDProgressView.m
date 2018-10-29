//
//  DDProgressView.m
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import "DDProgressView.h"

#define kProgressBarHeight  14.0f
#define kProgressBarWidth	160.0f

@implementation DDProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0.0f)
        frame.size.width = kProgressBarWidth;
    if (frame.size.height == 0.0f)
        frame.size.height = kProgressBarHeight;
	self = [super initWithFrame: frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor] ;
		self.innerColor = [UIColor lightGrayColor] ;
		self.outerColor = [UIColor lightGrayColor] ;
		self.emptyColor = [UIColor clearColor] ;
	}
	return self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor] ;
        self.innerColor = YCThemeColorGreen;
        self.outerColor = [UIColor clearColor];
        self.emptyColor = [UIColor colorWithRed:237.0 / 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1.0f];
    }
    return self;
}

- (void)dealloc
{
    [_innerColor release];
    _innerColor = nil ;
    [_outerColor release];
    _outerColor = nil ;
    [_emptyColor release];
    _emptyColor = nil ;
	
	[super dealloc] ;
}

- (void)setProgress:(float)theProgress {
	// make sure the user does not try to set the progress outside of the bounds
	if (theProgress > 1.0f)
		theProgress = 1.0f ;
	if (theProgress < 0.0f)
		theProgress = 0.0f ;
	
	_progress = theProgress ;
	[self setNeedsDisplay] ;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext() ;
	
	// save the context
	CGContextSaveGState(context) ;
	
	// allow antialiasing
	CGContextSetAllowsAntialiasing(context, TRUE) ;
	
	// we first draw the outter rounded rectangle
	rect = CGRectInset(rect, 1.0f, 1.0f) ;
	CGFloat radius = 0.0f * rect.size.height ;
    
	[_outerColor setStroke] ;
	CGContextSetLineWidth(context, 2.0f) ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextDrawPath(context, kCGPathStroke) ;
    
    // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
    rect = CGRectInset(rect, 3.0f, 3.0f) ;
	radius = 0.0f * rect.size.height ;
	
	[_emptyColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
	// draw the inside moving filled rounded rectangle
	radius = 0.0f * rect.size.height ;
	
	// make sure the filled rounded rectangle is not smaller than 2 times the radius
	rect.size.width *= _progress ;
	if (rect.size.width < 2 * radius)
		rect.size.width = 2 * radius ;
	
	[_innerColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
	
	// restore the context
	CGContextRestoreGState(context) ;
}

@end
