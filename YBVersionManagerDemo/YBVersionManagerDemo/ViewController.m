//
//  ViewController.m
//  YBVersionManagerDemo
//
//  Created by asance on 2017/11/30.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "ViewController.h"
#import "YBVersionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [YBVersionManager updateWithTitle:@"test" content:@"test" version:90 url:nil mustUpdate:YES];
}

@end
