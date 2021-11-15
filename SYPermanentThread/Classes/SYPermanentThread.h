
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYPermanentThread : NSObject

/**
 开启线程 在子线程执行任务
 */
- (void)executeTask:(void(^)(void))task;

/**
 结束线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
