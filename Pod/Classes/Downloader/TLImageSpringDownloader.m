//
//  TLImageSpringDownloader.m
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import "TLImageSpringDownloader.h"
#import "SDNetworkActivityIndicator.h"
#import "TLImageSpringDownloaderUtils.h"

@interface TLImageSpringDownloader ()
@property (nonatomic,strong)NSOperationQueue *downloadQueue;
@property (nonatomic,strong)NSOperation *lastedOperation;

@property (nonatomic,strong)NSMutableDictionary *HttpHeaders;

/**
 *  所有的下载操作在这个线程中完成
 */
@property (nonatomic,strong) dispatch_queue_t responseQueue;


@end


@implementation TLImageSpringDownloader

+(TLImageSpringDownloader*)sharedInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance=[[self alloc] init];
    });
    return instance;
}
-(id)init{
    self=[super init];
    if(self){
        _excutionOrder=TLImageSpringDownloaderFIFOExecutionOrder;
        _downloadQueue=[[NSOperationQueue alloc]init];
        //配置queue的最大并发操作数量
        _downloadQueue.maxConcurrentOperationCount=10;
       
        //封装请求头 Accept指定客户端能够接收的内容类型
        _HttpHeaders = [@{@"Accept": @"image/*;q=0.8"} mutableCopy];
        
      _responseQueue=dispatch_queue_create("com.tongli.tlimagespringDownloader", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimerOut=10;
    }
    return self;
}

/**
 *  根据请求头的key返回对应的value值
 *
 *  @param field 请求头的key
 *
 *  @return 请求头对应的value
 */
-(NSString *)valueForHttpHeaderField:(NSString *)field{
    return self.HttpHeaders[field];
}

-(void)downloadImgWithURL:(NSURL *)url
               progress:(TLImageSpringProgroessBlock)processBlock
             isFinished:(TLImageSpringDownloadFinishBlock)finishedBlock{
    __weak typeof (self)weakSelf=self;
    
    __block TLImageSpringDownloaderUtils *operation;
    
    [self checkQueueForUrl:url processBlock:processBlock finishedBlock:finishedBlock callBackBlock:^{
        NSTimeInterval timeInterval=weakSelf.downloadTimerOut;
        if(!timeInterval==0.0){
            timeInterval=10.0;
        }
     
        //创建request请求
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:timeInterval];
        
        //创建一个NSOperation,启动一个异步线程进行下载
        operation=[[TLImageSpringDownloaderUtils alloc]initWithRequest:request process:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } finished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
        } tlImageBlock:^{
            
        }];
        
        [weakSelf.downloadQueue addOperation:operation];
        
    }];

}

/**
 *  确保所有的下载操作都在同一个线程组中进行
 *
 *  @param url           下载的路径
 *  @param processBlock  进度条的回调
 *  @param finishedBlock 下载完成的回调
 *  @param callback      检查完后的回调函数
 */
-(void)checkQueueForUrl:(NSURL*)url
           processBlock:(TLImageSpringProgroessBlock)processBlock
          finishedBlock:(TLImageSpringDownloadFinishBlock)finishedBlock
          callBackBlock:(TLImageBlock)callback{
    
    if(!url){
        return;
    }
    
    dispatch_barrier_sync(self.responseQueue, ^{
        callback();
    });

}


/**
 *  挂起线程
 *
 *  @param flag
 */
-(void)suspendCurrentDownload:(BOOL)flag{
    [self.downloadQueue setSuspended:flag];
}
@end
