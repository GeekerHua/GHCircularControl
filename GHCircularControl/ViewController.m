//
//  ViewController.m
//  GHCircularControl
//
//  Created by zhenHua on 15/5/30.
//  Copyright (c) 2015年 GeekerHua. All rights reserved.
//

#import "ViewController.h"
#import "GHCircularControl.h"
@interface ViewController ()<GHCircularControlDelegate>
@property (weak, nonatomic) IBOutlet GHCircularControl *circularControl;
@property (weak, nonatomic) IBOutlet UISlider *clider;
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *thumbLabel;

@property (strong, nonatomic)  GHCircularControl *c;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuoyuan"]];
    self.thumbView.bounds = CGRectMake(0, 0, 40, 40);

    self.thumbLabel = [[UILabel alloc] init];
    self.thumbLabel.bounds = self.thumbView.bounds;
    self.thumbLabel.center = CGPointMake(self.thumbView.frame.size.width * 0.5, self.thumbView.frame.size.height * 0.5);
    self.thumbLabel.textAlignment = NSTextAlignmentCenter;
    self.thumbLabel.font = [UIFont systemFontOfSize:18];
    // 控制文本颜色
    self.thumbLabel.textColor = [UIColor whiteColor];
    [self.thumbView addSubview:self.thumbLabel];
    
    
    [self.circularControl setupMinimumValue:0 setMaximumValue:10 thumbLabelFontSize:18 sliderCircleWidth:5 thumbViewSize:CGSizeMake(40, 40) withPercentage:0.75];
    self.circularControl.delegate = self;
    self.circularControl.thumbView = self.thumbView;
    self.circularControl.thumbLabel = self.thumbLabel;
    [self.circularControl setValue:0];
    
    
    self.c = [[GHCircularControl alloc] initWithPercentage:0.8 minimumValue:3 setMaximumValue:25 value:9];
    self.c.frame = CGRectMake(100, 100, 200, 200);
    self.c.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.c];
    
}
- (void)GHCircularControlValueDidChanged:(UIControl *)control currentValue:(CGFloat)value{
    self.clider.value = self.circularControl.value;
}

- (IBAction)sliderChange:(UISlider *)sender {
    self.circularControl.value = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
