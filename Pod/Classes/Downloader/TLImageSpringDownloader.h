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
 *  挂起当前正在下载的线程
 *
 *  @param flag 是否挂起线程
 */
-(void)suspendCurrentDownload:(BOOL)flag;

@end
