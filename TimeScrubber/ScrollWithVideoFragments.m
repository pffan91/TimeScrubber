//
//  ScrollWithVideoFragments.m
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/10/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import "ScrollWithVideoFragments.h"
#import "GlobalDefines.h"

@interface ScrollWithVideoFragments ()
{
    NSMutableArray *mArrayWithDates;
    NSMutableArray *mArrayWithViews;
    
    float timeDelta;
    float deltaFromScrubber;
}

@end

@implementation ScrollWithVideoFragments

- (id)initWithFrame:(CGRect)frame startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        mArrayWithDates = [NSMutableArray array];
        mArrayWithViews = [NSMutableArray array];
        
        self.startDateInitial = startDate;
        self.endDateInitial = endDate;
        
        timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;
        deltaFromScrubber = 0;
    }
    
    return self;
}

- (void)updateWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate andDelta:(NSTimeInterval)delta
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
    
    self.startDateInitial = startDate;
    self.endDateInitial = endDate;
    
    timeDelta = endDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow;
    deltaFromScrubber = delta;
}

- (void)createSubviewsWithVideoFragments:(NSMutableArray *)videoFragments
{
    NSTimeInterval dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow;
    float datePerPixel = self.bounds.size.width / dateDifference;
    
    for (NSDictionary *dict in videoFragments)
    {
        // calculate position
        float x1 = [[dict objectForKey:@"1"] floatValue] - fabsf(deltaFromScrubber);
        float x2 = [[dict objectForKey:@"2"] floatValue] - fabsf(deltaFromScrubber);
        
        float x1dif = x1 - self.startDateInitial.timeIntervalSinceNow;
        float x2dif = x2 - self.startDateInitial.timeIntervalSinceNow;
        
        float x1pos = x1dif * datePerPixel - (fabsf((deltaFromScrubber) * datePerPixel));
        float x2pos = x2dif * datePerPixel - (fabsf((deltaFromScrubber) * datePerPixel));
        
        // add new view - available region
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x1pos, self.bounds.size.height - 32.5, x2pos - x1pos, 15)];
        view.backgroundColor = [UIColor colorWithWhite:0.876 alpha:1.000];
        view.alpha = 0.0;
        view.userInteractionEnabled = NO;
        [self insertSubview:view atIndex:0];
        
        [mArrayWithViews addObject:view];
        
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 1.0;
        }];
    }
}

// not used
- (void)createSubviewsWithVideoFragments:(NSMutableArray *)videoFragments cleanup:(BOOL)cleanup
{
    
}

- (void)updateWithOffset:(float)offset
{
    NSTimeInterval dateDifference = self.endDateInitial.timeIntervalSinceNow - self.startDateInitial.timeIntervalSinceNow + 2; // 2 - correction
    float datePerPixel = self.bounds.size.width / dateDifference;
    
    for (UIView *view in mArrayWithViews)
    {
        view.center = CGPointMake(view.center.x - datePerPixel, view.center.y);
    }
}

- (void)hitTest:(UIView *)view
{
    CGPoint p = view.center;
    
    CGRect trackingFrame = CGRectMake(-10, 0, 25 , self.bounds.size.height);
    
    if (CGRectContainsPoint(trackingFrame, p))
    {
        [UIView animateWithDuration:1.0 animations:^{
            //
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
