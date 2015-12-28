//
//  FFXMPPManager.h
//  FF
//
//  Created by lx on 15/12/4.
//  Copyright © 2015年 lx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFXMPPManager : NSObject <XMPPRoomDelegate>


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

#pragma mark - 注册
@property (nonatomic,copy) void(^registerSuccessCallBack)(id resonse);
@property (nonatomic,copy) void(^registerFailuerCallBack)(id response,NSError * error);
- (void)registerWithUserName:(NSString *)userName passWord:(NSString *)password success:(void(^)(id response))successCallBack failuer:(void (^)(id reponse,NSError * error))failuerCallBack;

#pragma mark - 上线
//上线
- (void)goOnline;


#pragma mark - 搜索房间
/**
 *  获取全部房间列表
 */
@property (nonatomic,copy)void (^searchRoomCallBack)(NSMutableArray * roomsArray);
- (void)searchRoomWithCallBack:(void (^)(NSMutableArray * roomsArray))callBack;



#pragma mark - 进入（创建）房间
@property (nonatomic,copy)void (^roomMessageCallBack)(NSDictionary * dict);
@property (nonatomic,copy)void (^roomPresentCallBack)(NSDictionary * dict);

@property (nonatomic,strong)NSMutableDictionary * presentDict;
@property (nonatomic,copy)NSString * nowRoomJid;

-(XMPPRoom*)xmppRoomCreateRoomName:(NSString *)roomName nickName:(NSString *)nickName MessageCallBack:(void(^)(NSDictionary*message))mcb presentCallBack:(void(^)(NSDictionary* present))pcb;

@end





