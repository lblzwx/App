//
//  STDb.m
//  STQuickKit
//
//  Created by yls on 13-11-21.
//
// Version 1.0
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "STDb.h"
#import "STDbObject.h"
#import <objc/runtime.h>

#define DBName @"stdb.sqlite"

#ifdef DEBUG
#ifdef STDBBUG
#define STDBLog(fmt, ...) NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define STDBLog(...)
#endif
#else
#define STDBLog(...)
#endif

enum {
    DBObjAttrInt,
    DBObjAttrFloat,
    DBObjAttrString,
    DBObjAttrData,
    DBObjAttrDate,
    DBObjAttrArray,
    DBObjAttrDictionary,
};

#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"

@interface STDb()

@property (nonatomic) sqlite3 *sqlite3DB;
@property (nonatomic, assign) BOOL isOpened;

@end

@implementation STDb

/**
 *	@brief	单例数据库
 *
 *	@return	单例
 */
+ (instancetype)shareDb
{
    static STDb *stdb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stdb = [[STDb alloc] init];
    });
    return stdb;
}

/**
 *	@brief	打开数据库
 *
 *	@return	成功标志
 */
+ (BOOL)openDb
{
    NSString *dbPath = [STDb dbPath];
    STDb *db = [STDb shareDb];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        
    }
    
    if ([STDb isOpened]) {
//        STDBLog(@"数据库已打开");
        return YES;
    }
    
//    sqlite3 *sqlite3DB = NULL;

    int rc = sqlite3_open_v2([dbPath UTF8String], &db->_sqlite3DB, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (rc == SQLITE_OK) {
//        STDBLog(@"打开数据库%@成功!", dbPath);
        db.isOpened = YES;
        return YES;
    } else {
        STDBLog(@"打开数据库%@失败!", dbPath);
        return NO;
    }

    return NO;
}

/*
 * 关闭数据库；
 */
+ (BOOL)closeDb {
    NSString *dbPath = [STDb dbPath];
    
    STDb *db = [STDb shareDb];
    
    if (![db isOpened]) {
//        STDBLog(@"数据库已关闭");
        return YES;
    }
    
    int rc = sqlite3_close(db.sqlite3DB);
    if (rc == SQLITE_OK) {
//        STDBLog(@"关闭数据库%@成功!", dbPath);
        db.isOpened = NO;
        return YES;
    } else {
        STDBLog(@"关闭数据库%@失败!", dbPath);
        return NO;
    }
    return YES;
}

/**
 *	@brief	数据库路径
 *
 *	@return	数据库路径
 */
+ (NSString *)dbPath
{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", document, DBName];
    return path;
}

/**
 *	@brief	根据aClass创建表
 *
 *	@param 	aClass 	表相关类
 */
+ (void)createDbTable:(Class)aClass
{
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    if ([STDb sqlite_tableExist:aClass]) {
        STDBLog(@"数据库表%@已存在!", NSStringFromClass(aClass));
        return;
    }
    
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"create table "];
    [sql appendString:NSStringFromClass(aClass)];
    [sql appendString:@"("];
    
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    
    [STDb class:aClass getPropertyNameList:propertyArr];
    
    NSString *propertyStr = [propertyArr componentsJoinedByString:@","];
    
    [sql appendString:propertyStr];
    
    [sql appendString:@");"];
    
    char *errmsg = 0;
    STDb *db = [STDb shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    int ret = sqlite3_exec(sqlite3DB,[sql UTF8String],NULL,NULL,&errmsg);
    if(ret != SQLITE_OK){
        fprintf(stderr,"create table fail: %s\n",errmsg);
    }
    sqlite3_free(errmsg);
    
    [STDb closeDb];
}

/**
 *	@brief	插入一条数据
 *
 *	@param 	obj 	数据对象
 */
+ (BOOL)insertDbObject:(STDbObject *)obj
{
    
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    NSString *tableName = NSStringFromClass(obj.class);
    
    if (![STDb sqlite_tableExist:obj.class]) {
        [STDb createDbTable:obj.class];
    }
    
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    [STDb class:obj.class getPropertyKeyList:propertyArr];
    
    NSMutableArray *propertyTypeArr = [NSMutableArray arrayWithCapacity:0];
    [STDb class:obj.class getPropertyTypeList:propertyTypeArr];
    
    unsigned int argNum = [propertyArr count];
    
    NSMutableString *sql_NSString = [[NSMutableString alloc] initWithFormat:@"insert into %@ values(?)", tableName];
    NSRange range = [sql_NSString rangeOfString:@"?"];
    for (int i = 0; i < argNum - 1; i++) {
        [sql_NSString insertString:@",?" atIndex:range.location + 1];
    }
    
    sqlite3_stmt *stmt = NULL;
    STDb *db = [STDb shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    
    const char *errmsg = NULL;
    if (sqlite3_prepare_v2(sqlite3DB, [sql_NSString UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        for (int i = 1; i <= argNum; i++) {
            NSString * key = propertyArr[i - 1];
            
            if ([key isEqualToString:@"uid__"]) {
                break;
            }
            
            NSString *column_type_string = propertyTypeArr[i - 1];
            
            NSString *value = [obj valueForKey:key];
            
            if (value == nil) {
                value = @"";
            }
            if ([column_type_string isEqualToString:@"blob"]) {
                NSData *data = (NSData *)value;
                sqlite3_bind_blob(stmt, i, [data bytes], [data length], NULL);
            } else if ([column_type_string isEqualToString:@"text"]) {
                NSString *column_value = [NSString stringWithFormat:@"%@", value];
                sqlite3_bind_text(stmt, i, [column_value UTF8String], -1, SQLITE_STATIC);
            }
            else if ([column_type_string isEqualToString:@"integer"]) {
                NSString *column_value = value;
                sqlite3_bind_int(stmt, i, [column_value intValue]);
            }
        }
        int rc = sqlite3_step(stmt);
        
        if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
            fprintf(stderr,"insert dbObject fail: %s\n",errmsg);
            sqlite3_finalize(stmt);
            stmt = NULL;
            [STDb closeDb];
            
            return NO;
        }
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDb closeDb];
    
    return YES;
}

/**
 *	@brief	根据条件查询数据
 *
 *	@param 	aClass 	表相关类
 *	@param 	condition 	条件（nil或空或all为无条件），例 id=5 and name='yls'
 *                      带条数限制条件:id=5 and name='yls' limit 5
 *	@param 	orderby 	排序（nil或空或no为不排序）, 例 id,name
 *
 *	@return	数据对象数组
 */
+ (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby
{
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    NSMutableArray *array = nil;
    NSMutableString *selectstring = nil;
    NSString *tableName = NSStringFromClass(aClass);
    
    selectstring = [[NSMutableString alloc] initWithFormat:@"select %@ from %@", @"*", tableName];
    if (condition != nil || [condition length] != 0) {
        if (![[condition lowercaseString] isEqualToString:@"all"]) {
            [selectstring appendFormat:@" where %@", condition];
        }
    }
    if (orderby != nil || [orderby length] != 0) {
        if (![[orderby lowercaseString] isEqualToString:@"no"]) {
            [selectstring appendFormat:@" order by %@", orderby];
        }
    }
    
    STDb *db = [STDb shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    
    unsigned int count;
    
    NSMutableArray *propertyKeyArr = [NSMutableArray arrayWithCapacity:0];
    [STDb class:aClass getPropertyKeyList:propertyKeyArr];
    count = [propertyKeyArr count];
    
    if (sqlite3_prepare_v2(sqlite3DB, [selectstring UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        int column_count = sqlite3_column_count(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {

            STDbObject *obj = [[NSClassFromString(tableName) alloc] init];
            
            for (int i = 0; i < column_count; i++) {
                int column_type = sqlite3_column_type(stmt, i);
                NSString *column_value = nil;
                NSData *column_data = nil;

                NSString * key = propertyKeyArr[i];
                
                switch (column_type) {
                    case SQLITE_INTEGER:
                        column_value = [NSString stringWithFormat:@"%d", sqlite3_column_int(stmt, i)];
                        [obj setValue:column_value forKey:key];
                        break;
                    case SQLITE_TEXT:
                        column_value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(stmt, i)];
                        [obj setValue:column_value forKey:key];
                        break;
                    case SQLITE_BLOB:
                    case SQLITE_NULL:
                        NSLog(@"");
                        const void *databyte = sqlite3_column_blob(stmt, i);
                        int dataLenth = sqlite3_column_bytes(stmt, i);
                        column_data = [NSData dataWithBytes:databyte length:dataLenth];
                        [obj setValue:column_data forKey:key];
                        break;
                    default:
                        break;
                }
            }
            if (array == nil) {
                array = [[NSMutableArray alloc] initWithObjects:obj, nil];
            } else {
                [array addObject:obj];
            }
        }
    }
    
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDb closeDb];
    
    return array;
}

/**
 *	@brief	根据条件删除类
 *
 *	@param 	aClass      表相关类
 *	@param 	condition   条件（nil或空为无条件），例 id=5 and name='yls'
 *                      无条件时删除所有.
 *
 *	@return	删除是否成功
 */
+ (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition
{
    
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    int rc = -1;
    
    sqlite3 *sqlite3DB = [[STDb shareDb] sqlite3DB];
    
    NSString *tableName = NSStringFromClass(aClass);
    
    NSMutableString *createStr;
    
    if ([condition length] > 0) {
        createStr = [NSMutableString stringWithFormat:@"delete from %@ where %@", tableName, condition];
    } else {
        createStr = [NSMutableString stringWithFormat:@"delete from %@", tableName];
    }

    const char *errmsg = 0;
    if (sqlite3_prepare_v2(sqlite3DB, [createStr UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        rc = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDb closeDb];
    if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
        fprintf(stderr,"remove dbObject fail: %s\n",errmsg);
        return NO;
    }
    return YES;
}

/**
 *	@brief	根据条件修改一条数据
 *
 *	@param 	obj 	修改的数据对象（属性中有值的修改，为nil的不处理）
 *	@param 	condition 	条件（nil或空为无条件），例 id=5 and name='yls'
 *
 *	@return	修改是否成功
 */
+ (BOOL)updateDbObject:(STDbObject *)obj condition:(NSString *)condition
{
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    int rc = -1;
    NSString *tableName = NSStringFromClass(obj.class);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    sqlite3 *sqlite3DB = [[STDb shareDb] sqlite3DB];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(obj.class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        NSString *value = [NSString stringWithFormat:@"%@", [obj valueForKey:key]];
        if ([value length] != 0) {
            NSString *str = [NSString stringWithFormat:@"%@='%@'", key, value];
            [propertyArr addObject:str];
        }
    }
    
    NSString *newValue = [propertyArr componentsJoinedByString:@","];
    
    NSMutableString *createStr = [NSMutableString stringWithFormat:@"update %@ set %@ where %@", tableName, newValue,condition];
    
    const char *errmsg = 0;
    if (sqlite3_prepare_v2(sqlite3DB, [createStr UTF8String], -1, &stmt, &errmsg) == SQLITE_OK) {
        rc = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    [STDb closeDb];
    if ((rc != SQLITE_DONE) && (rc != SQLITE_ROW)) {
        fprintf(stderr,"update table fail: %s\n",errmsg);
        return NO;
    }
    return YES;
}

/**
 *	@brief	根据aClass删除表
 *
 *	@param 	aClass 	表相关类
 *
 *	@return	删除表是否成功
 */
+ (BOOL)removeDbTable:(Class)aClass
{
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"drop table if exists "];
    [sql appendString:NSStringFromClass(aClass)];

    char *errmsg = 0;
    STDb *db = [STDb shareDb];
    sqlite3 *sqlite3DB = db.sqlite3DB;
    int ret = sqlite3_exec(sqlite3DB,[sql UTF8String], NULL, NULL, &errmsg);
    if(ret != SQLITE_OK){
        fprintf(stderr,"drop table fail: %s\n",errmsg);
    }
    sqlite3_free(errmsg);
    
    [STDb closeDb];
    
    return YES;
}

#pragma mark - other method

/*
 * 查看所有表名
 */
+ (NSArray *)sqlite_tablename {
    
    if (![STDb isOpened]) {
        [STDb openDb];
    }
    
    sqlite3_stmt *stmt = NULL;
    NSMutableArray *tablenameArray = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"select tbl_name from sqlite_master where type='table'"];
    sqlite3 *sqlite3DB = [[STDb shareDb] sqlite3DB];
    if (sqlite3_prepare_v2(sqlite3DB, [str UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            const unsigned char *text = sqlite3_column_text(stmt, 0);
            [tablenameArray addObject:[NSString stringWithUTF8String:(const char *)text]];
        }
    }
    sqlite3_finalize(stmt);
    stmt = NULL;
    
    [STDb closeDb];
    
    return tablenameArray;
}

/*
 * 判断一个表是否存在；
 */
+ (BOOL)sqlite_tableExist:(Class)aClass {
    NSArray *tableArray = [self sqlite_tablename];
    NSString *tableName = NSStringFromClass(aClass);
    for (NSString *tablename in tableArray) {
        if ([tablename isEqualToString:tableName]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
//    NSString * attr = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
    
    return DBText;
}

+ (BOOL)isOpened
{
    return [[STDb shareDb] isOpened];
}

+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        NSString *type = [STDb dbTypeConvertFromObjc_property_t:property];
        
        NSString *proStr;
        if ([key isEqualToString:@"uid__"]) {
            proStr = [NSString stringWithFormat:@"%@ %@ primary key", @"uid__", DBInt];
        } else {
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        }

        [proName addObject:proStr];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDb class:[aClass superclass] getPropertyNameList:proName];
}

+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [proName addObject:key];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDb class:[aClass superclass] getPropertyKeyList:proName];
}

+ (void)class:(Class)aClass getPropertyTypeList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *type = [STDb dbTypeConvertFromObjc_property_t:property];
        [proName addObject:type];
    }
    
    if (aClass == [STDbObject class]) {
        return;
    }
    [STDb class:[aClass superclass] getPropertyTypeList:proName];
}

@end
