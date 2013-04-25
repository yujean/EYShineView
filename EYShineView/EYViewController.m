//
//  EYViewController.m
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

#import "EYViewController.h"

#define kDeviceMotionUpdateInterval 1.0f/50.0f

@interface EYViewController () <EYShineDelegate>{
	CMMotionManager *_motionMgr;
}
@property (nonatomic, strong) CMAttitude *referenceFrame;
@property (nonatomic, strong) CMAttitude *currentAttitude;
@property (nonatomic, strong) NSArray* shineViews;
@property (weak, nonatomic) IBOutlet UISlider *minSlider;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;
- (IBAction)minSliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *maxSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;
- (IBAction)maxSliderValueChanged:(id)sender;
- (IBAction)resetButtonTapped:(id)sender;
@end

@implementation EYViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	[[self view] setBackgroundColor:[UIColor blackColor]];
//	[[self view] setBackgroundColor:[UIColor darkGrayColor]];
//	[[self view] setBackgroundColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000]];
	[[self view] setBackgroundColor:[UIColor colorWithRed:0.971 green:0.000 blue:0.218 alpha:1.000]];

	[self setupShineViews];

	[[self minSlider] setValue:0.00f];
	[self minSliderValueChanged:[self minSlider]];
	[[self maxSlider] setValue:1.0f];
	[self maxSliderValueChanged:[self maxSlider]];
	[self startShine];
}

- (void)setupShineViews {
// Defaults:
//	EYShineView *shineView0              = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"0"] withNormal:0.0f withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewpi             = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi"] withNormal:(M_PI) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineView3Pi4           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"3Pi4"] withNormal:(3*M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewn3Pi4          = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"n3Pi4"] withNormal:(-3*M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewpi2            = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi2"] withNormal:(M_PI/2) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewnPi2           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"nPi2"] withNormal:(-M_PI/2) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewpi4            = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi4"] withNormal:(M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewnPi4           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"nPi4"] withNormal:(-M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewlogo6percent   = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"logo6percent"] withNormal:0.0f withMeasurement:kEYShineViewMeasurementTypePitch];

	EYShineView *shineView0              = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"0"] withNormal:(0.0f) withMeasurement:kEYShineViewMeasurementTypePitch];
	EYShineView *shineViewpi             = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi"] withNormal:M_PI withMeasurement:kEYShineViewMeasurementTypePitch];
//	EYShineView *shineView3Pi4           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"3Pi4"] withNormal:(3*M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewn3Pi4          = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"n3Pi4"] withNormal:(-3*M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
	EYShineView *shineViewpi2            = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi2"] withNormal:(M_PI/2) withMeasurement:kEYShineViewMeasurementTypeRoll];
	EYShineView *shineViewnPi2           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"nPi2"] withNormal:(-M_PI/2) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewpi4            = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"pi4"] withNormal:(M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewnPi4           = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"nPi4"] withNormal:(-M_PI/4) withMeasurement:kEYShineViewMeasurementTypeRoll];
//	EYShineView *shineViewlogo6percent   = [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"logo6percent"] withNormal:0.0f withMeasurement:kEYShineViewMeasurementTypePitch];

	[self setShineViews:@[shineView0, shineViewpi, shineViewpi2, shineViewnPi2]];
//	[self setShineViews:@[shineView0, shineView3Pi4,shineViewn3Pi4, shineViewnPi2,shineViewnPi4,shineViewpi,shineViewpi2, shineViewpi4]];
//	[self setShineViews:@[shineView0, shineView3Pi4,shineViewn3Pi4, shineViewnPi2,shineViewnPi4,shineViewpi,shineViewpi2, shineViewpi4, shineViewlogo6percent]];

	for (EYShineView* tempShineView in [self shineViews]) {
		[tempShineView setDelegate:self];
		[[self view] addSubview:tempShineView];
	}
}

- (void)startShine {
	NSLog(@"Start shining...!");
	if (!_motionMgr) {
		_motionMgr = [CMMotionManager new];
	}

	if (_motionMgr.deviceMotionAvailable) {
		[_motionMgr setDeviceMotionUpdateInterval:kDeviceMotionUpdateInterval];
		CMDeviceMotionHandler dmUpdateHandler = ^(CMDeviceMotion *motion, NSError *error) {
			CMAttitude *attitude = motion.attitude;
			if (![self referenceFrame]) {
				[self setReferenceFrame:attitude];
			} else {
				[attitude multiplyByInverseOfAttitude:[self referenceFrame]];
			}
			for (EYShineView* tempShineView in [self shineViews]) {
				[tempShineView updateShineWithAttitude:[motion attitude]];
			}
		};

		// Start device motion updates
		// Note we do this on the main queue because it's updating UI elements:
		[_motionMgr startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:dmUpdateHandler];
	}
}

#pragma mark - EYShineDelegate Methods 

- (CGFloat)minimumValue {
	return [[self minSlider] value];
}

- (CGFloat)maximumValue {
	return [[self maxSlider] value];
}

- (IBAction)maxSliderValueChanged:(id)sender {
	[[self maxValueLabel] setText:[NSString stringWithFormat:@"%1.2f", [[self maxSlider] value]]];
}

- (IBAction)minSliderValueChanged:(id)sender {
	[[self minValueLabel] setText:[NSString stringWithFormat:@"%1.2f", [[self minSlider] value]]];
}

- (IBAction)resetButtonTapped:(id)sender {
	if ([_motionMgr isDeviceMotionActive]) {
		[self setReferenceFrame:[[_motionMgr deviceMotion] attitude]];
	}
}
@end
