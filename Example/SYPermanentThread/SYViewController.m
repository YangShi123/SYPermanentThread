//
//  SYViewController.m
//  SYPermanentThread
//
//  Created by YangShi123 on 11/15/2021.
//  Copyright (c) 2021 YangShi123. All rights reserved.
//

#import "SYViewController.h"
#import "SYPermanentThread.h"

@interface SYViewController ()

@property (nonatomic, strong) SYPermanentThread * thread;

@end

@implementation SYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.thread = [[SYPermanentThread alloc] init];
}

- (IBAction)excute:(id)sender {
    [self.thread executeTask:^{
        NSLog(@"执行任务-%@", [NSThread currentThread]);
    }];
}

- (IBAction)stop:(id)sender {
    [self.thread stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
