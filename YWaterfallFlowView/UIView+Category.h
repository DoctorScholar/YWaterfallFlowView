//
//  UIView+Category.h
//  GSJuZhang
//
//  Created by __Qing__ on 15/1/15.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 UIView category relevant with frame
 */
@interface UIView (frame)

//sets frame.origin.x = left;
@property (nonatomic) CGFloat left;
//sets frame.origin.y = top;
@property (nonatomic) CGFloat top;
//sets frame.origin.x = right - frame.size.wigth;
@property (nonatomic) CGFloat right;
//sets frame.origin.y = botton - frmae.size.height;
@property (nonatomic) CGFloat bottom;
//sets frame.size.width = width;
@property (nonatomic) CGFloat width;
//sets frame.size.height = height;
@property (nonatomic) CGFloat height;
//sets center.x = centerX;
@property (nonatomic) CGFloat centerX;
//sets center.y = centerY;
@property (nonatomic) CGFloat centerY;
//frame.origin
@property (nonatomic) CGPoint origin;
//frame.size
@property (nonatomic) CGSize size;

@end
/**
 UIView category relevant with extension
 */
@interface UIView (extension)

- (void) addTarget:(id)pTarget selector:(SEL)pSelector;
//包含这个view的controller
- (UIViewController *)viewcontroller;

- (void)removeAllSubviews;

- (void)addSubviews:(NSArray *)subviews;

- (void)removeSubviewForUIButton;

- (void)setbackgroundImage:(UIImage *)img;

- (void)bringToFront;

- (UIImage *)imageByRenderingView;

- (BOOL)hasGesture:(id)gestureObjClass;

- (BOOL)removeGesture:(id)gestureObjClass;

- (BOOL)removeAllGesture;

@end
/**
 UIView category relevant with UI
 */
@interface UIView (alert)

//center alert lable
@property (nonatomic, strong, readonly) UILabel *alertLable;
//center alert text
@property (nonatomic, strong) NSString *alert;

@end
/**
 UIView category relevant with rotation.
 */
@interface UIView (rotation)
///  loopNumber plusplus give CGAffineTranformMakeRotation used
@property (nonatomic, assign) NSInteger loopNumber;
///  view begin rotation.
- (void)beginRotation;
///  view cancel rotation.
- (void)cancelRotation;

- (void)rotation_0;

- (void)rotation_90;

- (void)rotation_180;

- (void)rotation_270;

- (void)rotateToArc:(CGFloat)arc;

@end

@interface UIView (line)

- (UIView *)addtionUnderlineWithSross:(CGFloat)sross withColor:(UIColor *)color;

- (UIView *)addtionHorizontalLineWithSross:(CGFloat)sross withTop:(CGFloat)top withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withWidth:(CGFloat)width withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withWidth:(CGFloat)width withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withRight:(CGFloat)right withColor:(UIColor *)color;

- (UIView *)addtionHoriaontalLineWithSross:(CGFloat)sross withRight:(CGFloat)right withWidth:(CGFloat)width withColor:(UIColor *)color;


- (UIView *)addtionVarticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withColor:(UIColor *)color;

- (UIView *)addtionVerticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withColor:(UIColor *)color;

- (UIView *)addtionVerticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withBottom:(CGFloat)bottom withColor:(UIColor *)color;

- (UIView *)addtionVerticalLineWithSross:(CGFloat)sross withLeft:(CGFloat)left withTop:(CGFloat)top withHeight:(CGFloat)height withColor:(UIColor *)color;

@end

@interface UIView (help)

- (void)printViewHierarchy:(UIView *)superView;

@end

@interface UIView (UIImage)

- (UIImage *)capture;

@end

