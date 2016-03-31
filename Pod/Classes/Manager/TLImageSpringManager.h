//
//  TLImageSpringManager.h
//  Pods
//
//  Created by Andrew on 16/3/25.
//
//

#import <Foundation/Foundation.h>
#import "TLImageCatch.h"
#import "TLImageSpringDownloader.h"
#import "TLImageSpringDownloaderUtils.h"



typedef NS_ENUM(NSInteger,TLImageSpringOptions){
    /**
     *  默认值，当一个NSurl下载失败的时候，这个URL会被加入黑名单，不会被记载，
        调用这个选项，可以支持重复尝试
     */
   TLImageSpringRetryFailed=1<<0,
    
    /**
     *  下载图片的时候是在UI主线程上进行，这个属性支持延迟加载，比如在UIscrollView中，
        下面的页面很长，当滑动到时图片才进行下载
     */
   TLImageSpringLowPriority=1<<1,
    /**
     *  仅仅支持内存缓存
     */
    TLImageSpringCacheMemroyOnly=1<<2,
    
    /**
     *  这个属性只是显示下载的进度，默认是当全部下载完后才显示图片的
     */
    TLImageSpringProgressDownload=1<<3,
    /**
     *  这个属性支持刷新缓存的图片，如果请求数据发现服务器的图片资源改变了，则刷新本地缓存
     */
    TLImageSpringRefreshCached=1<<4,
    
    /**
     *  在进入后台后，支持图片继续下载
     */
    TLImageSpringContinueInBackground=1<<5,
    
    /**
     *  默认图片下载是在指定的队列中进行排队下载，一旦设置了这个属性，它就能挤到队列的最前面
     优先执行命令
     */
    TLImageSpringHighPriority=1<<6,
    /**
     *  如果图片资源很大，下载时间会很长，这个属性支持先用一个占位符图片进行填充，
        当图片下载完后进行替换
     */
    TLImageSpringPlaceholdImage=1<<7,
    
    /**
     *  延长占位符图片显示的时间
     */
    TLImageSpringDelayPlaceholder=1<<8
    
};



typedef void(^TLImageSpringWithFinishedBlock)(UIImage *image,NSError *error,TLImageCatchType cacheType,BOOL finished,NSURL *imageUrl);

@interface TLImageSpringManager : NSObject

@property (nonatomic,strong,readonly)TLImageCatch *tlImageCache;
@property (nonatomic,strong,readonly)TLImageSpringDownloader *tlImageSpringDownloader;
@property (strong, nonatomic) NSMutableArray *runningOperations;
+(TLImageSpringManager *)sharedInstance;

/**
    首先检查内存或者硬盘上是否存在该图片，如果存在则直接取出，如果不存在
 *  用指定的url从服务器上下载图片
 *
 *  @param url           图片的服务器地址
 *  @param options       下载的选项
 *  @param progressBlock 进度条函数
 *  @param finishedBlock 下载完成的回调函数
 */
-(id<TLImageSpringOpeProtocol>)downloadImageWithURL:(NSURL *)url
                    options:(TLImageSpringOptions)options
                   progress:(TLImageSpringProgroessBlock)progressBlock
                  completed:(TLImageSpringWithFinishedBlock)finishedBlock;
/**
 *  用指定的url存储图片到内存中
 *
 *  @param image 图片资源
 *  @param URL   图片对应的服务器地址
 */
-(void)saveImageToCache:(UIImage *)image forURL:(NSURL *)URL;
/**
 *  检查图片是否已经被缓存过了
 *
 *  @param URL 图片对应的URL地址
 *
 *  @return 是否被缓存过了
 */
-(BOOL)checkImageIsExistInMemoryForURL:(NSURL *)URL;

/**
 *  检查图片是否已经在硬盘上被存储了
 *
 *  @param URL 图片对应的URL地址
 *
 *  @return 是否在硬盘上被缓存过了
 */
-(BOOL)checkImageIsExistInDiskForURL:(NSURL *)URL;

/**
 *  检查硬盘和内存中是否存在该key
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)checkImageIsExistInDiskOrMemoryForURL:(NSURL *)url;

/**
 *  异步检查图片是不是已经被缓存了
 *
 *  @param URL             URL地址
 *  @param completionBlock 回调函数
 */
-(void)checkImageIsExistForURL:(NSURL *)URL completion:(TLImageCompletionBlock)completionBlock;
/**
 *  获取URL对应的String
 *
 *  @param URL
 *
 *  @return
 */
-(NSString *)getStringByURL:(NSURL *)URL;
/**
 *  取消所有的operation
 */
-(void)cancelAll;

/**
 *  检查当前operation是否正在运行
 *
 *  @return <#return value description#>
 */
-(BOOL)isRuning;



@end
