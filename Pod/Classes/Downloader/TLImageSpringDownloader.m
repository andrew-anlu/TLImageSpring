//
//  TLImageSpringDownloader.m
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import "TLImageSpringDownloader.h"
#import "SDNetworkActivityIndicator.h"

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

/**
 *  挂起线程
 *
 *  @param flag
 */
-(void)suspendCurrentDownload:(BOOL)flag{
    [self.downloadQueue setSuspended:flag];
}
@end
