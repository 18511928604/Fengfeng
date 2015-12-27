//
//  FFDrawingBoardView.h
//  FF
//
//  Created by lx on 15/12/26.
//  Copyright © 2015年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDrawingBoardPath.h"


@interface FFDrawingBoardView : UIView

@property (nonatomic,strong)NSMutableArray * pathesArray;

- (void)startNewLineAtPoint:(CGPoint)point;
- (void)addToLastLineWithPoint:(CGPoint)point;

@end
