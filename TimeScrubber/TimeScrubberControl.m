//
//  TimeScrubberControlView.m
//  TimeScrubberExample
//
//  Created by Vladyslav Semenchenko on 08/12/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "TimeScrubberControl.h"

@implementation TimeScrubberControl
{
    float selfHeight;
    float selfWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        selfHeight = frame.size.height;
        selfWidth = frame.size.width;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor* color = self.outerColor;
    UIColor* color2 = self.innerColor;
    
    UIColor* shadow = UIColor.blackColor;
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 2;
    UIColor* shadow2 = UIColor.blackColor;
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 1;
    
    //// Oval 1 Drawin
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 10, rect.size.height - 10)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
    [color setFill];
    [ovalPath fill];
    CGContextRestoreGState(context);
    
    //// Oval 2 Drawing
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(rect.origin.x + 11, rect.origin.y + 11, rect.size.width - 22, rect.size.height - 22)];
    [color2 setFill];
    [oval2Path fill];
    
    CGContextSaveGState(context);
    UIRectClip(oval2Path.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([shadow2 CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [shadow2 colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [oval2Path fill];
        
        CGContextEndTransparencyLayer(context);
    }
    
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
}

@end
