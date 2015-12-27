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

#pragma mark - room -

#pragma mark - room list
/**
 *  request for get roomlist
 */
- (void)searchRoomWithCallBack:(void (^)(NSMutableArray * roomsArray))callBack
{
    self.searchRoomCallBack = callBack;
    
    /*
     <iq type="get" to="conference.1000phone.net" id="disco2"><query xmlns="http://jabber.org/protocol/disco#items"></query></iq>
     */
    
    NSXMLElement * query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    XMPPJID * proxyCandidateJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@.%@",kGround,kXMPPHost]];
    
    XMPPIQ * iq = [XMPPIQ iqWithType:@"get" to:proxyCandidateJid elementID:@"disco2" child:query];
    [self.xmppStream sendElement:iq];
}

/**
 *  response for get roomlist
 */
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    /*
     <iq xmlns="jabber:client" type="result" id="disco2" from="conference.admin-88ixf99az" to="admin@admin-88ixf99az/IOS">
     <query xmlns="http://jabber.org/protocol/disco#items">
     <item jid="room2@conference.admin-88ixf99az" name="&#x7279;"></item>
     <item jid="room3@conference.admin-88ixf99az" name="room3"></item>
     <item jid="room4@conference.admin-88ixf99az" name="room4"></item>
     </query>
     </iq>
     */

    DDXMLNode* idXML = [iq attributeForName:@"id"];
    
    NSString * idString = [idXML stringValue];

    if ([idString isEqualToString:@"disco2"]) {
        NSArray * array = [iq elementsForName:@"query"];
        
        NSXMLElement * query = [array firstObject];
        
        DDXMLNode *nameSpace = [[query namespaces] firstObject];
        
        if ([[nameSpace stringValue] isEqualToString:@"http://jabber.org/protocol/disco#info"]) {
            
            DDXMLNode * type = [iq attributeForName:@"type"];
            if ([[type stringValue] isEqualToString:@"error"]) {
                self.searchRoomCallBack(nil);
                return YES;
            }
            
            NSArray*field=  [[[query elementsForName:@"x"]firstObject]elementsForName:@"field"];
            NSString*str=[[[[field objectAtIndex:1]elementsForName:@"value"]firstObject]stringValue];
            if (str.length==0) {
                str=@"没有描述";
            }
            //主题
            NSString*str1=[[[[field objectAtIndex:2]elementsForName:@"value"]firstObject]stringValue];
            if (str1.length==0) {
                str1=@"没有主题";
            }
            //人数限制
            NSString*str2=[[[[field objectAtIndex:3]elementsForName:@"value"]firstObject]stringValue];
            if (str2.length==0) {
                str2=@"0";
            }
            //创建日期
            NSString*str3=[[[[field objectAtIndex:4]elementsForName:@"value"]firstObject]stringValue];
            //@"subject":str1,
            DDXMLNode*idXML1=  [iq attributeForName:@"from"];
            //转换为字符串
            NSString*str4=  [idXML1 stringValue];
            
            NSDictionary*dic=@{@"des":str,@"num":str2,@"time":str3,@"from":str4};
            
//            self.searchRoomCallBack(dic);
            return YES;
        }
        
        array = [query elementsForName:@"item"];
        
        NSMutableArray*roomArray=[NSMutableArray arrayWithCapacity:0];
        for (NSXMLElement*item in array) {
            NSMutableDictionary*room=[NSMutableDictionary dictionaryWithCapacity:0];
            
            DDXMLNode*jid=   [item attributeForName:@"jid"];
            DDXMLNode*name= [item attributeForName:@"name"];
            [room setValue:[jid stringValue] forKey:@"roomJid"];
            [room setValue:[name stringValue] forKey:@"roomName"];
            
            [roomArray addObject:room];
        }
        if (self.searchRoomCallBack) {
            self.searchRoomCallBack(roomArray);
        }
    }

    return YES;
}

#pragma mark - create room
-(XMPPRoom*)xmppRoomCreateRoomName:(NSString *)roomName nickName:(NSString *)nickName MessageCallBack:(void(^)(NSDictionary* message))mcb presentCallBack:(void(^)(NSDictionary* present))pcb{
    //记录block指针，以及相应的房间jid，为消息接口准备
    self.roomMessageCallBack = mcb;
    self.roomPresentCallBack = pcb;
    //对出席列表字典初始化
    self.presentDict=[NSMutableDictionary dictionaryWithCapacity:0];
    NSString*str=[[roomName componentsSeparatedByString:@"@"]firstObject];
    self.nowRoomJid=str;
    //@"room2@conference.127.0.0.1"
    //指定的房间号 如果没有就创建
    XMPPRoom* room = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@.%@",roomName,kGround,kXMPPHost]] dispatchQueue:dispatch_get_main_queue()];
    //激活
    [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [room activate:self.xmppStream];
//    [userDefaults removeObjectForKey:GROUNDROOMCONFIG];
    //使用的昵称 进入房间的函数
    [room joinRoomUsingNickname:nickName history:nil];
    [room configureRoomUsingOptions:nil];
    return room;    
}

#pragma mark - room delegate
- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
    NSLog(@"已经销毁房间");
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    NSLog(@"已经创建房间");
}

- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    
}



@end
