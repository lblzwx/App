//
//  Example.m
//  App
//
//  Created by 李保路 on 14-12-3.
//  Copyright (c) 2014年 IT-Hamal. All rights reserved.
//

#import "Example.h"


#import "LoadingView.h"

@interface Example ()

@property (nonatomic ,assign) NSInteger selectedCount;
@property (nonatomic, strong) LoadingView *friendlyLoadingView;

@end

@implementation Example

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _friendlyLoadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    
    __weak typeof(self) weakSelf = self;
    self.friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        // 这里可以做网络重新加载的地方
        NSLog(@"---");
        [weakSelf showLoading];
    };
    [self.view addSubview:self.friendlyLoadingView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showLoading];
}

- (void)showLoading {
    [self.friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
    
    double delayInSeconds = 3.0;
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        self.selectedCount ++;
        if (self.selectedCount == 3) {
            [weakSelf.friendlyLoadingView showFriendlyLoadingViewWithText:@"重新加载失败，请返回检查网络。" loadingAnimated:NO];
        } else {
            [weakSelf.friendlyLoadingView showReloadViewWithText:@"加载失败，请点击刷新按钮重新加载。"];
        }
    });
}
@end