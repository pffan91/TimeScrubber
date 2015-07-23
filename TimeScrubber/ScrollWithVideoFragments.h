//
//  ScrollWithVideoFragments.h
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/10/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollWithVideoFragments : UIView

@property (nonatomic) int period;
@property (nonatomic) NSDate *startDateInitial;
@property (nonatomic) NSDate *endDateInitial;

- (id)initWithFrame:(CGRect)frame period:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (void)updateWithPeriod:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate andDelta:(NSTimeInterval)delta;

- (void)updateWithOffset:(float)offset;

- (void)createSubviewsWithVideoFragments:(NSMutableArray *)videoFragments;
- (void)createSubviewsWithVideoFragments:(NSMutableArray *)videoFragments cleanup:(BOOL)cleanup;

@end
