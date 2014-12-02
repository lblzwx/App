//
//  BLCheckBox.m
//  lblzwx
//
//  Created by 李保路 on 14-11-16.
//  Copyright (c) 2014年 Chinamobo. All rights reserved.
//

#import "BLCheckBox.h"

@interface BLCheckBox ()

@property (nonatomic ,strong) UIButton *checkBox;

@end

@implementation BLCheckBox

-(UIButton *)checkBox{
    if (!_checkBox) _checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
    return _checkBox;
}

-(instancetype)checkBox:(NSString *)title{
    UIButton *checkbox = [[UIButton alloc] init];
    checkbox.selected = YES;
    [checkbox setTitle:title forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    checkbox.bounds = CGRectMake(0, 0, 200, 50);
    [checkbox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    checkbox.titleLabel.font = [UIFont systemFontOfSize:15];
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];

    checkbox.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    checkbox.tag = 101;
    [self addSubview:checkbox];
    return self;
}
- (void)checkboxClick:(UIButton *)checkbox
{
    AppLog(@"---");
    checkbox.selected = !checkbox.isSelected;
}

@end
