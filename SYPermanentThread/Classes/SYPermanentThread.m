
#import "SYPermanentThread.h"

@interface SYPermanentThread()

@property (strong, nonatomic) NSThread * thread;

@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end

@implementation SYPermanentThread

- (instancetype)init {
    if (self= [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.thread = [[NSThread alloc] initWithBlock:^{
            /// 线程保活 子线程的runloop不会主动开启 开启后如果没有任务 线程会在执行完任务后销毁 因此需要添加任务到runloop中 保持线程存活
            [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            
            /// run方法是无法停止的
            while (!weakSelf.isStopped && weakSelf) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        self.thread.name = @"SYPermanentThread";
    }
    return self;
}

- (void)executeTask:(void (^)(void))task {
    if (!self.thread || !task) return;
    if (!self.thread.isExecuting) {
        [self.thread start];
    }
    /// waitUntilDone: 是否需要等待线程任务执行完成后再执行其他代码
    [self performSelector:@selector(_executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)stop {
    if (!self.thread || !self.thread.isExecuting) return;
    [self performSelector:@selector(_stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

#pragma mark - 私有方法

- (void)_executeTask:(void (^)(void))task {
    task();
}

- (void)_stop {
    self.stopped = YES;
    [self.thread cancel];
    self.thread = nil;
}

- (void)dealloc {
    /// 不能调用_stop 因为主动调用_stop 线程是当前的线程 而不是我们开启的子线程
    [self stop];
}

@end
