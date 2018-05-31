//
//  ViewController.m
//  AFNetWorking封装
//
//  Created by WangXueqi on 2018/5/31.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "BaseView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseView * base = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BaseView class]) owner:self options:nil] firstObject];
    [self.view addSubview:base];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
