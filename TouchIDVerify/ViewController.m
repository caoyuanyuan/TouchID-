//
//  ViewController.m
//  TouchIDVerify
//
//  Created by xiaojingua on 16/10/13.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self useTouchIDBtnClick:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)useTouchIDBtnClick:(id)sender {
    self.showInfoTextView.text = @"";
    NSString *isTouchIDAvailResult;
    __block NSString *evaluateResult;
    LAContext *authContext = [[LAContext alloc] init];
    //步骤1：检查TouchID是否可用
    NSError *err = nil;
    BOOL isTouchIDAvailable = [authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
    if (isTouchIDAvailable) {
        isTouchIDAvailResult = @"TouchID 可以使用\n\n";
        self.showInfoTextView.text = isTouchIDAvailResult;
        //步骤2：获取指纹验证结果
        __weak typeof(self) weakSelf = self;
        [authContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                //验证成功
                evaluateResult = @"恭喜，您通过了Touch ID指纹验证！\n\n";
            }else{
                //失败
                evaluateResult = [NSString stringWithFormat:@"抱歉，您未能通过Touch ID指纹验证！\n err:%@",error];
            }
            __strong typeof(self) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.showInfoTextView.text = [strongSelf.showInfoTextView.text stringByAppendingString:evaluateResult];
            });
            
        }];
    }
    else{
        isTouchIDAvailResult = [NSString stringWithFormat:@"抱歉，Touch ID不可以使用！\n\%@",err];
        self.showInfoTextView.text = isTouchIDAvailResult;
    }
    
}
@end
