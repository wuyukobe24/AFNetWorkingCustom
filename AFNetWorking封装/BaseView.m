//
//  BaseView.m
//  AFNetWorking封装
//
//  Created by WangXueqi on 2018/5/31.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "BaseView.h"
#import "NetWork.h"

@implementation BaseView

- (IBAction)getButton:(id)sender {
    [NetWork getRequestPath:K_NewsList parameters:nil complete:^(BOOL isSuccess, id root, NSError *error) {
        
    }];
}

- (IBAction)postButton:(id)sender {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"showCount"];
    [NetWork postRequestPath:K_PhotovoltaicList parameters:dict complete:^(BOOL isSuccess, id root, NSError *error) {
        
    }];
}

- (IBAction)uploadImage:(id)sender {
    NSArray * imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"my_bank_card"], nil];
    [NetWork postRequestPath:K_UploadLoanImage parameters:nil images:imageArray name:@"upFile" complete:^(BOOL isSuccess, id root, NSError *error) {
        if (isSuccess) {
            if ([root[@"code"] intValue] == 1) {
                DebugLog(@"%@",root[@"msg"]);
                self.imageView.image = [UIImage imageNamed:@"my_bank_card"];
            }
        }
    }];
}



@end
