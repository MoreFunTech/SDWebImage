//
//  SDWebImagePluginManager.h
//  Pods
//
//  Created by Administer on 2022/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SDWebImagePluginFirstDownloadFailureUnit : NSObject

@property (nonatomic, copy) void(^redownloadReadyBlock)(NSString *decodeUrl);

@end

@protocol SDWebImagePluginProtocol <NSObject>

- (SDWebImagePluginFirstDownloadFailureUnit *)firstDownloadFailWithUrl:(NSURL *)url;
- (void *)reDownloadFailWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl;
- (void)downloadSuccessWithOriginUrl:(NSURL *)originUrl decodeUrl:(NSURL *)decodeUrl;

@end

@interface SDWebImagePluginManager : NSObject

@property (nonatomic, weak) id<SDWebImagePluginProtocol> pluginDelegate;

+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
