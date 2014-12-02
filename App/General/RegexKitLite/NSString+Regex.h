#import <Foundation/Foundation.h>
/**
 *  主要的是做一些简单的正则，过滤一些不想要的
 */
@interface NSString (Regex)

/** 将GBK编码的二进制数据转换成字符串 */
+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data;

/** 查找并返回第一个匹配的文本内容 */
- (NSString *)firstMatchWithPattern:(NSString *)pattern;

/** 查找多个匹配方案结果 */
- (NSArray *)matchesWithPattern:(NSString *)pattern;

/** 查找多个匹配方案结果，并根据键值数组生成对应的字典数组 */
- (NSArray *)matchesWithPattern:(NSString *)pattern keys:(NSArray *)keys;
/**
 *  去除网页里面的标签
 */
+(NSString *)getRidofP:(NSString *)count;
/**
 *  去除超链接
 */
+(NSString *)getRidofHttp:(NSString *)content;
@end
