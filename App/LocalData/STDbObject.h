//
//  DbObject.h
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
//

#import <Foundation/Foundation.h>

@protocol STDbObject

@required

/**
 *	@brief	对象id，唯一标志
 */
@property (assign, nonatomic) NSInteger uid__;

/**
 *	@brief	插入到数据库中
 */
- (BOOL)insertToDb;

/**
 *	@brief	更新某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 */
- (BOOL)updateToDbsWhere:(NSString *)where;

/**
 *	@brief	查看是否包含对象
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *
 *	@return	包含YES,否则NO
 */
+ (BOOL)existDbObjectsWhere:(NSString *)where;

/**
 *	@brief	删除某些数据
 *
 *	@param 	where 	条件
 *          例：name='xue zhang' and sex='男'
 *          填入 all 为全部
 *
 *	@return 成功YES,否则NO
 */
+ (BOOL)removeDbObjectsWhere:(NSString *)where;

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
+ (NSMutableArray *)dbObjectsWhere:(NSString *)where orderby:(NSString *)orderby;

/**
 *	@brief	取出所有数据
 *
 *	@return	数据
 */
+ (NSMutableArray *)allDbObjects;

@end

@interface STDbObject : NSObject<STDbObject>

/**
 *	@brief	对象id，唯一标志
 */
@property (assign, nonatomic) NSInteger uid__;

@end
