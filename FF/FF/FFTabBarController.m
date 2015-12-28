//
//  FFTabBarController.m
//  FF
//
//  Created by lx on 15/12/5.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "FFTabBarController.h"
#import "FFXMPPManager.h"
#import "LoginViewController.h"


@interface FFTabBarController ()

@end

@implementation FFTabBarController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    LoginViewController * loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
    
    if (![FFXMPPManager sharedXmppManager].xmppStream.isConnected) {
        [self presentViewController:loginVC animated:YES completion:^{
            
        }];
    }
}



@end
