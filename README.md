# TLImageSpring
<<<<<<< HEAD

[![CI Status](http://img.shields.io/travis/Andrew/TLImageSpring.svg?style=flat)](https://travis-ci.org/Andrew/TLImageSpring)
[![Version](https://img.shields.io/cocoapods/v/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)
[![License](https://img.shields.io/cocoapods/l/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)
[![Platform](https://img.shields.io/cocoapods/p/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## advantage
这是一个简单易用的图片下载框架，它采用多线程来下载图片，异步加载不影响主线程，使得过程相当流畅。

1. 多线程异步下载
2. 加入了缓存机制，内存缓存+硬盘缓存
3. API简单易用


## Installation

TLImageSpring is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TLImageSpring"
```

## How to use

导入 `#import <TLImageSpring/UIImageView+TLSpring.h>`

一般都是通过UIimageView来加载图片的，我提供了方便的API去调用

```
 NSString *urlString=@"http://www.weather.com.cn/data/cityinfo/101010100.html";
 NSURL *url=[NSURL URLWithString:urlString];
 [_bgImgView1 TL_setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"map"]];
```

## APIS

```
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
```

## Author

Andrew, anluanlu123@163.com

我的邮箱:Andrewswift1987@gmail.com

## License

TLImageSpring is available under the MIT license. See the LICENSE file for more info.
=======
方便的从服务器端下载图片到本地，支持缓存等功能，API简单易用
>>>>>>> 7eca377e21c20e52dd3eb0d935c2f538e7f7d491
