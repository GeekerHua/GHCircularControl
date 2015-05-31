//
//  UICircularSlider.m
//  UICircularSlider
//
//  Created by GeekerHua on 15/5/30.
//  Copyright (c) 2015年 GeekerHua. All rights reserved.
//
//
//

#import "GHCircularControl.h"


@interface GHCircularControl()

/** 是否是第一次绘图 */
@property (nonatomic, assign, getter = isNotFirstShow) BOOL notFirstShow;

/** 绘图半径 */
@property (nonatomic, assign) CGFloat sliderRadius;

/** current中心点 */
@property (nonatomic) CGPoint thumbCenterPoint;

/** 绘图中心点 */
@property (nonatomic, assign) CGPoint middlePoint;

/**点击的控制点 */
@property (nonatomic, assign) CGPoint tapLocation;

/** 当前弧度*/
@property (nonatomic, assign) CGFloat currentPercent;

@end

#pragma mark -
@implementation GHCircularControl

- (void)setCurrentPercent:(CGFloat)currentPercent{
    if (currentPercent != _currentPercent) {
        _currentPercent = currentPercent;
        [self setNeedsDisplay];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(void)setPercentage:(CGFloat)percentage{
    if (_percentage != percentage) {
        if (percentage > 1) percentage =1;
        if (percentage < 0) percentage = 0;
        _percentage = percentage;
        [self setNeedsDisplay];

    }
}

- (void)setValue:(CGFloat)value {
    if (value != _value) {
        if (value > self.maximumValue) { value = self.maximumValue; }
        if (value < self.minimumValue) { value = self.minimumValue; }
        _value = value;
        // 设置全圆弧百分比
        self.currentPercent = (value - self.minimumValue) /(self.maximumValue - self.minimumValue);
    }
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    if (minimumValue != _minimumValue) {
        _minimumValue = minimumValue;
        if (self.maximumValue < self.minimumValue)	{ self.maximumValue = self.minimumValue; }
        if (self.value < self.minimumValue)			{ self.value = self.minimumValue; }
    }
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    if (maximumValue != _maximumValue) {
        if (self.percentage < 1) {
            // 转换为全圆弧的最大值
            _maximumValue = (maximumValue + 0.999999 - self.minimumValue ) / self.percentage + self.minimumValue ;
        }else{
            _maximumValue = maximumValue / self.percentage ;
        }
        if (self.minimumValue > self.maximumValue)	{ self.minimumValue = self.maximumValue; }
        if (self.value > self.maximumValue)			{ self.value = self.maximumValue; }
    }
}


- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    if (![minimumTrackTintColor isEqual:_minimumTrackTintColor]) {
        _minimumTrackTintColor = minimumTrackTintColor;
        [self setNeedsDisplay];
    }
}


- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    if (![maximumTrackTintColor isEqual:_maximumTrackTintColor]) {
        _maximumTrackTintColor = maximumTrackTintColor;
        [self setNeedsDisplay];
    }
}


- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    if (![thumbTintColor isEqual:_thumbTintColor]) {
        _thumbTintColor = thumbTintColor;
        [self setNeedsDisplay];
    }
}

- (void)setSliderStyle:(GHCircularControlStyle)sliderStyle {
    if (sliderStyle != _sliderStyle) {
        _sliderStyle = sliderStyle;
        [self setNeedsDisplay];

    }
}


- (CGPoint)middlePoint{
    if (_middlePoint.x == 0) {
        _middlePoint.x = self.bounds.origin.x + self.bounds.size.width * 0.5;
        _middlePoint.y = self.bounds.origin.y + self.bounds.size.height * 0.5;
    }
    return _middlePoint;
}


/** @name Init and Setup methods */
#pragma mark - Init and Setup methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithPercentage:(CGFloat)percentage minimumValue:(CGFloat)minimumValue setMaximumValue:(CGFloat)maximumValue value:(CGFloat)value{
    if (self = [super init]) {
//        这里初始化
        self.percentage = percentage;
        self.minimumValue = minimumValue;
        self.maximumValue = maximumValue;
        self.value = value;
    }
    return self;
}
/**
 *  初始化属性
 *  设置一个默认值，最小值0,最大值10，字体18，线宽5，current尺寸50*50,否，当前5，百分比1.
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
- (void)setupMinimumValue:(CGFloat)minimumValue setMaximumValue:(CGFloat)maximumValue thumbLabelFontSize:(CGFloat)thumbLabelFontSize sliderCircleWidth:(CGFloat)sliderCircleWidth thumbViewSize:(CGSize)thumbViewSize withPercentage:(CGFloat)percentage
{
    self.percentage = percentage;
    [self setMinimumValue:minimumValue];
    [self setMaximumValue:maximumValue];
    self.thumbLabelFontSize = thumbLabelFontSize;
    self.sliderCircleWidth = sliderCircleWidth;
    self.thumbViewSize = thumbViewSize;

}


- (void)setup {

    self.backgroundColor = [UIColor clearColor];
    self.percentage = 1.0;
    self.startAngle =  - M_PI_2;
    self.sliderPieWidth = 0.5;
    //    self.sliderStyle = GHCircularControlStylePie;

    self.value = 5.0;
    self.sliderCircleWidth = 5;
    self.thumbLabelFontSize = 8;
    self.thumbViewSize = CGSizeMake(40, 40);
    self.kThumbRadius = 20;
    
    self.minimumTrackTintColor = [UIColor redColor];
    self.maximumTrackTintColor = [UIColor lightGrayColor];
    self.thumbTintColor = [UIColor greenColor];
    
    self.thumbCenterPoint = CGPointZero;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
    panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
    [self addGestureRecognizer:panGestureRecognizer];
    self.multipleTouchEnabled = YES;
    
    if (self.isAllowTap) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}


/** @name Drawing methods */
#pragma mark - Drawing methods

// 绘图半径
- (CGFloat)sliderRadius {
    CGFloat radius = MIN(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    radius -= MAX(self.sliderPieWidth, self.kThumbRadius);
    return radius - 40;
}
/**
 *  画控制点
 *
 *  @param sliderButtonCenterPoint 控制点
 *  @param context                 图形上下文
 */
- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y);
    CGContextAddArc(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y, self.kThumbRadius, 0.0, 2*M_PI, self.clockwise);
    // 设置颜色和线宽
    CGContextFillPath(context);
    UIGraphicsPopContext();
    
    if (!self.isNotFirstShow) {
//        self.thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuoyuan"]];
//        self.thumbView.bounds = CGRectMake(0, 0, self.thumbViewSize.width, self.thumbViewSize.height);
//
//        self.thumbLabel = [[UILabel alloc] init];
//        self.thumbLabel.bounds = self.thumbView.bounds;
//        self.thumbLabel.center = CGPointMake(self.thumbView.frame.size.width * 0.5, self.thumbView.frame.size.height * 0.5);
//        self.thumbLabel.textAlignment = NSTextAlignmentCenter;
//        self.thumbLabel.font = [UIFont systemFontOfSize:self.thumbLabelFontSize];
//        // 控制文本颜色
//        self.thumbLabel.textColor = [UIColor whiteColor];
//        [self.thumbView addSubview:self.thumbLabel];
        if (self.thumbView != nil) {
            [self addSubview:self.thumbView];
        }
        self.notFirstShow = YES;
    }
    self.thumbView.center = sliderButtonCenterPoint;
    self.thumbLabel.text = self.value < 10 ?[NSString stringWithFormat:@"%02d",(int)self.value] : [NSString stringWithFormat:@"%02d",(int)self.value];
}

/**
 *  画线
 *
 *  @param track   画到哪
 *  @param center  基准中心坐标
 *  @param radius  半径
 *  @param context 绘图上下文
 *  @param isMin   是否是控制线
 *
 *  @return 控制点
 */
- (CGPoint)drawCircularTrack:(CGFloat)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context flag:(BOOL)isMin{

    // 设置控制线和底线线宽
    CGFloat width = isMin ? self.sliderCircleWidth : self.sliderPieWidth;
    CGContextSetLineWidth(context, width);

    UIGraphicsPushContext(context);
    CGContextBeginPath(context);

    // 计算出角度？计算角度有偏差
    CGFloat angleFromTrack = track * 2 * M_PI;

    CGFloat endAngle = self.startAngle + angleFromTrack;
    CGContextAddArc(context, center.x, center.y, radius, self.startAngle, endAngle, self.clockwise);
    
    CGContextSetLineCap(context, kCGLineCapRound); // 设置线条头尾->圆角
    CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
    
    CGContextStrokePath(context);
    UIGraphicsPopContext();
    return arcEndPoint;
}

// 画扇形图
- (CGPoint)drawPieTrack:(CGFloat)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    CGFloat angleFromTrack = track * 2 * M_PI;

    CGFloat endAngle = self.startAngle + angleFromTrack;
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, self.startAngle, endAngle, self.clockwise);
    
    CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    UIGraphicsPopContext();
    
    return arcEndPoint;
}
// 绘图方法
- (void)drawRect:(CGRect)rect {
    if (self.value - self.minimumValue >= (self.maximumValue - self.minimumValue) * self.percentage) {
        self.value = self.minimumValue + (self.maximumValue - self.minimumValue) * self.percentage;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.sliderPieWidth);

    switch (self.sliderStyle) {
        case GHCircularControlStylePie: // 画底图
            // 扇形图整体背景
            [self.maximumTrackTintColor setFill];
            [self drawPieTrack:1 atPoint:self.middlePoint withRadius:self.sliderRadius inContext:context];
            // 扇形图边框
            [self.minimumTrackTintColor setStroke];
            [self drawCircularTrack:1 atPoint:self.middlePoint withRadius:self.sliderRadius inContext:context flag:YES];
            // 扇形图当前块
            [self.minimumTrackTintColor setFill];
            self.thumbCenterPoint = [self drawPieTrack:self.currentPercent atPoint:self.middlePoint withRadius:self.sliderRadius inContext:context];
            break;
        case GHCircularControlStyleCircle:
        default: // 画控制圆弧
            // 画背景底线
            [self.maximumTrackTintColor setStroke];
            [self drawCircularTrack:1 atPoint:self.middlePoint withRadius:self.sliderRadius inContext:context flag:NO];
            // 画控制线
            [self.minimumTrackTintColor setStroke];
            self.thumbCenterPoint = [self drawCircularTrack:self.currentPercent atPoint:self.middlePoint withRadius:self.sliderRadius inContext:context flag:YES];
            break;
    }
    
    [self.thumbTintColor setFill];
    // 画控制点
    [self drawThumbAtPoint:self.thumbCenterPoint inContext:context];
    
}



/** @name UIGestureRecognizer management methods */
#pragma mark - UIGestureRecognizer management methods
- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer {

    self.tapLocation = [panGestureRecognizer locationInView:self];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // 控制半径
        CGFloat radius = self.sliderRadius + self.thumbViewSize.width;
        // 顺时针 * -1 ,逆时针 * 1;
        int opposite = self.clockwise ? 1 : -1;
        CGPoint sliderStartPoint = CGPointMake(self.middlePoint.x + radius * cos(self.startAngle), self.middlePoint.y - radius * sin(self.startAngle) * opposite);
        CGFloat angle = [self angleFromCenter:self.middlePoint fromPoint:sliderStartPoint toPoint:self.tapLocation];
        panGestureRecognizer.enabled = YES;
        if(angle > self.percentage * 2 * M_PI){
            panGestureRecognizer.enabled = NO;
            panGestureRecognizer.enabled = YES;
            return;
        }
        self.value = angle / (2 * M_PI) * (self.maximumValue - self.minimumValue) + self.minimumValue;
        
        if ([self.delegate respondsToSelector:@selector(GHCircularControlValueDidChanged:currentValue:)]) {
            [self.delegate GHCircularControlValueDidChanged:self currentValue:self.value];
        }
    }

   if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled || panGestureRecognizer.state == UIGestureRecognizerStateEnded){
       if ([self.delegate respondsToSelector:@selector(GHCircularControlStop:value:)]) {
           [self.delegate GHCircularControlStop:self value:self.value];
       }
    }
}

///** 将数值转换成对应的弧度 */
//- (CGFloat)translateValue:(CGFloat)sourceValue fromMinValue:(CGFloat)minValue fromMaxValue:(CGFloat)maxValue toMinValue:(CGFloat)toMinAngle toMaxValue:(CGFloat)toMaxAngle{
//    CGFloat a, b, destinationValue;
//    
//    a = (toMaxAngle - toMinAngle) / (maxValue - minValue);
//    b = toMaxAngle - a * maxValue;
//    destinationValue = a * sourceValue + b;
//    
//    return destinationValue;
//}
//

/**
 *  返回三点间的弧度
 *
 *  @param centerPoint 中心点
 *  @param p1          起始点
 *  @param p2          结束点
 *
 *  @return 弧度
 */
- (CGFloat)angleFromCenter:(CGPoint)centerPoint fromPoint:(CGPoint)p1 toPoint:(CGPoint)p2{
    CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
    CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
    // 将角度转换一下
    return angle < 0 ? -angle : 2 * M_PI - angle;
}
@end




