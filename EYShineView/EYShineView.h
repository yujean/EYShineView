//
//  EYShineView.h
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

typedef enum kEYShineViewMeasurementType {
	kEYShineViewMeasurementTypePitch = 0,
	kEYShineViewMeasurementTypeRoll,
	kEYShineViewMeasurementTypeYaw,
} EYShineViewMeasurementType;

@protocol EYShineDelegate
- (CGFloat)minimumValue;
- (CGFloat)maximumValue;
@end

@interface EYShineView : UIView
@property (nonatomic, assign) CGFloat radiansOfNormal;
@property (nonatomic, weak) id<EYShineDelegate> delegate;
- (id)initWithMask:(UIImage*)theMaskImage withNormal:(CGFloat)theRadians withMeasurement:(EYShineViewMeasurementType)theMeasurementType;
- (void)updateShine;
- (void)updateShineWithAttitude:(CMAttitude*)theAttitude;
@end
