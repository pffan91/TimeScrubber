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

@interface ScrollWithDates ()
{
    NSMutableArray *mArrayWithDates;
    NSMutableArray *mArrayWithViews;
    NSMutableArray *mArrayWithOffset;
    NSMutableArray *mArrayWithFinalDatesStrings;

    NSDate *fixedDate;
    
    int segments;
    float oneSegmentTime;
    BOOL isNeedHoursL;
    float timeDelta;
}

@end

@implementation ScrollWithDates

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate segments:(int)segmentsI oneSegmentTime:(float)oneSegmentTimeI coefficient:(int)coef
{
    self = [super initWithFrame:frame];
    
    if (self)
    {        
        mArrayWithDates = [NSMutableArray array];
        mArrayWithViews = [NSMutableArray array];
        mArrayWithOffset = [NSMutableArray array];
        mArrayWithFinalDatesStrings = [NSMutableArray array];
        
        segments = segmentsI;
        isNeedHoursL = YES;
        self.endDateInitial = endDate;
        self.startDateInitial = startDate;
        self.coefficient = coef;
        oneSegmentTime = oneSegmentTimeI;
        
        fixedDate = [NSDate dateWithTimeInterval:-oneSegmentTime sinceDate:self.endDateInitial];
        
        [self generateStartDates];
    }
    
    return self;
}

- (void)updateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate  segments:(int)segmentsI isNeedHours:(BOOL)isNeedHours coefficient:(int)coef
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
    [mArrayWithOffset removeAllObjects];
    [mArrayWithFinalDatesStrings removeAllObjects];
    
    segments = segmentsI;
    isNeedHoursL = isNeedHours;
    self.endDateInitial = endDate;
    self.startDateInitial = startDate;
    self.coefficient = coef;
    timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;
    
    [self generateStartDates];
}

- (void)generateStartDates
{
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"mm"];

    if (isNeedHoursL)
    {
        for (int i = 1; i < segments; i++)
        {
            if (self.coefficient == 0) // by hours
            {
                float deltaForDate = 0;
                
                NSDate *tempDate = [NSDate dateWithTimeInterval:(self.endDateInitial.timeIntervalSinceNow - oneSegmentTime * i) sinceDate:self.endDateInitial];
                
                NSString *tempString = [dateFormatters stringFromDate:tempDate];
                deltaForDate = 60 * [tempString intValue];
                
                float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
                float datePerPixel = self.bounds.size.width / dateDifference;
                float finalValue = datePerPixel * deltaForDate;
                
                [mArrayWithOffset addObject:[NSNumber numberWithFloat:finalValue]];
                [mArrayWithDates addObject:[NSDate dateWithTimeInterval:-deltaForDate sinceDate:tempDate]];
            }
            else if (self.coefficient == 1)
            {
                float deltaForDate = 0;
                
                NSDate *tempDate = [NSDate dateWithTimeInterval:(self.endDateInitial.timeIntervalSinceNow - oneSegmentTime * i) sinceDate:self.endDateInitial];
                
                NSString *tempString = [dateFormatters stringFromDate:tempDate];
                // get difference 15 mins
                int mins = [tempString intValue];
                float diff = mins % 30;
                
                deltaForDate = 60 * diff;
                
                float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
                float datePerPixel = self.bounds.size.width / dateDifference;
                float finalValue = datePerPixel * deltaForDate;
                
                [mArrayWithOffset addObject:[NSNumber numberWithFloat:finalValue]];
                [mArrayWithDates addObject:[NSDate dateWithTimeInterval:-deltaForDate sinceDate:tempDate]];
            }
            else if (self.coefficient == 2)
            {
                float deltaForDate = 0;
                
                NSDate *tempDate = [NSDate dateWithTimeInterval:(self.endDateInitial.timeIntervalSinceNow - oneSegmentTime * i) sinceDate:self.endDateInitial];
                
                NSString *tempString = [dateFormatters stringFromDate:tempDate];
                // get difference 15 mins
                int mins = [tempString intValue];
                float diff = mins % 15;
                
                deltaForDate = 60 * diff;
                
                float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
                float datePerPixel = self.bounds.size.width / dateDifference;
                float finalValue = datePerPixel * deltaForDate;
                
                [mArrayWithOffset addObject:[NSNumber numberWithFloat:finalValue]];
                [mArrayWithDates addObject:[NSDate dateWithTimeInterval:-deltaForDate sinceDate:tempDate]];
            }
        }
    }
    else
    {
        for (int i = 0; i < segments; i++)
        {
            if (i == 0)
            {
                [mArrayWithDates addObject:self.startDateInitial];
            }
            else if (i == segments-1)
            {
                // pre end date
                [mArrayWithDates addObject:[NSDate dateWithTimeInterval:((timeDelta / segments) * i - 0) sinceDate:self.startDateInitial]];
            }
            else
            {
                [mArrayWithDates addObject:[NSDate dateWithTimeInterval:((timeDelta / segments-1) * i) - 0 sinceDate:self.startDateInitial]];
            }
            
            [mArrayWithOffset addObject:[NSNumber numberWithFloat:0]];
        }
    }
    
    [self createScroll];
}

- (void)createScroll
{
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH:mm"];

    if (isNeedHoursL)
    {
        for (int i = 1; i < segments; i++)
        {
            float deltaForDate = [[mArrayWithOffset objectAtIndex:segments-i-1] floatValue];
            
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / segments) * i - deltaForDate, self.frame.origin.y, 40, self.bounds.size.height)];
            TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
            [masterView addSubview:border];
            TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
            label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:segments-i-1]];
            [masterView addSubview:label];
            
            NSDateFormatter *dateFormattersTest = [[NSDateFormatter alloc] init];
            [dateFormattersTest setDateFormat:@"HH"];
            NSString *tempString = [dateFormattersTest stringFromDate:[mArrayWithDates objectAtIndex:segments-i-1]];
            
            [mArrayWithFinalDatesStrings addObject:tempString];
            [self addSubview:masterView];
            [mArrayWithViews addObject:masterView];
        }
    }
    else
    {
        for (int i = 0; i < segments; i++)
        {
            float deltaForDate = [[mArrayWithOffset objectAtIndex:i] floatValue];
            
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / segments) * i - deltaForDate, self.frame.origin.y, 40, self.bounds.size.height)];
            TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
            [masterView addSubview:border];
            TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
            label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:i]];
            [masterView addSubview:label];
            
            NSDateFormatter *dateFormattersTest = [[NSDateFormatter alloc] init];
            [dateFormattersTest setDateFormat:@"HH"];
            NSString *tempString = [dateFormattersTest stringFromDate:[mArrayWithDates objectAtIndex:i]];
            
            [mArrayWithFinalDatesStrings addObject:tempString];
            [self addSubview:masterView];
            [mArrayWithViews addObject:masterView];
        }
    }
}

- (void)createNewViewWithDate:(NSDate *)date;
{
    NSString *lastDateString = [mArrayWithFinalDatesStrings lastObject];
    
    NSDateFormatter *dateFormattersTest = [[NSDateFormatter alloc] init];
    [dateFormattersTest setDateFormat:@"HH"];
    
    NSString *tempString = [dateFormattersTest stringFromDate:date];
    
    if ([lastDateString isEqualToString:tempString] && isNeedHoursL)
    {
        return;
    }
    
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
    NSTimeInterval dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow + 2; // 2 - correction
    float datePerPixel = self.bounds.size.width / dateDifference;
    
    for (UIView *view in mArrayWithViews)
    {
        view.center = CGPointMake(view.center.x - datePerPixel, view.center.y);
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
