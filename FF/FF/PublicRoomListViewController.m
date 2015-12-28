//
//  PublicRoomListViewController.m
//  FF
//
//  Created by lx on 15/12/24.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "PublicRoomListViewController.h"
#import "FFXMPPManager.h"
#import "RoomListTableViewCell.h"

@interface PublicRoomListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * roomsTableView;
@property (nonatomic,strong)NSMutableArray * roomsArray;


@end

@implementation PublicRoomListViewController

#pragma mark - lazy initailization

- (NSMutableArray *)roomsArray
{
    if (!_roomsArray) {
        _roomsArray = [NSMutableArray new];
    }
    return _roomsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公共房间";
    
    UIBarButtonItem * createRoomBtn = [[UIBarButtonItem alloc] initWithTitle:@"建房" style:UIBarButtonItemStylePlain target:self action:@selector(createRoomClicked:)];
    self.navigationItem.rightBarButtonItem = createRoomBtn;

    self.roomsTableView = [[UITableView alloc] init];
    self.roomsTableView.delegate = self;
    self.roomsTableView.dataSource = self;
    [self.view addSubview:self.roomsTableView];
    
    [self.roomsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[FFXMPPManager sharedXmppManager] searchRoomWithCallBack:^(NSMutableArray *roomsArray) {
        NSLog(@"%@",roomsArray);
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"RoomListCellID";
    RoomListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RoomListTableViewCell" owner:nil options:nil] firstObject];
    }
    
    
 
    return cell;
}



#pragma mark - 创建房间
- (void)createRoomClicked:(UIBarButtonItem *)item
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"创建房间" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"房间名";
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"群昵称";
    }];
    
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * roomName = alertController.textFields[0].text;
        NSString * roomNickName = alertController.textFields[1].text;
        
        [[FFXMPPManager sharedXmppManager] xmppRoomCreateRoomName:roomName nickName:roomNickName MessageCallBack:^(NSDictionary * message) {
            
        } presentCallBack:^(NSDictionary *present) {
            
        }];
    }];

    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOK];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


@end
