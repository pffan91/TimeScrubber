//
//  TimeScrubber.h
//  TimeScrubberExample
//
//  Created by Vladyslav Semenchenko on 08/12/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScrubberControl.h"

@interface TimeScrubber : UIControl <UIGestureRecognizerDelegate>

// contains the current value (must be time), maybe some function that transforms value to time
@property (nonatomic, assign) CGFloat value;

// the minimum value of the knob. Defaults to 0.
@property (nonatomic, assign) float minimumValue;

// the maximum value of the knob. Defaults to 24.
@property (nonatomic, assign) float maximumValue;

// time stamp - 1 = 24h, 2 - 48h, 3 - 72m, 4 - custom
@property (nonatomic, assign) int period;

// dates
@property (nonatomic) NSTimeInterval endDateIntervalInitial;
@property (nonatomic) NSTimeInterval startDateIntervalInitial;
@property (nonatomic) NSTimeInterval currentDateInterval;
@property (nonatomic) NSTimeInterval currentDateIntervalFixed;
@property (nonatomic) NSDate *endDateInitial;
@property (nonatomic) TimeScrubberControl *thumbControl;
@property (nonatomic) TimeScrubberControl *thumbControlStatic;
@property (nonatomic) NSMutableArray *mArrayWithVideoFragments;
@property (nonatomic) BOOL isCameraOnline;
@property (nonatomic) NSDate *selectedDate;

// custom init
- (id)initWithFrame:(CGRect)frame withPeriod:(int)period;

// get real data (needed for server)
- (NSTimeInterval)getRealCurrentDate;

- (void)updateEnable:(BOOL)isEnabled;

@end
