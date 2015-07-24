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
    TimeScrubber *mTimeScrubber1;
    TimeScrubber *mTimeScrubber2;
    TimeScrubber *mTimeScrubber3;
    TimeScrubber *mTimeScrubber4;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDate *startDate1;
    NSDate *endDate1;

    NSDictionary *d1 = @{@"1" : @"0", @"2" : @"-3600"}; // 1h
    NSDictionary *d2 = @{@"1" : @"-72000", @"2" : @"-79200"}; // 2h
    NSMutableArray *sampleArrayWithBlocks1 = [NSMutableArray arrayWithObjects:d1, d2, nil];

    endDate1 = [NSDate date];
    startDate1 = [NSDate dateWithTimeInterval:-(3600 * 24) sinceDate:endDate1]; // one day
    
    mTimeScrubber1 = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width - 60, 50) withStartDate:startDate1 endDate:endDate1 segments:12 andVideoBlocks:sampleArrayWithBlocks1];
//    [mTimeScrubber1 addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mTimeScrubber1];
    [mTimeScrubber1 updateEnable:YES];
    
    // 2
    NSDate *startDate2;
    NSDate *endDate2;
    
    NSDictionary *d3 = @{@"1" : @"0", @"2" : @"-3600"}; // 1h
    NSDictionary *d4 = @{@"1" : @"-72000", @"2" : @"-79200"}; // 2h
    NSMutableArray *sampleArrayWithBlocks2 = [NSMutableArray arrayWithObjects:d3, d4, nil];
    
    endDate2 = [NSDate date];
    startDate2 = [NSDate dateWithTimeInterval:-(3600 * 48) sinceDate:endDate2]; // two days
    
    mTimeScrubber2 = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, 300, self.view.bounds.size.width - 60, 50) withStartDate:startDate2 endDate:endDate2 segments:12 andVideoBlocks:sampleArrayWithBlocks2];
    [self.view addSubview:mTimeScrubber2];
    [mTimeScrubber2 updateEnable:YES];
    
    // 3
    NSDate *startDate3;
    NSDate *endDate3;
    
    NSDictionary *d5 = @{@"1" : @"0", @"2" : @"-3600"}; // 1h
    NSDictionary *d6 = @{@"1" : @"-72000", @"2" : @"-79200"}; // 2h
    NSMutableArray *sampleArrayWithBlocks3 = [NSMutableArray arrayWithObjects:d5, d6, nil];
    
    endDate3 = [NSDate date];
    startDate3 = [NSDate dateWithTimeInterval:-(3600 * 72) sinceDate:endDate3]; // three days
    
    mTimeScrubber3 = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, 400, self.view.bounds.size.width - 60, 50) withStartDate:startDate3 endDate:endDate3 segments:12 andVideoBlocks:sampleArrayWithBlocks3];
    [self.view addSubview:mTimeScrubber3];
    [mTimeScrubber3 updateEnable:YES];
    
    // 4
    NSDate *startDate4;
    NSDate *endDate4;
    
    NSDictionary *d7 = @{@"1" : @"0", @"2" : @"-3600"}; // 1h
    NSDictionary *d8 = @{@"1" : @"-72000", @"2" : @"-79200"}; // 2h
    NSMutableArray *sampleArrayWithBlocks4 = [NSMutableArray arrayWithObjects:d7, d8, nil];
    
    endDate4 = [NSDate date];
    startDate4 = [NSDate dateWithTimeInterval:-(3600 * 5) sinceDate:endDate4]; // custom 2h
    
    mTimeScrubber4 = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, 500, self.view.bounds.size.width - 60, 50) withStartDate:startDate4 endDate:endDate4 segments:12 andVideoBlocks:sampleArrayWithBlocks4];
    [self.view addSubview:mTimeScrubber4];
    [mTimeScrubber4 updateEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)newValue:(TimeScrubber*)slider
//{
//    mLabelDebugLabel.text = [NSString stringWithFormat:@"Current selected date = %@", slider.selectedDate];
//}

@end
