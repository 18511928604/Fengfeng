//
//  FFXMPPManager.m
//  FF
//
//  Created by lx on 15/12/4.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "FFXMPPManager.h"

@interface FFXMPPManager ()<XMPPStreamDelegate>

@end

@implementation FFXMPPManager

+ (FFXMPPManager *)sharedXmppManager
{
    static FFXMPPManager * _xmppManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xmppManager = [[FFXMPPManager alloc] init];
    });
    return _xmppManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }

    return self;
}


#pragma mark - connect -

- (void)connectToHost:(NSString *)hostName withUser:(NSString *)userName success:(void(^)(id response))successCallBack failure:(void (^)(NSError * error))failureCallBack
{
    hostName = @"lxdeMacBook-Pro.local";
    userName = @"longxin223";
    
    self.connectSuccessCallBack = successCallBack;
    self.connectFailureCallBack = failureCallBack;
    XMPPJID * jid = [XMPPJID jidWithUser:userName domain:hostName resource:kJidResource];
    [self.xmppStream setMyJID:jid];
    [self.xmppStream setHostName:hostName];
    [self.xmppStream setHostPort:5222];
    NSError * error;
    [self.xmppStream connectWithTimeout:10 error:&error];
}


#pragma mark - connect Delegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s",__func__);
    if (self.connectSuccessCallBack) {
        self.connectSuccessCallBack(sender);
    }
}


- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s",__func__);
    if (self.connectFailureCallBack) {
        NSError *error = [NSError errorWithDomain:@"123" code:123 userInfo:nil];
        self.connectFailureCallBack(error);
    }
}

#pragma mark - login -
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord success:(void (^)(id))successCallBack failure:(void (^)(id response,NSError *))failureCallBack
{
    
    self.loginSuccessCallBack = successCallBack;
    self.loginFailureCallBack = failureCallBack;
    
    void (^connectBlock)(void) = ^(){
        NSError * error;
        [self.xmppStream authenticateWithPassword:passWord error:&error];
        if (error) {
            NSLog(@"登录出错：%@",error);
        }
    };
    
    
    if (self.xmppStream.isConnected) {
        connectBlock();
    }
    else
    {
        [self connectToHost:kXMPPHost withUser:userName success:^(id response) {
            NSError * error;
            [self.xmppStream authenticateWithPassword:passWord error:&error];
            if (error) {
                NSLog(@"登录出错：%@",error);
            }
        } failure:^(NSError *error) {
            NSLog(@"链接出错");
        }];
    }
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (self.loginSuccessCallBack) {
        self.loginSuccessCallBack(self);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (self.loginFailureCallBack) {
        NSError * error_1 = [NSError errorWithDomain:error.stringValue code:0 userInfo:nil];
        self.loginFailureCallBack(self,error_1);
    }
    
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];

    [_xmppStream sendElement:presence];
}




@end
