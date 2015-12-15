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
@property (nonatomic,assign)BOOL isConnected;


@end


@interface FFXMPPManager (connection)


@property (nonatomic,copy) void(^connectSuccessCallBack)(id response);
@property (nonatomic,copy) void(^connectFailureCallBack)(NSError *error);


- (void)connectToHost:(NSString *)hostName withMyJid:(NSString *)myJid success:(void(^)(id response))successCallBack failure:(void (^)(NSError * error))failureCallBack;

@end





