//
//  FFXMPPManager.h
//  FF
//
//  Created by lx on 15/12/4.
//  Copyright © 2015年 lx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>


@interface FFXMPPManager : NSObject


@property (nonatomic,strong)XMPPStream * xmppStream;


+ (FFXMPPManager *)sharedXmppManager;



#pragma mark - 连接
/**
 *  连接
 */
@property (nonatomic,copy) void(^connectSuccessCallBack)(id response);
@property (nonatomic,copy) void(^connectFailureCallBack)(NSError *error);

- (void)connectToHost:(NSString *)hostName withUser:(NSString *)userName success:(void(^)(id response))successCallBack failure:(void (^)(NSError * error))failureCallBack;

#pragma mark - 登录
/**
 *  登录
 *  注： 如果未连接到服务器，先连接
 */
@property (nonatomic,copy) void(^loginSuccessCallBack)(id response);
@property (nonatomic,copy) void(^loginFailureCallBack)(id response, NSError *error);
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord success:(void(^)(id response))successCallBack failure:(void (^)(id response,NSError * error))failureCallBack;

#pragma mark - 上线
//上线
- (void)goOnline;


#pragma mark - 搜索房间
@property (nonatomic,copy)void (^searchRoomCallBack)(NSMutableArray * roomsArray);
- (void)searchRoomWithCallBack:(void (^)(NSMutableArray * roomsArray))callBack;


#pragma mark - 进入房间




@end





