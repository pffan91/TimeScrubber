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

// dates
@property (nonatomic) NSTimeInterval endDateIntervalInitial;
@property (nonatomic) NSTimeInterval startDateIntervalInitial;
@property (nonatomic) NSTimeInterval currentDateInterval;
@property (nonatomic) NSTimeInterval currentDateIntervalFixed;
@property (nonatomic) NSDate *endDateInitial;
@property (nonatomic) TimeScrubberControl *thumbControl;
@property (nonatomic) TimeScrubberControl *thumbControlStatic;
@property (nonatomic) NSMutableArray *mArrayWithVideoFragments;
@property (nonatomic) BOOL isCameraOnline; // for other functionality
@property (nonatomic) NSDate *selectedDate;

// custom init
- (id)initWithFrame:(CGRect)frame withStartDate:(NSDate *)startDate endDate:(NSDate *)endDate segments:(int)segmentsI andVideoBlocks:(NSMutableArray *)videoBlocks;
- (id)initInOfflineModeWithRect:(CGRect)frame;
- (void)updateOfflinePresentation;

// get real data (needed for server)
- (NSTimeInterval)getRealCurrentDate;

// update enable
- (void)updateEnable:(BOOL)isEnabled;

@end
