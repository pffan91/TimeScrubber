//
//  ScrollWithDates.m
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/9/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//


#import "ScrollWithDates.h"
#import "TimeScrubberBorder.h"
#import "TimeScrubberLabel.h"

#define kSections 12

@interface ScrollWithDates ()
{
    NSMutableArray *mArrayWithDates;
    NSMutableArray *mArrayWithViews;
    float timeDelta;
    
    BOOL isNeedHoursL;
}

@end

@implementation ScrollWithDates

- (id)initWithFrame:(CGRect)frame period:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {        
        mArrayWithDates = [NSMutableArray array];
        mArrayWithViews = [NSMutableArray array];
        
        self.period = period;
        isNeedHoursL = YES;
        self.startDateInitial = startDate;
        self.endDateInitial = endDate;
        timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;
        
        [self generateStartDates];
    }
    
    return self;
}

- (void)updateWithPeriod:(int)period startDate:(NSDate *)startDate endDate:(NSDate *)endDate isNeedHours:(BOOL)isNeedHours
{
    for (UIView *view in mArrayWithViews)
    {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished)
            {
                [view removeFromSuperview];
            }
        }];
    }
    
    [mArrayWithDates removeAllObjects];
    [mArrayWithViews removeAllObjects];
    
    self.period = period;
    isNeedHoursL = isNeedHours;
    self.startDateInitial = startDate;
    self.endDateInitial = endDate;
    timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;

    [self generateStartDates];
}

- (void)generateStartDates
{
    float deltaForDate = 0;
    
    if (isNeedHoursL)
    {
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        [dateFormatters setDateFormat:@"mm"];
        NSString *tempString = [dateFormatters stringFromDate:self.endDateInitial];
        
        deltaForDate = 60 * [tempString intValue];
    }

    for (int i = 0; i < kSections; i++)
    {
        if (i == 0)
        {
            [mArrayWithDates addObject:self.startDateInitial];
        }
        else if (i == kSections-1)
        {
            // pre end date
            [mArrayWithDates addObject:[NSDate dateWithTimeInterval:((timeDelta / kSections) * i - deltaForDate) sinceDate:self.startDateInitial]];
        }
        else
        {
            [mArrayWithDates addObject:[NSDate dateWithTimeInterval:((timeDelta / kSections-1) * i) - deltaForDate sinceDate:self.startDateInitial]];
        }
    }
    
    [self createScroll];
}

- (void)createScroll
{
    float deltaForDate = 0;
    float finalValue = 0;
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH:mm"];
    
    if (isNeedHoursL)
    {
        NSDateFormatter *dateFormatters2 = [[NSDateFormatter alloc] init];
        [dateFormatters2 setDateFormat:@"mm"];
        
        NSString *tempString = [dateFormatters2 stringFromDate:self.endDateInitial];
        
        deltaForDate = 60 * [tempString intValue];
        
        float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
        float datePerPixel = self.bounds.size.width / dateDifference;
        finalValue = datePerPixel * deltaForDate;
    }


    for (int i = 0; i < kSections; i++)
    {
        if (i == 0)
        {
            if (deltaForDate < 60)
            {
                UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 40, self.bounds.size.height)];
                TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
                [masterView addSubview:border];
                TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
                label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:i]];
                [masterView addSubview:label];
                
                [self addSubview:masterView];
                [mArrayWithViews addObject:masterView];
            }
        }
        else if (i == kSections-1)
        {
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / kSections) * i - finalValue, self.frame.origin.y, 40, self.bounds.size.height)];
            masterView.alpha = 1.0;
            TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
            [masterView addSubview:border];
            TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
            label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:i]];
            [masterView addSubview:label];
            
            [self addSubview:masterView];
            [mArrayWithViews addObject:masterView];
        }
        else
        {
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / kSections) * i - finalValue, self.frame.origin.y, 40, self.bounds.size.height)];
            TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
            [masterView addSubview:border];
            TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
            label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:i]];
            [masterView addSubview:label];
            
            [self addSubview:masterView];
            [mArrayWithViews addObject:masterView];
        }
    }
}

- (void)createNewViewWithDate:(NSDate *)date;
{
    float deltaForDate = 0;
    float finalValue = 0;
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH"];
    
    if (isNeedHoursL)
    {
        NSDateFormatter *dateFormatters2 = [[NSDateFormatter alloc] init];
        [dateFormatters2 setDateFormat:@"mm"];
        
        NSString *tempString = [dateFormatters2 stringFromDate:self.endDateInitial];
        
        deltaForDate = 60 * [tempString intValue];
        
        float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
        float datePerPixel = self.bounds.size.width / dateDifference;
        finalValue = datePerPixel * deltaForDate;
    }

    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 2.5 - finalValue, self.frame.origin.y, 40, self.bounds.size.height)];
    masterView.alpha = 0.0;
    TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
    [masterView addSubview:border];
    TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
    
    if (isNeedHoursL)
    {
        [dateFormatters setDateFormat:@"HH"];
        label.text = [NSString stringWithFormat:@"%@:00",[dateFormatters stringFromDate:date]];
    }
    else
    {
        [dateFormatters setDateFormat:@"HH:mm"];
        label.text = [dateFormatters stringFromDate:date];
    }
    
    [masterView addSubview:label];
    
    [self addSubview:masterView];
    [mArrayWithViews addObject:masterView];

    [UIView animateWithDuration:1.0 animations:^{
        masterView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)updateWithOffset:(float)offset
{
    for (UIView *view in mArrayWithViews)
    {
        view.center = CGPointMake(view.center.x -offset, view.center.y);
        [self hitTest:view];
    }
}

- (void)hitTest:(UIView *)view
{
    CGPoint p = view.center;
    
    CGRect trackingFrame = CGRectMake(-10, 0, 25 , self.bounds.size.height);
    
    if (CGRectContainsPoint(trackingFrame, p))
    {
        [UIView animateWithDuration:1.0 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (!finished)
            {
                [view removeFromSuperview];
            }
        }];
    }
}

@end
