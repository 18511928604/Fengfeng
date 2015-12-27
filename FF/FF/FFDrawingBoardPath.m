//
//  FFDrawingBoardPath.m
//  FF
//
//  Created by lx on 15/12/26.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "FFDrawingBoardPath.h"

@implementation FFDrawingBoardPath
- (NSMutableArray *)pointsArray
{
    if (!_pointsArray) {
        _pointsArray = [NSMutableArray new];
    }
    
    return _pointsArray;
}

- (void)addLineToPoint:(CGPoint)point
{
    NSString * pointString = NSStringFromCGPoint(point);
    
    [self.pointsArray addObject:pointString];

}


@end
