# TLImageSpring
<<<<<<< HEAD

[![CI Status](http://img.shields.io/travis/Andrew/TLImageSpring.svg?style=flat)](https://travis-ci.org/Andrew/TLImageSpring)
[![Version](https://img.shields.io/cocoapods/v/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)
[![License](https://img.shields.io/cocoapods/l/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)
[![Platform](https://img.shields.io/cocoapods/p/TLImageSpring.svg?style=flat)](http://cocoapods.org/pods/TLImageSpring)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

##Demo pictures
![1](http://7xsn4e.com2.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.20.27.png)

![2](http://7xsn4e.com2.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.20.38.png)

![3](http://7xsn4e.com2.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.20.55.png)

![4](http://7xsn4e.com2.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.20.58.png)

![5](http://7xsn4e.com2.z0.glb.clouddn.com/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.21.04.png)


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

我提供了两种扩展文件来支持异步加载图片

1. UIImageView+TLSpring.h 支持在UIImageview中设置图片服务器地址
2. UIImageView+UIActivityIndicatorForTLImageSpring.h 不仅支持设置图片的路径，而且支持加载一个菊花的转子

导入 `#import <TLImageSpring/UIImageView+TLSpring.h>`
或者 `#import <TLImageSpring/UIImageView+UIActivityIndicatorForTLImageSpring.h>`

一般都是通过UIimageView来加载图片的，我提供了方便的API去调用


###普通控件上调用
```
 NSString *urlString=@"http://www.weather.com.cn/data/cityinfo/101010100.html";
 NSURL *url=[NSURL URLWithString:urlString];
 [_bgImgView1 TL_setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"map"]];
   
  //调用带有转子提示的API             
 //[_bgImgView1 setImageWithURL:url usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
```

带有转子的API:

```
[_iconIv setImageWithURL:url
 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
```

###支持block回调

```
 [_iconIv TL_setImageWithURL:url
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                completionBlock:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
                    //....完成回调的代码
                }];
```

带有转子的API

```
[_iconIv setImageWithURL:url
            placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
```


###异步下载支持下载的进度条提示

```
    [_iconIv TL_setImageWithURL:url
     placeholderImage:UIImage imageNamed:@"placeholder.png"] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     //进度条提示可以在这里完成
        
    } completionBlock:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        //下载成功或者失败的处理代码
    }];
```

使用带有转子的API

```
[_iconIv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         
                     } completed:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
                         
                     } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
