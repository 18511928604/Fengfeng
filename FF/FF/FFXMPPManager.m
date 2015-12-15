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
        [self.xmppStream addDelegate:self delegateQueue:nil];
    }

    return self;
}


#pragma mark - connect -

- (void)connectToHost:(NSString *)hostName withMyJid:(NSString *)myJidString success:(void(^)(id response))successCallBack failure:(void (^)(NSError * error))failureCallBack
{
    XMPPJID * jid = [XMPPJID jidWithString:myJidString];
    [self.xmppStream setMyJID:jid];
    [self.xmppStream setHostName:hostName];
    [self.xmppStream setHostPort:5222];
    NSError * error;
    [self.xmppStream connectWithTimeout:0 error:&error];
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












@end
