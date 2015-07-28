//
//  TimeScrubber.m
//  TimeScrubberExample
//
//  Created by Vladyslav Semenchenko on 08/12/14.
//  Copyright (c) 2014 Vladyslav Semenchenko. All rights reserved.
//

#import "TimeScrubber.h"
#import "TimeScrubberControl.h"
#import "TimeScrubberBorder.h"
#import "TimeScrubberLabel.h"
#import "ScrollWithDates.h"
#import "ScrollWithVideoFragments.h"
#import "AMPopTip.h"

#define kUpdateTimerInterval 1

@implementation TimeScrubber
{
    //helper sizes
    float selfHeight;
    float selfWidth;

    // helpers
    BOOL isTouchEnded;
    BOOL isDragging;
    BOOL isLongPressStart;
    BOOL isLongPressedFired;
    
    NSInteger secondsFromGMT;
    
    NSTimer *updateTimer;
    NSTimer *longPressTimer;
    
    ScrollWithDates *scrollWithDate;
    ScrollWithVideoFragments *scrollWithVideo;
    
    AMPopTip *popTip;
    
    NSDate *creationDate;
    
    int segments;
    float oneSegmentTime;
    int masterTimeDifference;
    
    int hoursInInSelectedInterval;
    
    CGPoint currentPoint;
}

#pragma mark Init
- (id)initWithFrame:(CGRect)frame withStartDate:(NSDate *)startDate endDate:(NSDate *)endDate segments:(int)segmentsI andVideoBlocks:(NSMutableArray *)videoBlocks
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        selfHeight = frame.size.height;
        selfWidth = frame.size.width;
        isTouchEnded = NO;
        isDragging = NO;
        
        _minimumValue = 0.0;
        _maximumValue = 24.0;
        _value = 24.0;
        segments = segmentsI;
        masterTimeDifference = fabs(round(endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow));
        
        hoursInInSelectedInterval = masterTimeDifference / 3600;
        
        self.endDateInitial = endDate;
        creationDate = self.endDateInitial;
        
        if (videoBlocks != nil)
        {
            self.mArrayWithVideoFragments = videoBlocks;
        }
        
        self.startDateIntervalInitial = -masterTimeDifference;
        self.endDateIntervalInitial = 0;
        
        int coef = 0;
        
        if (segments / hoursInInSelectedInterval < 1.5) // by 1 hour
        {
            coef = 0;
            oneSegmentTime = masterTimeDifference / segments;
        }
        else if (segments / hoursInInSelectedInterval < 2.5) // by 30 mins
        {
            coef = 1;
            oneSegmentTime = 60 * 30;
        }
        else if (segments / hoursInInSelectedInterval > 2.5) // by 15 mins
        {
            coef = 2;
            oneSegmentTime = 60 * 15;
        }
        
        scrollWithDate = [[ScrollWithDates alloc] initWithFrame:self.bounds startDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial segments:segments oneSegmentTime:oneSegmentTime coefficient:coef];
        scrollWithDate.userInteractionEnabled = NO;
        NSDate *tempDate = [NSDate dateWithTimeInterval:0 sinceDate:self.endDateInitial];
        [scrollWithDate createNewViewWithDate:tempDate isNeedMinutes:YES];
        [self addSubview:scrollWithDate];
        
        scrollWithVideo = [[ScrollWithVideoFragments alloc] initWithFrame:CGRectMake(2.5, 0, self.bounds.size.width - 5, self.bounds.size.height) startDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial];
        scrollWithVideo.userInteractionEnabled = NO;
        scrollWithVideo.clipsToBounds = YES;
        [scrollWithVideo createSubviewsWithVideoFragments:self.mArrayWithVideoFragments];
        [self addSubview:scrollWithVideo];
        
        // compute current date based on self.value
        [self update];
        
        self.thumbControl = [[TimeScrubberControl alloc] initWithFrame:CGRectMake(selfWidth - (selfHeight * 0.7) / 2, selfHeight / 2  - (selfHeight * 0.7) / 2, selfHeight * 0.7, selfHeight * 0.7)];
        self.thumbControlStatic = [[TimeScrubberControl alloc] initWithFrame:CGRectMake(selfWidth - (selfHeight * 0.7) / 2, selfHeight / 2  - (selfHeight * 0.7) / 2, selfHeight * 0.7, selfHeight * 0.7)];
        self.thumbControlStatic.outerColor = [UIColor colorWithRed:0.263 green:0.501 blue:0.935 alpha:1.000];
        self.thumbControlStatic.innerColor = [UIColor whiteColor];
        self.thumbControl.outerColor = [UIColor whiteColor];
        self.thumbControl.innerColor = [UIColor colorWithRed:0.263 green:0.501 blue:0.935 alpha:1.000];
        self.thumbControl.userInteractionEnabled = NO;
        self.thumbControlStatic.userInteractionEnabled = NO;
        self.thumbControlStatic.date = [NSDate date];
        self.thumbControl.date = [NSDate date];
        [self addSubview:self.thumbControl];
//        [self addSubview:self.thumbControlStatic];
        
        popTip = [AMPopTip popTip];
        popTip.popoverColor = [UIColor colorWithRed:0.263 green:0.501 blue:0.935 alpha:1.000];
    }
    
    return self;
}

#pragma mark Drawning
- (void)drawRect:(CGRect)rect
{
    UIColor* color3 = [UIColor whiteColor];
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(rect.origin.x, rect.size.height * 0.5 - 10, rect.size.width, 20)];
    [color3 setFill];
    [rectanglePath fill];
}

#pragma mark User interactions
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    isTouchEnded = NO;
    isDragging = YES;
    isLongPressedFired = NO;
    isLongPressStart = YES;
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateTimerInterval target:self selector:@selector(handleLongPress) userInfo:nil repeats:NO];
    
    CGPoint l = [touch locationInView:self];
    currentPoint = l;
    if ([self markerHitTest:l])
    {
        [self moveRedControl:l];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [popTip showText:[NSString stringWithFormat:@"%@", [NSDate dateWithTimeInterval:self.currentDateIntervalFixed sinceDate:self.endDateInitial]] direction:AMPopTipDirectionUp maxWidth:200 inView:self fromFrame:self.thumbControl.frame];

        return YES;
    } else
    {
        return NO;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    isLongPressStart = NO;
    [longPressTimer invalidate];
    
    CGPoint p = [touch locationInView:self];
    currentPoint = p;
    
    CGRect trackingFrame = self.bounds;
    
    if (!CGRectContainsPoint(trackingFrame, p))
    {
        return NO;
    }
    
    [self moveRedControl:p];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (!isLongPressedFired)
    {
        isLongPressStart = YES;
        longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateTimerInterval target:self selector:@selector(handleLongPress) userInfo:nil repeats:NO];
    }
    
    return YES;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self handleLongPressFinished];
    
    isTouchEnded = YES;
    isDragging = NO;
    
    isLongPressStart = NO;
    isLongPressedFired = NO;
    [longPressTimer invalidate];
    longPressTimer = nil;
    
    [popTip hide];

    [super cancelTrackingWithEvent:event];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isLongPressedFired)
    {
        [self handleLongPressFinished];
    }
    
    isTouchEnded = YES;
    isDragging = NO;
    
    isLongPressStart = NO;
    isLongPressedFired = NO;
    [longPressTimer invalidate];
    longPressTimer = nil;
    
    [popTip hide];
    
    [self updateMarker];

    [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark UI updates from user interactions
- (BOOL)markerHitTest:(CGPoint) point
{
    if (point.x < self.bounds.origin.x || point.x > selfWidth) // x test
    {
        return NO;
    }
    
    return YES;
}

-(void)moveRedControl:(CGPoint)lastPoint
{
    CGRect newFrameForControl = CGRectMake(lastPoint.x - self.thumbControl.frame.size.width / 2, self.thumbControl.frame.origin.y, self.thumbControl.bounds.size.width, self.thumbControl.bounds.size.height);
    self.thumbControl.frame =newFrameForControl;
    
    // update current value
    float oneValuePerPixel = self.maximumValue / selfWidth;
    self.value = lastPoint.x * oneValuePerPixel;
    
    if (lastPoint.x > selfWidth || lastPoint.x < 0)
    {
        
    }
    else
    {
        [self computeCurrentDate];
        
        popTip.fromFrame = self.thumbControl.frame;
    }

    [self setNeedsDisplay];
}

#pragma mark Operations with Date
- (void)computeCurrentDate
{
    if (!isLongPressedFired)
    {
        self.endDateInitial = [NSDate date];
        self.endDateIntervalInitial = self.endDateInitial.timeIntervalSinceNow;
        
        self.startDateIntervalInitial = [[NSDate dateWithTimeInterval:-masterTimeDifference sinceDate:self.endDateInitial] timeIntervalSinceDate:self.endDateInitial];

        float dateDifference = self.endDateIntervalInitial - self.startDateIntervalInitial;
        float onePart = dateDifference / self.maximumValue;
        
        self.currentDateInterval = self.startDateIntervalInitial + (onePart * self.value);
        
        [self getRealCurrentDate];
    }
    else
    {
        float dateDifference = self.endDateIntervalInitial - self.startDateIntervalInitial;
        float onePart = dateDifference / self.maximumValue;
        
        self.currentDateInterval = self.startDateIntervalInitial + (onePart * self.value);
        
        [self getRealCurrentDate];
    }
}

- (NSTimeInterval)getRealCurrentDate
{
    if (!isLongPressedFired)
    {
        secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
        self.currentDateIntervalFixed = self.currentDateInterval + secondsFromGMT;
        
        [popTip updateText:[NSString stringWithFormat:@"%@", [NSDate dateWithTimeInterval:self.currentDateIntervalFixed sinceDate:self.endDateInitial]]];

        self.selectedDate = [NSDate dateWithTimeInterval:self.currentDateIntervalFixed sinceDate:self.endDateInitial];
        
        return self.currentDateIntervalFixed;
    }
    else
    {
        secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
        self.currentDateIntervalFixed = self.currentDateInterval + secondsFromGMT;

        [popTip updateText:[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:self.currentDateInterval + secondsFromGMT]]];
        
        self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:self.currentDateInterval + secondsFromGMT];
        
        return self.currentDateInterval;
    }
}

#pragma mark Updates
- (void)updateEnable:(BOOL)isEnabled
{
    if (isEnabled)
    {
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    else
    {
        [updateTimer invalidate];
        updateTimer = nil;
    }
}

- (void)update
{
    if (!isDragging)
    {
        [self computeCurrentDate];
        
        float datePerPixel = selfWidth / masterTimeDifference;
        [scrollWithDate updateWithOffset:0.25 * datePerPixel];
        [scrollWithVideo updateWithOffset:creationDate.timeIntervalSinceNow];
    }
}

- (void)updateMarker
{
    float dateDifference = self.endDateIntervalInitial - self.startDateIntervalInitial;
    float datePerPixel = selfWidth / dateDifference;
    
    float x1 = self.selectedDate.timeIntervalSinceNow - secondsFromGMT;
    
    float delta = INFINITY;
    
    for (NSDictionary *dict in self.mArrayWithVideoFragments)
    {
        float x22 = [[dict objectForKey:@"2"] floatValue] - fabs(creationDate.timeIntervalSinceNow);
        
        if (fabs(x22) < fabs(x1))
        {
           if (fabs(x1) - fabs(x22) < delta)
           {
               delta = fabs(x1) - fabs(x22);
           }
        }
    }
    
    if (delta == INFINITY)
    {
        delta = 0;
    }

    self.currentDateInterval += delta;
    self.selectedDate = [NSDate dateWithTimeIntervalSinceNow:self.currentDateInterval + secondsFromGMT];

    NSLog(@"Current selected date = %@", self.selectedDate);
    
    float x1dif = x1 + delta - self.startDateIntervalInitial;
    float x1pos = x1dif * datePerPixel;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.thumbControl.frame = CGRectMake(x1pos - self.thumbControl.frame.size.width * 0.5, self.thumbControl.frame.origin.y, self.thumbControl.frame.size.width, self.thumbControl.frame.size.height);
    }];
}

- (void)updateStaticMarker
{
    float endDateInterval = self.endDateIntervalInitial;
    
    if (0 > self.startDateIntervalInitial && 0 < endDateInterval)
    {
        float dateDifference = self.endDateIntervalInitial - self.startDateIntervalInitial;
        float datePerPixel = selfWidth / dateDifference;
        
        float x1 = 0;
        float x1dif = x1 - self.startDateIntervalInitial;
        float x1pos = x1dif * datePerPixel;
        
        [UIView animateWithDuration:0.1 animations:^{
            self.thumbControlStatic.frame = CGRectMake(x1pos - self.thumbControlStatic.frame.size.width * 0.5, self.thumbControlStatic.frame.origin.y, self.thumbControlStatic.frame.size.width, self.thumbControlStatic.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.thumbControlStatic.hidden = YES;
        }];
    }
}

#pragma mark Long press gesture
-(void)handleLongPress
{
    isLongPressedFired = YES;
    
    // stop date update
    [self updateEnable:NO];
    
    // update start end date based on current selected date
    float testDevider = oneSegmentTime / 2;
    
    NSDate *currentDate;
    NSDate *startDate;
        
    if (fabs(self.currentDateInterval) < oneSegmentTime)
    {
        currentDate = [NSDate dateWithTimeInterval:-testDevider sinceDate:[NSDate date]];
        self.endDateInitial = [NSDate date];
        startDate = [NSDate dateWithTimeInterval:-testDevider sinceDate:currentDate];

    }
    else
    {
        currentDate = [NSDate dateWithTimeIntervalSinceNow:self.currentDateInterval];
        self.endDateInitial = [[NSDate alloc] initWithTimeInterval:testDevider sinceDate:currentDate];
        startDate = [NSDate dateWithTimeInterval:-testDevider sinceDate:currentDate];
    }
    
    self.startDateIntervalInitial = startDate.timeIntervalSinceNow;
    self.endDateIntervalInitial = self.endDateInitial.timeIntervalSinceNow;
    
    // update scroll and labels
    [scrollWithVideo updateWithStartDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial andDelta:creationDate.timeIntervalSinceNow];
    [scrollWithVideo createSubviewsWithVideoFragments:self.mArrayWithVideoFragments];
    
    int coef = 0;
    
    if (segments / hoursInInSelectedInterval < 1.5) // by 1 hour
    {
        coef = 0;
        oneSegmentTime = masterTimeDifference / segments;
    }
    else if (segments / hoursInInSelectedInterval < 2.5) // by 30 mins
    {
        coef = 1;
        oneSegmentTime = 60 * 30;
    }
    else if (segments / hoursInInSelectedInterval > 2.5) // by 15 mins
    {
        coef = 2;
        oneSegmentTime = 60 * 15;
    }
    
    [scrollWithDate updateWithStartDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial segments:segments isNeedHours:NO coefficient:coef animateDirection:1 selectedPoint:currentPoint];
    
    NSDate *tempDate = [NSDate dateWithTimeInterval:0 sinceDate:self.endDateInitial];
    [scrollWithDate createNewViewWithDate:tempDate isNeedMinutes:YES];
    
    // update time / hide marker
    [self updateStaticMarker];
    [self update];
    [self updateEnable:NO];
}

-(void)handleLongPressFinished
{
    self.endDateInitial = [NSDate date];
    
    self.startDateIntervalInitial = -masterTimeDifference;
    self.endDateIntervalInitial = 0;
    
    // update scroll and labels
    int coef = 0;
    
    if (segments / hoursInInSelectedInterval < 1.5) // by 1 hour
    {
        coef = 0;
        oneSegmentTime = masterTimeDifference / segments;
    }
    else if (segments / hoursInInSelectedInterval < 2.5) // by 30 mins
    {
        coef = 1;
        oneSegmentTime = 60 * 30;
    }
    else if (segments / hoursInInSelectedInterval > 2.5) // by 15 mins
    {
        coef = 2;
        oneSegmentTime = 60 * 15;
    }
    
    [scrollWithDate updateWithStartDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial segments:segments isNeedHours:YES coefficient:coef animateDirection:0 selectedPoint:currentPoint];
    [scrollWithVideo updateWithStartDate:[NSDate dateWithTimeIntervalSinceNow:self.startDateIntervalInitial] endDate:self.endDateInitial andDelta:creationDate.timeIntervalSinceNow];
    [scrollWithVideo createSubviewsWithVideoFragments:self.mArrayWithVideoFragments];
    
    // update time / move marker
   self.thumbControlStatic.frame = CGRectMake(selfWidth - (selfHeight * 0.7) / 2, selfHeight / 2  - (selfHeight * 0.7) / 2, selfHeight * 0.7, selfHeight * 0.7);
    [UIView animateWithDuration:0.1 animations:^{
        self.thumbControlStatic.hidden = NO;
    }];
    
    NSDate *tempDate = [NSDate dateWithTimeInterval:0 sinceDate:self.endDateInitial];
    [scrollWithDate createNewViewWithDate:tempDate isNeedMinutes:YES];
    
    [self update];
    [self updateEnable:YES];
}

@end
