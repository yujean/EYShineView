//
//  EYShineView.h
//  EYShineView
//
//  Created by Eugene Yee on 4/23/13.
//  Copyright (c) 2013 Eugene Yee. All rights reserved.
//

@protocol EYShineViewDelegate
- (CMAttitude*)currentAttitude;
@end

@interface EYShineView : UIView
@property (nonatomic, assign) CGFloat radiansOfNormal;
- (id)initWithMask:(UIImage*)theMaskImage withNormal:(CGFloat)theRadians;
@property (nonatomic, weak) id <EYShineViewDelegate> delegate;
@end
