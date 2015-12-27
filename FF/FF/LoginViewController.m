//
//  LoginViewController.m
//  FF
//
//  Created by lx on 15/12/5.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "LoginViewController.h"
#import "FFXMPPManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)registerBtnClikced:(id)sender;

- (IBAction)loginBtnClicked:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountTF.text = @"longxin123";
    self.passwordTF.text = @"1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerBtnClikced:(id)sender {
    
    
}



- (IBAction)loginBtnClicked:(id)sender {
    
    NSString * userNameString = self.accountTF.text;
    NSString * pwString = self.passwordTF.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [[FFXMPPManager sharedXmppManager] loginWithUserName:userNameString passWord:pwString success:^(id response) {
        
        [[FFXMPPManager sharedXmppManager] goOnline];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        NSLog(@"链接成功");

    } failure:^(id response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });

        NSLog(@"链接失败%@",error);

    }];
    
}
@end
