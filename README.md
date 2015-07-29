Time scrubber
----------
Time scrubber for date selection. Can be used to select date for remote video playing. iOS 7-8, Objective-C, Xcode 6.4.

   ![Demo](https://dl.dropbox.com/s/flxvev4qlkt8djx/timescrubber_demo.gif)
Features
-------------

 - Automatically generated blocks based on date interval
 - Customization
 - Supports previewing available video from server (grey blocks - available video from server)
 - Preview for selected date (AMPopTip - https://github.com/andreamazz/AMPopTip)
 - Don't show feature
 - Long press - zoom scrubber to one period (one section)
 - Dont select not available video (white blocks are not available video)
 - Animation
 - Update function to update scrubber each second and update date interval
 - Automatically moving available blocks per time

Usage
-------------
Initialization:

    NSDate *startDate;
    NSDate *endDate;

    NSDictionary *d1 = @{@"1" : @"0", @"2" : @"-3600"}; // 1h
    NSDictionary *d2 = @{@"1" : @"-72000", @"2" : @"-79200"}; // 2h
    NSMutableArray *sampleArrayWithBlocks = [NSMutableArray arrayWithObjects:d1, d2, nil]; // sample video available video blocks

    endDate = [NSDate date];
    startDate = [NSDate dateWithTimeInterval:-(3600 * 24) sinceDate:endDate]; // one day
    
    mTimeScrubber = [[TimeScrubber alloc] initWithFrame:CGRectMake(30, 50, self.view.bounds.size.width - 60, 50) withStartDate:startDate endDate:endDate segments:12 andVideoBlocks:sampleArrayWithBlocks];
    [self.view addSubview:mTimeScrubber];
    [mTimeScrubber updateEnable:YES]; // automatically tick and update date each second

Retrieving selected date:

    [mTimeScrubber addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged]; // add this to initialization block

	// add this as new method in ViewController
    -(void)newValue:(TimeScrubber*)slider
	{
		NSString *currentSelectedDate = [NSString stringWithFormat:@"Current selected date = %@", slider.selectedDate];
	}
    
Contact me
-------------
You can contact me via email vladyslav.semenchenko.usa@gmail.com or directly from my site: http://www.vsemenchenko.com

Licenses
-------------
If you want to use source code please contact me: vladyslav.semenchenko.usa@gmail.com

2015, Vladyslav Semenchenko.
