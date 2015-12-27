//
//  FFDrawingBoardPath.h
//  FF
//
//  Created by lx on 15/12/26.
//  Copyright © 2015年 lx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDrawingBoardPath : NSObject

@property (nonatomic,strong)NSMutableArray * pointsArray;

- (void)addLineToPoint:(CGPoint)point;

@end
