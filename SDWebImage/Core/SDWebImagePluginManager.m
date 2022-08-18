//
//  SDWebImagePluginManager.m
//  Pods
//
//  Created by Administer on 2022/8/18.
//

#import "SDWebImagePluginManager.h"

@implementation SDWebImagePluginManager

+ (instancetype)shareManager {
    static id p = nil ;//1.声明一个空的静态的单例对象
    static dispatch_once_t onceToken; //2.声明一个静态的gcd的单次任务
    dispatch_once(&onceToken, ^{ //3.执行gcd单次任务：对对象进行初始化
        if (p == nil) {
            p = [[self alloc] init];
        }
    });
    return p;
}


@end
