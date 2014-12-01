//
//  MJFoundation.m
//  MJExtensionExample
//
//  Created by lblzwx on 14/7/16.
//  Copyright (c) 2013年 lblzwx. All rights reserved.
//

#import "MJFoundation.h"
#import "MJConst.h"

static NSArray *_foundationClasses;

@implementation MJFoundation

+ (void)initialize
{
    _foundationClasses = @[@"NSObject", @"NSNumber",@"NSArray", @"NSURL", @"NSMutableURL",@"NSMutableArray",@"NSData",@"NSMutableData",@"NSDate",@"NSDictionary",@"NSMutableDictionary",@"NSString",@"NSMutableString",@"NSException"];
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    MJAssertParamNotNil2(c, NO);
    return [_foundationClasses containsObject:NSStringFromClass(c)];
}
@end
