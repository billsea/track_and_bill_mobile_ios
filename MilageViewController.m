//
//  MilageViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "MilageViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MilageViewController ()<CLLocationManagerDelegate>{
	NSMutableArray* _pickerDataMiles;
	NSMutableArray* _pickerDataTenths;
	CLLocationManager* _locationManager;
	CLLocation* _lastLocation;
	CLLocationDistance _totalMeters;
}

@end

@implementation MilageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.

  // Set the title of the navigation item
  [[self navigationItem] setTitle:NSLocalizedString(@"milage_tracking", nil)];

  _pickerDataMiles = [[NSMutableArray alloc] init];
  _pickerDataTenths = [[NSMutableArray alloc] init];
	
  for (int i = 0; i < 3000; i++) {
    [_pickerDataMiles addObject:[NSNumber numberWithInt:i]];
  }
	
	for (int i = 0; i < 10; i++) {
		[_pickerDataTenths addObject:[NSNumber numberWithInt:i]];
	}
	
	_milagePicker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [_milagePicker selectRow:self.selectedSession.milage inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  // save miles and tenths picker selection
	float totalMilage = [[_pickerDataMiles objectAtIndex:[_milagePicker selectedRowInComponent:0]] floatValue] + ([[_pickerDataMiles objectAtIndex:[_milagePicker selectedRowInComponent:1]] floatValue]/10);
  [self.selectedSession setMilage:totalMilage];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark picker view delegate methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 2;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
	switch (component) {
		case 1:
			return _pickerDataTenths.count;
			break;
		default:
			return _pickerDataMiles.count;
	}
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
	switch (component) {
		case 1:
			return [NSString stringWithFormat:@"%@",_pickerDataTenths[row]];
			break;
		default:
			return [NSString stringWithFormat:@"%@",_pickerDataMiles[row]];
	}
	
}

#pragma mark Location methods
- (void)getLocation {
	// init location manager
	_locationManager = [CLLocationManager new];
	_locationManager.delegate = self;
	_locationManager.distanceFilter = 50.0;//kCLDistanceFilterNone;//100.0;//meters - using 1/10 of a kilometer
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	if ([_locationManager
			 respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		[_locationManager requestWhenInUseAuthorization];
	}
	[_locationManager startMonitoringSignificantLocationChanges];
	[_locationManager startUpdatingLocation];
}

- (IBAction)trackMilage:(id)sender {
	[self getLocation];
}

#pragma mark CLLocation delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
	CLLocationDistance meters = [manager.location distanceFromLocation:_lastLocation];
	if(meters >= 50){
		_totalMeters = _totalMeters + meters;
		
		_tempLabel.text = [NSString stringWithFormat:@"%f",_totalMeters];
	}
	
	_lastLocation = manager.location;
	
//	[self forecastRequestWithLat:_locationManager.location.coordinate.latitude
//												andLon:_locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusNotDetermined: {
		} break;
		case kCLAuthorizationStatusDenied: {
		} break;
		case kCLAuthorizationStatusAuthorizedWhenInUse:
		case kCLAuthorizationStatusAuthorizedAlways: {
			[_locationManager startUpdatingLocation];
		} break;
		default:
			break;
	}
}
@end
