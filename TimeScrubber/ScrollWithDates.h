//
//  ScrollWithDates.h
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/9/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollWithDates : UIView

@property (nonatomic) NSDate *startDateInitial;
@property (nonatomic) NSDate *endDateInitial;
@property (nonatomic) int coefficient;

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate segments:(int)segmentsI oneSegmentTime:(float)oneSegmentTimeI coefficient:(int)coef;

- (void)updateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate  segments:(int)segmentsI isNeedHours:(BOOL)isNeedHours coefficient:(int)coef animateDirection:(int)direction selectedPoint:(CGPoint)selectedPoint;

- (void)updateWithOffset:(float)offset;

- (void)createNewViewWithDate:(NSDate *)date isNeedMinutes:(BOOL)isNeedMinutes;

@end
