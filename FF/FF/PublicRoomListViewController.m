//
//  PublicRoomListViewController.m
//  FF
//
//  Created by lx on 15/12/24.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "PublicRoomListViewController.h"
#import "FFXMPPManager.h"

@interface PublicRoomListViewController ()

@end

@implementation PublicRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * createRoomBtn = [[UIBarButtonItem alloc] initWithTitle:@"建房" style:UIBarButtonItemStylePlain target:self action:@selector(createRoomClicked:)];
    self.navigationItem.rightBarButtonItem = createRoomBtn;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[FFXMPPManager sharedXmppManager] searchRoomWithCallBack:^(NSMutableArray *roomsArray) {
        NSLog(@"%@",roomsArray);
    }];
}

- (void)createRoomClicked:(UIBarButtonItem *)item
{

}


@end
