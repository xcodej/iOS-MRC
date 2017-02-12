//
//  ViewController.m
//  MRC-NOTE
//
//  Created by xujian on 2017/2/12.
//  Copyright © 2017年 xujian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 * 内存管理四大规则：
 * 1. 自己生成的对象，自己持有
 * 2. 非自己生成的对象，自己也能持有
 * 3. 不再需要自己持有的对象时释放。
 * 4. 非自己持有的对象无法释放。
 * 生成并持有对象 alloc/new/copy/mutableCopy等
 * 持有对象      retain
 * 释放对象      release
 * 废弃对象      dealloc
 * 对象被持有(retain) 引用计数加一
 * 对象被释放(relase) 引用计数减一
 * 当对象的引用计数等于零时废弃(自动调用dealloc)
 **/

- (void)viewDidLoad {
    [super viewDidLoad];
    mrc01();
    mrc02();
    mrc0102();
    mrc03();
    // Do any additional setup after loading the view, typically from a nib.
}

void mrc01() {
    // 使用 alloc、new、copy、mutableCopy开头的方法生成的对象，自己持有
    NSMutableString * str = [[NSMutableString alloc] initWithString:@"src String"];
    printf("%lu\n",[str retainCount]);
}

void mrc02() {
    // 使用类似[NSMutableArray array]方法可以获取对象但自己不持有
    NSMutableString * str = [NSMutableString stringWithString:@"src String"];
    printf("%lu\n",[str retainCount]);
}

void mrc0102() {
    // mrc01() 和 mrc02 看似没什么区别 两个str的retainCount都为1
    NSMutableString * strInited = [[NSMutableString alloc] initWithString:@"src String"];
    printf("%lu\n",[strInited retainCount]);
    NSMutableString * strObjected = [NSMutableString stringWithString:@"src String"];
    printf("%lu\n",[strObjected retainCount]);
    // 其实不然 使用内存管理第四条规则 非自己持有的对象无法释放来一一验证
    [strInited release];
    // 取消备注下一行就会崩溃 企图释放非持有对象而导致崩溃
//    [strObjected release];
}

/**
 * 那么到底谁持有 strObjected?
 * 使用类似 [obj object] 方法 具体实现
 */
- (id) xj_object {
    id obj = [[NSObject alloc] init];
    // 使用object方法获取的对象都放在autoreleasepool中，当对象超出使用范围后会自动的调用release
    [obj autorelease];
    return obj;
}

void mrc03() {
    // 不是自己生成的对象，也能持有
    NSMutableString * strObjected = [NSMutableString stringWithString:@"src String"];
    [strObjected retain];
    printf("%lu\n",[strObjected retainCount]);
    // 此时可以释放 因为自己持有才能释放
    [strObjected release];
}
@end
