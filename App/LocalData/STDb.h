//
//  STDb.h
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
// Version 1.0
//
/**
 // 声明一个继承STDbObject的类；
 例：@interface STUser : STDbObject
 
 // 查询
 1. 查询全部
 NSArray *users = [STUser allDbObjects];
 2. 按条件查询
 NSArray *users = [STUser dbObjectsWhere:@"_id=0" orderby:nil];
 
 // 修改数据
 先从数据库中取出实体类
 NSArray *users = [STUser dbObjectsWhere:@"_id=0" orderby:nil];
 if ([users count] > 0) {
 STUser *user = users[0];
 // 修改姓名
 user.name = "xue zhang";
 // 更新到数据库
 [user updateToDbsWhere:@"_id=0"];
 }
 
 // 插入数据
 STUser *defaultUser = [[STUser alloc] init];
 defaultUser.name = @"admin";
 defaultUser.age = 20;
 defaultUser.sex = @1;
 defaultUser._id = 0;
 // 插入到数据库
 [defaultUser insertToDb];
 
 // 删除
 NSString *where = [NSString stringWithFormat:@"uid__=%d", user.uid__];
 [STUser removeDbObjectsWhere:where];
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class STDbObject;

@interface STDb : NSObject

/**
 *	@brief	根据aClass创建表
 *
 *	@param 	aClass 	表相关类
 */
+ (void)createDbTable:(Class)aClass;

/**
 *	@brief	插入一条数据
 *
 *	@param 	obj 	数据对象
 */
+ (BOOL)insertDbObject:(STDbObject *)obj;

/**
 *	@brief	根据条件查询数据
 *
 *	@param 	aClass 	表相关类
 *	@param 	condition 	条件（nil或空为无条件），例 id=5 and name='yls'
 *                      带条数限制条件:id=5 and name='yls' limit 5
 *	@param 	orderby 	排序（nil或空为不排序）, 例 id,name
 *
 *	@return	数据对象数组
 */
+ (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby;

/**
 *	@brief	根据条件删除类
 *
 *	@param 	aClass      表相关类
 *	@param 	condition   条件（nil或空为无条件），例 id=5 and name='yls'
 *                      无条件时删除所有.
 *
 *	@return	删除是否成功
 */
+ (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition;

/**
 *	@brief	根据条件修改一条数据
 *
 *	@param 	obj 	修改的数据对象（属性中有值的修改，为nil的不处理）;
 *	@param 	condition 	条件（nil或空为无条件），例 id=5 and name='yls'
 *
 *	@return	修改是否成功
 */
+ (BOOL)updateDbObject:(STDbObject *)obj condition:(NSString *)condition;

/**
 *	@brief	根据aClass删除表
 *
 *	@param 	aClass 	表相关类
 *
 *	@return	删除表是否成功
 */
+ (BOOL)removeDbTable:(Class)aClass;


@end
