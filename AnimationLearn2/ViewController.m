//
//  ViewController.m
//  AnimationLearn2
//
//  Created by Loveway on 15/5/26.
//  Copyright (c) 2015年 Henry·Cheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIImageView     *_imageView;
    UILabel         *_cntLabel;
    int             _cnt;
    UIBezierPath    *_path;
    CALayer         *_layer;
    UIButton        *_btn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateHighlighted];
     _btn.frame = CGRectMake(40, 480, 100, 30);
    [_btn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"shoppingCar"];
    _imageView.center = CGPointMake(270, 320);
    [self.view addSubview:_imageView];

    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 295, 20, 20)];
    _cntLabel.textColor = [UIColor redColor];
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:13];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:_cntLabel];
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }

    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(50, 100)];
    [_path addCurveToPoint:CGPointMake(270, 300) controlPoint1:CGPointMake(100, 500) controlPoint2:CGPointMake(300, -200)];
//    [_path addQuadCurveToPoint:CGPointMake(270, 300) controlPoint:CGPointMake(200, 0)];

}

- (void)startAnimation {
    
    _btn.enabled = NO;
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (__bridge id)[UIImage imageNamed:@"cat"].CGImage;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = CGRectMake(0, 0, 50, 50);
//        _layer.contentsGravity = kCAGravityCenter;
//        _layer.contentsScale = [UIScreen mainScreen].scale;
        _layer.masksToBounds = YES;
        _layer.cornerRadius = 25.;
        _layer.position = CGPointMake(50, 150);
        [self.view.layer  addSublayer:_layer];
        
    }
    [self groupAnimation];
    
}

- (void)groupAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.fillMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.duration = 1;
    animation1.fromValue = @1.;
    animation1.toValue = @2.;
    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.duration = 1.;
    animation2.beginTime = 1;
    animation2.fromValue = @2.;
    animation2.toValue = @.5;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *animation0 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation0.duration = 1;
    animation0.fromValue = @0;
    animation0.toValue = @(M_PI*2);
//    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation0,animation1,animation2];
    group.duration = 2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [_layer addAnimation:group forKey:@"group"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (anim == [_layer animationForKey:@"group"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        _cnt++;
        if (_cnt) {
            _cntLabel.hidden = NO;
        }
        CATransition *transition = [CATransition animation];
        transition.duration = 1.;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = @"cube";
        _cntLabel.text = [NSString stringWithFormat:@"%d",_cnt];
        [_cntLabel.layer addAnimation:transition forKey:@"cntlab"];
        
        CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        animation4.duration = 0.08;
        animation4.fromValue = @-5;
        animation4.toValue = @5;
        animation4.repeatCount = 4;
//        animation4.autoreverses = YES;
        [_imageView.layer addAnimation:animation4 forKey:nil];
        _btn.enabled = YES;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
