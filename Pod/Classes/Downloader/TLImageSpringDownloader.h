//
//  TLImageSpringDownloader.h
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,TLImageSpringDownloaderExcutionOrder){
    /**
     *  默认实现，下载操作将会执行先进先出的顺序
     */
   TLImageSpringDownloaderFIFOExecutionOrder,
    /**
     *  下载操作将会执行进栈的方式（最先进去的，最后一个出来）
     */
   TLImageSpringDownloaderLIFOExecutionOrder
};

/**
 *  下载的策略
 */
typedef NS_ENUM(NSInteger,TLImageSpringDownloadOptions) {
    /**
     *  <#Description#>
     */
    TLImageSpringDownloadLowPriority=1 << 0,
    /**
     *  进入后台后，仍然在下载
     */
    TLImageSpringDownloadContinueInBackground=1<<1
};

/**
 *  定义进度条的Block
 *
 *  @param receivedSize 接收的size大小
 *  @param expectedSize 剩余size大小
 */
typedef void(^TLImageSpringProgroessBlock)(NSInteger receivedSize, NSInteger expectedSize);;

/**
 *  定义下载完成时的block
 *
 *  @param image    下载后的图片对象
 *  @param data     二进制文件
 *  @param error    下载过程中出现的错误
 *  @param finished 标志是否下载完成
 */
typedef void(^TLImageSpringDownloadFinishBlock)(UIImage *image,NSData *data,NSError *error,BOOL finished);

typedef void(^TLImageBlock)();

@interface TLImageSpringDownloader : NSObject


/**
 *  下载的超时时间(秒)
 */
@property (nonatomic) NSTimeInterval  downloadTimerOut;

/**
 *  下载操作的执行顺序
 */
@property (nonatomic) TLImageSpringDownloaderExcutionOrder excutionOrder;

/**
 *  单例的实现方法
 *
 *  @return TLImageSpringDownloader
 */
+(TLImageSpringDownloader*)sharedInstance;


/**
 *  通过给定的图片的url创建一个异步下载的实例
 *
 *  @param url           图片的服务器地址
 *  @param processBlock  进度条的回调函数
 *  @param finishedBlock 下载完成后的回调函数
 *
 *  @return 
 */
-(void)downloadImgWithURL:(NSURL *)url
               progress:(TLImageSpringProgroessBlock)processBlock
             isFinished:(TLImageSpringDownloadFinishBlock)finishedBlock;

/**
 *  挂起当前正在下载的线程
 *
 *  @param flag 是否挂起线程
 */
-(void)suspendCurrentDownload:(BOOL)flag;

@end
