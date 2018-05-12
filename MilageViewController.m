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
	NSMutableArray* _pickerDataWhole;
	NSMutableArray* _pickerDataTenths;
	CLLocationManager* _locationManager;
	CLLocation* _lastLocation;
	CLLocationDistance _totalMeters;
	NSNumberFormatter * _formatterTenths;
}

@end

@implementation MilageViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self navigationItem] setTitle:NSLocalizedString(@"milage_tracking", nil)];

  _pickerDataWhole = [[NSMutableArray alloc] init];
  _pickerDataTenths = [[NSMutableArray alloc] init];
	
  for (int i = 0; i < 3000; i++) {
    [_pickerDataWhole addObject:[NSNumber numberWithInt:i]];
  }
	
	for (int i = 0; i < 10; i++) {
		[_pickerDataTenths addObject:[NSNumber numberWithInt:i]];
	}
	
	_milagePicker.delegate = self;
	
	_formatterTenths = [[NSNumberFormatter alloc] init];
	[_formatterTenths setMaximumFractionDigits:1];
	[_formatterTenths setRoundingMode: NSNumberFormatterRoundDown];
}

- (void)viewWillAppear:(BOOL)animated {
  [_milagePicker selectRow:self.selectedSession.milage inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self save];
}

- (void)save {
	// save miles and tenths picker selection
	float totalMilage = [[_pickerDataWhole objectAtIndex:[_milagePicker selectedRowInComponent:0]] floatValue] + ([[_pickerDataWhole objectAtIndex:[_milagePicker selectedRowInComponent:1]] floatValue]/10);
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
			return _pickerDataWhole.count;
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
			return [NSString stringWithFormat:@"%@",_pickerDataWhole[row]];
	}
	
}

-(void)updatePickerViewWithMetric:(bool)isMetric {
	//meters to miles
	float totalDistance = 0;
	int distanceTrunc = 0;
	
	if(_totalMeters > 0) {
		if(isMetric){
			totalDistance = _totalMeters/1000;//Kilometers
		}else{
			totalDistance = _totalMeters * 0.0006213712;//miles
		}
		
		if(totalDistance >=1){
			distanceTrunc = (int)totalDistance;
		}
		
		float Tenths = totalDistance - distanceTrunc;
		NSString* stringTenths = [[_formatterTenths stringFromNumber:[NSNumber numberWithFloat:Tenths]] stringByReplacingOccurrencesOfString:@"." withString:@""];
		_tempLabel.text = [NSString stringWithFormat:@"%f",totalDistance];

		//Update picker components
		[_milagePicker selectRow:distanceTrunc inComponent:0 animated:YES];
		[_milagePicker selectRow:stringTenths.intValue inComponent:1 animated:YES];
	}
}

#pragma mark Location methods
- (void)startTracking {
	// init location manager
	if(!_locationManager){
		_locationManager = [CLLocationManager new];
		_locationManager.delegate = self;
		_locationManager.distanceFilter = 50.0;//kCLDistanceFilterNone;//100.0;//meters - using 1/10 of a kilometer
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_locationManager.allowsBackgroundLocationUpdates = YES;
	
		if ([_locationManager
				 respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[_locationManager requestWhenInUseAuthorization];
		}
	}
	[_locationManager startMonitoringSignificantLocationChanges];
	[_locationManager startUpdatingLocation];
}

- (IBAction)trackMilage:(id)sender {
	UISwitch* trackSwitch = sender;
	if(trackSwitch.on){
		[self startTracking];
	} else {
		[_locationManager stopUpdatingLocation];
		[_locationManager stopMonitoringSignificantLocationChanges];
	}
}

#pragma mark CLLocation delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocationDistance meters = [manager.location distanceFromLocation:_lastLocation];
	_totalMeters = _totalMeters + meters;
		
	[self updatePickerViewWithMetric:NO];

	_lastLocation = manager.location;
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
