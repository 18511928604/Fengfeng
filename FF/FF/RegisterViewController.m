//
//  RegisterViewController.m
//  FF
//
//  Created by lx on 15/12/27.
//  Copyright © 2015年 lx. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *pwConfirmTF;
- (IBAction)okBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)okBtnClicked:(id)sender {
    
    //检测输入
    if (self.accountTF.text.length < 1 || self.pwTF.text.length < 1) {
        return;
    }
    
    if (![self.pwTF.text isEqualToString:self.pwConfirmTF.text]) {
        return;
    }
    
    [FFXMPPManager sharedXmppManager] 
    
    
    
}

- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
