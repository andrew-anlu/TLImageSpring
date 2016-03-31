//
//  UIImageView+TLSpring.h
//  Pods
//
//  Created by Andrew on 16/3/31.
//
//

#import <UIKit/UIKit.h>
#import "TLImageSpringManager.h"

#import <objc/runtime.h>
#import <TLGlobalConfig.h>



@interface UIImageView (TLSpring)
/**
 *  获取当前的image的url
 *
 *  @return
 */
-(NSURL *)TL_imageURL;

/**
 *  设置当前Imageview的URL
 *
 *  @param url 图片的服务器地址
 */
-(void)TL_setImageWithURL:(NSURL *)url;
/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url         图片的服务器地址
 *  @param placeholder 占位符图片
 */
-(void)TL_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 并且设置一些下载策略
 *
 *  @param url         图片的服务器地址
 *  @param placeholder 占位符图片
 *  @param options     下载策略
 */
-(void)TL_setImageWithURL:(NSURL *)url
         placeholderImage:(UIImage *)placeholder
                  options:(TLImageSpringOptions)options;
/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url             图片的服务器地址
 *  @param placeholder     占位符图片
 *  @param completionBlock 图片请求成功之后的回调函数
 */
-(void)TL_setImageWithURL:(NSURL *)url
         placeholderImage:(UIImage *)placeholder
          completionBlock:(TLImageSpringWithFinishedBlock)completionBlock;

/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url             图片的服务器地址
 *  @param placeholder     占位符图片
 *  @param progressBlock   监控下载进度的回调函数
 *  @param completionBlcok 图片请求成功之后的回调函数
 */
-(void)TL_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
                 progress:(TLImageSpringProgroessBlock)progressBlock
          completionBlock:(TLImageSpringWithFinishedBlock)completionBlcok;

/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url           图片的服务器地址
 *  @param placeholder   占位符图片
 *  @param options       下载策略
 *  @param progressBlock 监控进度条函数
 *  @param finishedBlock 图片请求成功之后的回调函数
 */
-(void)TL_setImageWithURL:(NSURL *)url
         placeholderImage:(UIImage *)placeholder
                  options:(TLImageSpringOptions)options
                 progress:(TLImageSpringProgroessBlock)progressBlock
                 finished:(TLImageSpringWithFinishedBlock)finishedBlock;

/**
 *  取消当前图片下载
 */
-(void)TL_cancelCurrentImageDownload;



@end
