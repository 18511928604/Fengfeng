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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerBtnClikced:(id)sender {
    
    
}



- (IBAction)loginBtnClicked:(id)sender {
    
    NSString * jidString = self.accountTF.text;
    NSString * pwString = self.passwordTF.text;
    
    [[FFXMPPManager sharedXmppManager] connectToHost:@"lxdemacbook-pro.local" withMyJid:jidString success:^(id response) {
        
        
        NSLog(@"链接成功");
    } failure:^(NSError *error) {
        
        NSLog(@"链接失败%@",error);
    }];
}
@end
