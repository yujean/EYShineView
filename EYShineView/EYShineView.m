//
//  EYShineView.m
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

#import "EYShineView.h"

@interface EYShineView ()
@property (nonatomic, strong) UIImage* maskImage;
@property (nonatomic, strong) UIImageView* maskImageView;
@property (nonatomic, strong) CMAttitude *referenceFrame;
@end

@implementation EYShineView

- (id)initWithMask:(UIImage*)theMaskImage withNormal:(CGFloat)theRadians {
	self = [super initWithFrame:CGRectMake(0.0f, 0.0f,theMaskImage.size.width, theMaskImage.size.width)];
	if (self) {
		[self setRadiansOfNormal:theRadians];
		[self setMaskImage:theMaskImage];
		[self setMaskImageView:[[UIImageView alloc] initWithImage:theMaskImage]];
		[[self maskImageView] setFrame:[self bounds]];
		[[self layer] setMask:[[self maskImageView] layer]];
	}

	[CADisplayLink displayLinkWithTarget:self selector:@selector(updateShine)];
	return self;
}

- (void)updateShine {

	CMAttitude *attitude = [[self delegate] currentAttitude];
	CGFloat yaw = attitude.yaw;

	CGFloat x = yaw+[self radiansOfNormal];

	if (x > M_PI) {
		x -= 2*M_PI;
	} else if (x < -M_PI) {
		x += 2*M_PI;
	}

	CGFloat alphaValue = 1.0f - (x/M_PI);

	NSLog(@"yaw: %1.2f, alpha: %1.2f", yaw, alphaValue);
//	NSLog(@"Attitude: pitch: %1.2f, roll: %1.2f, yaw: %1.2f, alpha: %1.2f", pitch, roll, yaw, alphaValue);
//	NSLog(@"Attitude: pitch: %1.2f, roll: %1.2f, yaw: %1.2f", attitude.pitch, attitude.roll, attitude.yaw);
	[self setBackgroundColor:[UIColor colorWithWhite:alphaValue alpha:1.0f]];
}

@end
