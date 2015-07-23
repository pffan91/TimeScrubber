//
//  ViewController.m
//  TimeScrubber
//
//  Created by Vladyslav Semecnhenko on 6/9/15.
//  Copyright (c) 2015 Vladyslav Semecnhenko. All rights reserved.
//

#import "ViewController.h"
#import "TimeScrubber.h"


@interface ViewController ()
{
    TimeScrubber *mTimeScrubber;
    UILabel *mLabelDebugLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int period = 1; // 0 - 24, 1 - 48, 2 - 72
    NSDate *startDate;
    NSDate *endDate;
    
    if (period == 1)
    {
        startDate = [NSDate date];
        endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
    }
    else if (period == 2)
    {
        startDate = [NSDate date];
        endDate = [NSDate dateWithTimeInterval:86400*2 sinceDate:startDate];
    }
    else if (period == 3)
    {
        startDate = [NSDate date];
        endDate = [NSDate dateWithTimeInterval:86400*3 sinceDate:startDate];
    }
    
    mTimeScrubber = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, self.view.bounds.size.height / 2 + 100, self.view.bounds.size.width - 60, 50) withPeriod:period];
    [mTimeScrubber addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mTimeScrubber];
    
    mLabelDebugLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2 - 15, self.view.bounds.size.width, 30)];
    mLabelDebugLabel.textAlignment = NSTextAlignmentCenter;
    mLabelDebugLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:mLabelDebugLabel];
    
    [mTimeScrubber updateEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newValue:(TimeScrubber*)slider
{
    mLabelDebugLabel.text = [NSString stringWithFormat:@"Current selected date = %@", slider.selectedDate];
}

@end
