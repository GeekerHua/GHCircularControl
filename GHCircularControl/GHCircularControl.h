//
///  UICircularSlider.h
///  UICircularSlider
//
//  Created by GeekerHua on 15/5/30.
//  Copyright (c) 2015年 GeekerHua. All rights reserved.
//
//

#import <UIKit/UIKit.h>

/**
 *  字体
 */
//NSString * const FontName = @"DINCond-Regular";
/** @name Constants */
/**
 * The styles permitted for the circular progress view.
 *
 * You can set and retrieve the current style of progress view through the progressViewStyle property.
 */
typedef enum {
	GHCircularControlStyleCircle, // 画圆弧
	GHCircularControlStylePie,   // 画填充的扇形
} GHCircularControlStyle;
@protocol GHCircularControlDelegate <NSObject>

-(void)GHCircularControlStop:(UIControl *)control value:(CGFloat)value;
-(void)GHCircularControlValueDidChanged:(UIControl *)control currentValue:(CGFloat)value;

@end

@interface GHCircularControl : UIControl

@property (nonatomic, weak) id <GHCircularControlDelegate> delegate;

/**
 *  绘图类型 默认圆弧
 *	GHCircularControlStyleCircle, // 画圆弧
 *	GHCircularControlStylePie,   // 画填充的扇形
 */
@property (nonatomic) GHCircularControlStyle sliderStyle;

/** 绘图弧度百分比,默认为1*/
@property (nonatomic, assign) CGFloat percentage;

/** 绘图起始角度,默认为- M_Pi_2*/
@property (nonatomic, assign) CGFloat startAngle;

/**绘图方向是否逆时针,默认顺时针*/
@property (nonatomic, assign, getter = isClockwise) BOOL clockwise;

/** 当前值 */
@property (nonatomic) CGFloat value;

/** 最小值*/
@property (nonatomic) CGFloat minimumValue;

/** 最大值 */
@property (nonatomic) CGFloat maximumValue;

/**绘图色*/
@property(nonatomic, retain) UIColor *minimumTrackTintColor;

/**背景色*/
@property(nonatomic, retain) UIColor *maximumTrackTintColor;

/**控制点内部颜色*/
@property(nonatomic, retain) UIColor *thumbTintColor;

/**控制点的View*/
@property (retain, nonatomic) UIView *thumbView;

/**控制点文本*/
@property (retain, nonatomic) UILabel *thumbLabel;

/** 是否允许连续,默认不允许*/
@property(nonatomic, getter=isAllowContinuous) BOOL allowContinuous;


/** 控制线的线宽,默认为5 */
@property (nonatomic, assign) CGFloat sliderCircleWidth;

/** 底线线宽,默认为0.5 */
@property (nonatomic, assign) CGFloat sliderPieWidth;

/** 拖拽圆圈按钮半径 */
@property (nonatomic, assign) CGFloat kThumbRadius;

/** current文字尺寸 */
@property (nonatomic, assign) CGFloat thumbLabelFontSize;

/** 控制点尺寸,默认40*40*/
@property (nonatomic, assign) CGSize thumbViewSize;

/** 允许点击控制,默认不允许*/
@property (nonatomic, assign, getter = isAllowTap) BOOL allowTap;


/**
 *  快速创建对象
 *
 *  @param percentage   显示百分比
 *  @param minimumValue 最小值
 *  @param maximumValue 最大值
 *  @param value        当前值
 *
 *  @return 返回实例
 */
- (instancetype)initWithPercentage:(CGFloat)percentage minimumValue:(CGFloat)minimumValue setMaximumValue:(CGFloat)maximumValue value:(CGFloat)value;
/**
 *  初始化属性
 *
 *  @param minimumValue       显示的最小值
 *  @param maximumValue       显示的最大值
 *  @param thumbLabelFontSize current字体大小
 *  @param sliderCircleWidth  线条宽度
 *  @param thumbViewSize      current尺寸
 *  @param isVitualControl    是否是虚拟酒柜
 *  @param currentTemp        当前温度
 *  @param percentage         显示百分比
 */
- (void)setupMinimumValue:(CGFloat)minimumValue setMaximumValue:(CGFloat)maximumValue thumbLabelFontSize:(CGFloat)thumbLabelFontSize sliderCircleWidth:(CGFloat)sliderCircleWidth thumbViewSize:(CGSize)thumbViewSize withPercentage:(CGFloat)percentage;

@end




