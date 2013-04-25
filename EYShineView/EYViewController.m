//
//  EYViewController.m
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

#import "EYViewController.h"

#define kDeviceMotionUpdateInterval 1.0f/50.0f

@interface EYViewController () <EYShineViewDelegate> {
	CMMotionManager *_motionMgr;
}
@property (nonatomic, strong) CMAttitude *referenceFrame;
@property (nonatomic, strong) CMAttitude *currentAttitude;
@end

@implementation EYViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor blackColor]];
	EYShineView *shineViewTop		= [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"top"] withNormal:0.0f];
	[shineViewTop setDelegate:self];
	EYShineView *shineViewRight		= [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"right"] withNormal:-(M_PI/2)];
	EYShineView *shineViewBottom	= [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"bottom"] withNormal:M_PI];
	EYShineView *shineViewLeft		= [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"left"] withNormal:M_PI/2];
	EYShineView *shineViewCorner	= [[EYShineView alloc] initWithMask:[UIImage imageNamed:@"corner"] withNormal:0.0f];
	[[self view] addSubview:shineViewTop];
	[[self view] addSubview:shineViewRight];
	[[self view] addSubview:shineViewBottom];
	[[self view] addSubview:shineViewLeft];
	[[self view] addSubview:shineViewCorner];
	[self startShine];
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

			[self setCurrentAttitude:motion.attitude];
			// Blast notification?
//			[[NSNotificationCenter defaultCenter] postNotificationName:kEYNotificationMotionUpdate object:[self currentAttitude]];
		};

		// Start device motion updates
		// Note we do this on the main queue because it's updating UI elements:
		[_motionMgr startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:dmUpdateHandler];
	}
}

- (CMAttitude*)currentAttitude {
	return [self currentAttitude];
}

@end
