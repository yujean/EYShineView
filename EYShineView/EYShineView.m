//
//  EYShineView.m
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

#import "EYShineView.h"

@interface EYShineView ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIImage* maskImage;
@property (nonatomic, strong) UIImageView* maskImageView;
@property (nonatomic, strong) CMAttitude *referenceFrame;
@property (nonatomic) EYShineViewMeasurementType measurementType;
@end

@implementation EYShineView

- (id)initWithMask:(UIImage*)theMaskImage withNormal:(CGFloat)theRadians withMeasurement:(EYShineViewMeasurementType)theMeasurementType {
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f,theMaskImage.size.width, theMaskImage.size.height)];
	if (self) {
		[self setRadiansOfNormal:theRadians];
		[self setMaskImage:theMaskImage];
		[self setMaskImageView:[[UIImageView alloc] initWithImage:theMaskImage]];
		[[self maskImageView] setFrame:[self bounds]];
		[self setMeasurementType:theMeasurementType];
		[[self layer] setMask:[[self maskImageView] layer]];
		//		[self setDisplayLink:[CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)]];
		//		[[self displayLink] addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	return self;
}

- (void)updateShineWithAttitude:(CMAttitude*)theAttitude {
	CGFloat measurement;
	CGFloat rotationInfluence;
	CGFloat minAlphaValue = [[self delegate] minimumValue];
	CGFloat maxAlphaValue = [[self delegate] maximumValue];
	CGFloat exaggerateMovementFactor = 3.0f;
//	CGFloat minAlphaValue = 0.0f;
//	CGFloat maxAlphaValue = 0.5f;

	switch ([self measurementType]) {
		case kEYShineViewMeasurementTypePitch:
			measurement = theAttitude.pitch;
			rotationInfluence = 1.0f;
			break;
		case kEYShineViewMeasurementTypeRoll:
			measurement = theAttitude.roll;
			rotationInfluence = 1.0f;
			break;
		case kEYShineViewMeasurementTypeYaw:
			measurement = theAttitude.yaw;
			rotationInfluence = 1.0f;
			break;
		default:
			break;
	}

	CGFloat rotation = exaggerateMovementFactor * (measurement + [self radiansOfNormal]);
	CGFloat rotationFactor = (cos(rotation) + 1.0f)/2.0f; // Yields value between 0.0f to 1.0f
	CGFloat alphaValue = ((maxAlphaValue-minAlphaValue) * rotationFactor) + minAlphaValue;
	[self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:alphaValue]];
	NSLog(@"Min: %1.2f, Max: %1.2f, Alpha: %1.2f", minAlphaValue, maxAlphaValue, alphaValue);
}

@end
