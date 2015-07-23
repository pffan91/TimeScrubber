//
//  TimeScrubberLabel.m
//  ALLIE
//
//  Created by Vladyslav Semecnhenko on 3/4/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import "TimeScrubberLabel.h"

@implementation TimeScrubberLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.font = [UIFont systemFontOfSize:8];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
