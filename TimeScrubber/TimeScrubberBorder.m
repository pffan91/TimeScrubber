//
//  TimeScrubberBorder.m
//  ALLIE
//
//  Created by Vladyslav Semecnhenko on 3/4/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import "TimeScrubberBorder.h"

@implementation TimeScrubberBorder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIColor* color = [UIColor whiteColor];

        self.backgroundColor = color;
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

@end
