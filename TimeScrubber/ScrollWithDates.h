//
//  ScrollWithDates.h
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/9/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollWithDates : UIView

@property (nonatomic) int period;
@property (nonatomic) NSDate *startDateInitial;
@property (nonatomic) NSDate *endDateInitial;

- (id)initWithFrame:(CGRect)frame period:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (void)updateWithPeriod:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate isNeedHours:(BOOL)isNeedHours;

- (void)updateWithOffset:(float)offset;

- (void)createNewViewWithDate:(NSDate *)date;

@end
