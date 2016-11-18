//
//  ViewController.m
//  JavaScriptCoreTest
//
//  Created by lihongfeng on 16/11/18.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self OCCallJS];
//    [self JSCallOC];
    [self selectAndExecuteMethod];
    
}

#pragma mark - OC 调用 JS ________________________________________

/**
 OC 调用 JS
 */
- (void)OCCallJS{
    JSContext *context = [[JSContext alloc] init];//上下文
    NSString *js = @"function add(a, b) { return a + b }";//js 脚本
    JSValue *function_add = [self getFunction:@"add" Context:context js:js];//从上下文中获取 add 函数
    JSValue *result = [function_add callWithArguments:@[@(2), @(3)]];//执行 add 函数
    NSLog(@"-----------------result: %d", [result toInt32]);
}

- (JSValue *)getFunction:(NSString *)functionName Context:(JSContext *)context js:(NSString *)jsString{
    [context evaluateScript:jsString];
    return context[functionName];
}

#pragma mark - JS 调用 OC ________________________________________

/**
 JS 调用 OC
 */
- (void)JSCallOC{
    JSContext *context = [[JSContext alloc] init];
    __block __weak typeof(self) weakSelf = self;
    //通过 block 创建 js 中的 add 函数, 在 block 便可以调用 OC 中的方法
    context[@"add"] = ^NSInteger(NSInteger a, NSInteger b){
        return [weakSelf add:a and:b];
    };
    JSValue *result = [context evaluateScript:@"add(2, 4)"];//执行 js 中的 add 函数
    NSLog(@"---------------result: %d", [result toInt32]);
}

- (NSInteger)add:(NSInteger)a and:(NSInteger)b{
    return a + b;
}

#pragma mark - (模拟)从服务端下发脚本, 控制本地执行代码 ___________

//预置本地方法
- (void)selectAndExecuteMethod{
    JSContext *context = [[JSContext alloc] init];
    __block __weak typeof(self) weakSelf = self;
    context[@"function1"] = ^(){
        [weakSelf method1];
    };
    context[@"function2"] = ^(){
        [weakSelf method2];
    };
    
    //执行从服务器获取的 js 脚本
    NSString *js = [self getJSFromService];
    [context evaluateScript:js];
}
- (void)method1{
    NSLog(@"--------------method 1.");
}
- (void)method2{
    NSLog(@"--------------method 2.");
}

//模拟服务器下发脚本
- (NSString *)getJSFromService{
    return @"function1()";
//    return @"function2()";
}

@end
