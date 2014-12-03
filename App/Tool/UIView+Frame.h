
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// @property如果写在分类里面就不会生成成员属性,只会生成get,set方法

// 快速设置控件的frame
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;


@end
