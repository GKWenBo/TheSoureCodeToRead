//
//  ViewController.m
//  Demo
//
//  Created by WENBO on 2021/6/9.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()

@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testCommand];
}

- (void)testCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            [subscriber sendNext:@"2"];
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:@{}];
            [subscriber sendError:error];
//            [subscriber sendCompleted];
            return nil;
        }];
    }];
    self.command = command;
    
    [[command.executionSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest = %@", x);
    }];
    
    [self.command.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"error = %@", x);
    }];
    
    [[self.command execute:@"1"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal = %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error");
    } completed:^{
        NSLog(@"completed");
    }];
}


@end
