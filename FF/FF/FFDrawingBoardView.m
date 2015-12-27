//
//  FFDrawingBoardView.m
//  FF
//
//  Created by lx on 15/12/26.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "FFDrawingBoardView.h"


@implementation FFDrawingBoardView

- (NSMutableArray *)pathesArray
{
    if (!_pathesArray) {
        _pathesArray = [NSMutableArray new];
    }
    return _pathesArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point =  [[touches anyObject] locationInView:self];
    
    [self startNewLineAtPoint:point];
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self addToLastLineWithPoint:point];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches withEvent:event];
}

- (void)endTouch:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)startNewLineAtPoint:(CGPoint)point
{
    FFDrawingBoardPath * path = [[FFDrawingBoardPath alloc] init];
    
    [path addLineToPoint:point];
    [self.pathesArray addObject:path];
}


- (void)addToLastLineWithPoint:(CGPoint)point
{
    FFDrawingBoardPath * path = [self.pathesArray lastObject];

    [path addLineToPoint:point];
    
}




- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (FFDrawingBoardPath * path in self.pathesArray) {
        
        CGContextBeginPath(context);
        
        CGPoint startPoint = CGPointFromString([path.pointsArray firstObject]);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        
        for (int i = 1;i < path.pointsArray.count;i ++) {
            NSString * pointString = path.pointsArray[i];
            
            CGPoint point = CGPointFromString(pointString);
            
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextStrokePath(context);
    }
}




@end
