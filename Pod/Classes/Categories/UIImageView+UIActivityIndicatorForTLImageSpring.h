//
//  UIImageView+UIActivityIndicatorForTLImageSpring.h
//  Pods
//
//  Created by Andrew on 16/4/5.
//
//

#import <UIKit/UIKit.h>
#import <TLImageSpring/TLImageCatch.h>
#import <TLImageSpring/UIImageView+TLSpring.h>

@interface UIImageView (UIActivityIndicatorForTLImageSpring)

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 
 *  @param activityStyle UIActivityIndicatorViewStyleWhiteLarge,
                         UIActivityIndicatorViewStyleWhite,
                         UIActivityIndicatorViewStyleGray
                         三种样式
 */
- (void)setImageWithURL:(NSURL *)url
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 *  @param placeholder   占位符图片
 *  @param activityStyle 转子显示的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 *  @param placeholder   占位符图片
 *  @param options       图片的下载策略
 *  @param activityStyle 转子显示的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param options        下载策略
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param options        下载的策略
 *  @param progressBlock  进度条回调函数
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
               progress:(TLImageSpringProgroessBlock)progressBlock
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle;

/**
 *  移除转子
 */
- (void)removeActivityIndicator;
@end
