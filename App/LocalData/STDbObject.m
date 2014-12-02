//
//  DbObject.m
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
//

#import "STDbObject.h"
#import "STDb.h"

@implementation STDbObject

/**
 *	@brief	插入到数据库中
 */
- (BOOL)insertToDb
{
    return [STDb insertDbObject:self];
}

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 */
- (BOOL)updateToDbsWhere:(NSString *)where
{
    return [STDb updateDbObject:self condition:where];
}

/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)existDbObjectsWhere:(NSString *)where
{
    NSArray *objs = [STDb selectDbObjects:[self class] condition:where orderby:nil];
    if ([objs count] > 0) {
        return YES;
    }
    return NO;
}

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)removeDbObjectsWhere:(NSString *)where
{
    return [STDb removeDbObjects:[self class] condition:where];
}

/**
 *	@brief	根据条件取出某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@param 	orderby 	排序
 *          例：name and age
 *
 *	@return	数据
 */
+ (NSArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby
{
    return [STDb selectDbObjects:[self class] condition:where orderby:orderby];
}

/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)allDbObjects
{
    return [STDb selectDbObjects:[self class] condition:@"all" orderby:nil];
}

@end
