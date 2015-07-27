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
    
    int segments;
    float oneSegmentTime;
    BOOL isNeedHoursL;
    int timeDelta;
    int correctedSegments;
    
    int count;
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
        timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;

        correctedSegments = (timeDelta) / oneSegmentTime;
        
        count = 0;
        
        [self generateStartDates];
    }
    
    return self;
}

- (void)updateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate segments:(int)segmentsI isNeedHours:(BOOL)isNeedHours coefficient:(int)coef
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
    
    correctedSegments = timeDelta / oneSegmentTime;

    [self generateStartDates];
}

- (void)generateStartDates
{
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"mm"];

    if (isNeedHoursL)
    {
        for (int i = 1; i <= correctedSegments; i++)
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
        for (int i = 1; i <= correctedSegments; i++)
        {
            float deltaForDate = [[mArrayWithOffset objectAtIndex:correctedSegments-i] floatValue];
            
            UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width / (correctedSegments+1)) * i - deltaForDate, self.frame.origin.y, 40, self.bounds.size.height)];
            TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
            [masterView addSubview:border];
            TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
            label.text = [dateFormatters stringFromDate:[mArrayWithDates objectAtIndex:correctedSegments-i]];
            [masterView addSubview:label];
            
            NSDateFormatter *dateFormattersTest = [[NSDateFormatter alloc] init];
            [dateFormattersTest setDateFormat:@"HH"];
            NSString *tempString = [dateFormattersTest stringFromDate:[mArrayWithDates objectAtIndex:correctedSegments-i]];
            
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
    
//    if (oneSegmentTime > 3500)
//    {
//        [self createNewViewWithDate:[NSDate date] isNeedMinutes:NO];
//    }
//    else
//    {
//        [self createNewViewWithDate:[NSDate date] isNeedMinutes:YES];
//    }
}

- (void)createNewViewWithDate:(NSDate *)date isNeedMinutes:(BOOL)isNeedMinutes
{
    float finalValue = 0;
    NSDate *finalDate;
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"HH"];
    
    if (isNeedHoursL)
    {
        NSDateFormatter *dateFormatters2 = [[NSDateFormatter alloc] init];
        [dateFormatters2 setDateFormat:@"mm"];
        
        if (self.coefficient == 0) // by hours
        {
            float deltaForDate = 0;
            
//            NSDate *tempDate = [NSDate dateWithTimeInterval:(self.endDateInitial.timeIntervalSinceNow - oneSegmentTime) sinceDate:self.endDateInitial];
            
            NSString *tempString = [dateFormatters2 stringFromDate:date];
            deltaForDate = 60 * [tempString intValue];
            count = deltaForDate;
            
            float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
            float datePerPixel = self.bounds.size.width / dateDifference;
            finalValue = datePerPixel * deltaForDate;
            
            finalDate = [NSDate dateWithTimeInterval:-deltaForDate sinceDate:date];
        }
        else if (self.coefficient == 1)
        {
            float deltaForDate = 0;
            
//            NSDate *tempDate = [NSDate dateWithTimeInterval:(self.endDateInitial.timeIntervalSinceNow - oneSegmentTime) sinceDate:self.endDateInitial];
            
            NSString *tempString = [dateFormatters2 stringFromDate:date];
            // get difference 30 mins
            int mins = [tempString intValue];
            float diff = mins % 30;
            
            deltaForDate = 60 * diff;
            count = deltaForDate;

            float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
            float datePerPixel = self.bounds.size.width / dateDifference;
            finalValue = datePerPixel * deltaForDate;
            
            finalDate = [NSDate dateWithTimeInterval:-deltaForDate sinceDate:date];
        }
        else if (self.coefficient == 2)
        {
            float deltaForDate = 0;
                        
            NSString *tempString = [dateFormatters2 stringFromDate:date];
            // get difference 15 mins
            int mins = [tempString intValue];
            float diff = mins % 15;
            
            deltaForDate = 60 * diff;
            count = deltaForDate;

            float dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
            float datePerPixel = self.bounds.size.width / dateDifference;
            finalValue = datePerPixel * deltaForDate;
            
            finalDate = [NSDate dateWithTimeInterval:-deltaForDate sinceDate:date];
        }
    }

    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 2.5 - finalValue, self.frame.origin.y, 40, self.bounds.size.height)];
    masterView.alpha = 0.0;
    TimeScrubberBorder *border = [[TimeScrubberBorder alloc] initWithFrame:CGRectMake(0, 20, 2.5, self.frame.size.height / 2)];
    [masterView addSubview:border];
    TimeScrubberLabel *label = [[TimeScrubberLabel alloc] initWithFrame:CGRectMake(0 - 20, 40, 40, 20)];
    
    if (isNeedHoursL)
    {
        if (isNeedMinutes)
        {
            [dateFormatters setDateFormat:@"HH:mm"];
            label.text = [dateFormatters stringFromDate:finalDate];
        }
        else
        {
            [dateFormatters setDateFormat:@"HH"];
            label.text = [NSString stringWithFormat:@"%@:00",[dateFormatters stringFromDate:finalDate]];
        }
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
    count++;
    
//    NSLog(@"Count = %d", count);
    
    if (count == oneSegmentTime)
    {
        if (oneSegmentTime > 3500)
        {
            [self createNewViewWithDate:[NSDate date] isNeedMinutes:NO];
        }
        else
        {
            [self createNewViewWithDate:[NSDate date] isNeedMinutes:YES];
        }
    }
    
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
