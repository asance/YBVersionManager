//
//  YBCloseButton.m
//  YoubanAgent
//
//  Created by asance on 2017/9/28.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBCloseButton.h"
#import "UIColor+HexInt.h"

@implementation YBCloseButton

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //画一个x形状，假设起点系数scale为0.25
    //先画左倾线：
    //假设y=height/scale,那么x=y*width/height,得出起点（x,y）
    //终点x'=(width-x),y'=(height-y),得终点(x‘,y')
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);

    //起点系数
    CGFloat scale = 0.25;
    
    CGFloat leftY0 = (height*scale);
    CGFloat leftX0 = (leftY0*width/height);
    
    CGFloat leftY1 = (height-leftY0);
    CGFloat leftX1 = (width-leftX0);

    //先画右倾线：
    //假设y=height/scale,那么x=(width-(y*width/height)), 得出起点（x,y）
    //终点x'=(width-x),y'=(height-y),得终点(x‘,y')
    CGFloat rightY0 = leftY0;
    CGFloat rightX0 = leftX1;
    
    CGFloat rightY1 = leftY1;
    CGFloat rightX1 = leftX0;

    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor hexColor:@"ffffff" alpha:0.5].CGColor);
    
    CGContextMoveToPoint(context, leftX0, leftY0);
    CGContextAddLineToPoint(context, leftX1, leftY1);
    CGContextDrawPath(context, kCGPathStroke);

    CGContextMoveToPoint(context, rightX0, rightY0);
    CGContextAddLineToPoint(context, rightX1, rightY1);
    CGContextDrawPath(context, kCGPathStroke);
    
    //最后画一个圆
    CGFloat arcX = (width*0.5);
    CGFloat arcY = (height*0.5);
    CGFloat arcRadius = ((MIN(width, height)-1)*0.5);
    CGContextAddArc(context, arcX, arcY, arcRadius, 0, M_PI*2, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
