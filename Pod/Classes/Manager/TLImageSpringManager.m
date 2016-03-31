//
//  TLImageSpringManager.m
//  Pods
//
//  Created by Andrew on 16/3/25.
//
//

#import "TLImageSpringManager.h"
#import "TLGlobalConfig.h"
@interface TLImageSpringManager()
@property (nonatomic,strong)NSMutableSet *failedUrls;


@end


@implementation TLImageSpringManager
+(TLImageSpringManager *)sharedInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

-(id)init{
    self=[super init];
    if(self){
        _tlImageCache=[TLImageCatch sharedInstance];
        _tlImageSpringDownloader=[TLImageSpringDownloader sharedInstance];
        _runningOperations=[[NSMutableArray alloc]init];
        
        _failedUrls=[[NSMutableSet alloc]init];
    }
    return self;
}

/**
    首先检查内存或者硬盘上是否存在该图片，如果存在则直接取出，如果不存在
 *  用指定的url从服务器上下载图片
 *
 *  @param url           图片的服务器地址
 *  @param options       下载的选项
 *  @param progressBlock 进度条函数
 *  @param finishedBlock 下载完成的回调函数
 */
-(void)downloadImageWithURL:(NSURL *)url
                    options:(TLImageSpringOptions)options
                   progress:(TLImageSpringProgroessBlock)progressBlock
                  completed:(TLImageSpringWithFinishedBlock)finishedBlock{

    NSAssert(finishedBlock!=nil, @"finishedBlock不能为空");
    if([url isKindOfClass:NSString.class]){
        url=[NSURL URLWithString:(NSString *)url];
    }
    
    BOOL isFailedUrl=NO;
    @synchronized(self.failedUrls) {
        isFailedUrl=[self.failedUrls containsObject:url];
    }
    //如果证明是一个无效的url
    if(url.absoluteString.length==0 || isFailedUrl){
        dispatch_aync_mainThread(^{
            NSError *error=[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            finishedBlock(nil,error,TLImageCatchTypeNormal,YES,nil);
        });
        return;
    }
    
    NSString *key=[self getStringByURL:url];
    NSOperation *operation=[self.tlImageCache queryDiskCacheForKey:key done:^(UIImage *image, TLImageCatchType cacheType) {
        
        
        //如果没有从内存中找到图片
        if(!image || options & TLImageSpringRefreshCached){
           
        }
        if(image){
            dispatch_sync_mainThread(^{
                finishedBlock(image,nil,cacheType,YES,url);
            });
            return;
        }
        
        
        [self.tlImageSpringDownloader downloadImgWithURL:url downloadOptions:TLImageSpringDownloadLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } finished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if(error){
            //(UIImage *image,NSError *error,TLImageCatchType cacheType,BOOL finished,NSURL *imageUrl)
                dispatch_aync_mainThread(^{
                    finishedBlock(nil,error,cacheType,YES,url);
                });
                
                if (   error.code != NSURLErrorNotConnectedToInternet
                    && error.code != NSURLErrorCancelled
                    && error.code != NSURLErrorTimedOut
                    && error.code != NSURLErrorInternationalRoamingOff
                    && error.code != NSURLErrorDataNotAllowed
                    && error.code != NSURLErrorCannotFindHost
                    && error.code != NSURLErrorCannotConnectToHost) {
                    @synchronized (self.failedUrls) {
                        [self.failedUrls addObject:url];
                    }
                }
            }else{
                if((options & TLImageSpringRetryFailed)){
                    @synchronized(self.failedUrls) {
                        [self.failedUrls removeObject:url];
                    }
                }
                
                BOOL cacheOnDisk=!(options & TLImageSpringCacheMemroyOnly);
                if(image && finished){
                    //把图片缓存起来
                    [self.tlImageCache storeImage:image recalculateFromImage:NO imageDate:data forkey:key toDisk:cacheOnDisk];
                }
                dispatch_aync_mainThread(^{
                    finishedBlock(image,nil,cacheType,YES,url);
                });
            }
        }];
    }];
    
}
/**
 *  用指定的url存储图片到内存中
 *
 *  @param image 图片资源
 *  @param URL   图片对应的服务器地址
 */
-(void)saveImageToCache:(UIImage *)image forURL:(NSURL *)URL{
    if(image && URL){
        NSString *key=[self getStringByURL:URL];
        [_tlImageCache storeImage:image forkey:key toDisk:YES];
    }
}
/**
 *  检查图片是否已经被缓存过了
 *
 *  @param URL 图片对应的URL地址
 *
 *  @return 是否被缓存过了
 */
-(BOOL)checkImageIsExistInMemoryForURL:(NSURL *)URL{
    NSString *key=[self getStringByURL:URL];
    if([self.tlImageCache imageFromMemoryCacheForKey:key]!=nil){
        return YES;
    }
    return NO;
   
}

/**
 *  检查图片是否已经在硬盘上被存储了
 *
 *  @param URL 图片对应的URL地址
 *
 *  @return 是否在硬盘上被缓存过了
 */
-(BOOL)checkImageIsExistInDiskForURL:(NSURL *)URL{
    NSString *key=[self getStringByURL:URL];
   return [self.tlImageCache diskImageExistsWithKey:key];
}

- (BOOL)checkImageIsExistInDiskOrMemoryForURL:(NSURL *)url{
    NSString *key=[self getStringByURL:url];
    if([self.tlImageCache imageFromMemoryCacheForKey:key]!=nil){
        return YES;
    }
    
    return [self.tlImageCache diskImageExistsWithKey:key];
}

/**
 *  异步检查图片是不是已经被缓存了
 *
 *  @param URL             URL地址
 *  @param completionBlock 回调函数
 */
-(void)checkImageIsExistForURL:(NSURL *)URL completion:(TLImageCompletionBlock)completionBlock{
    NSString *key=[self getStringByURL:URL];
    BOOL isInMemory=([self.tlImageCache imageFromMemoryCacheForKey:key])!=nil;
    
    //如果内存中存在
    if(isInMemory){
        //异步调用主线程进行回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completionBlock){
                completionBlock(YES);
            }
        });
        
        return;
    }
    
    //检查硬盘中是否存在
    [self.tlImageCache diskImageExistsWithKey:key completion:^(BOOL isInDisk) {
        //异步调用主线程进行回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completionBlock){
                completionBlock(isInDisk);
            }
        });
    }];
}
/**
 *  获取URL对应的String
 *
 *  @param URL
 *
 *  @return
 */
-(NSString *)getStringByURL:(NSURL *)URL{
    return [URL absoluteString];
}

-(void)cancelAll
{
    @synchronized(self.runningOperations) {
        NSArray *operations=[self.runningOperations copy];
        [operations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:operations];
    }
}

-(BOOL)isRuning{
    BOOL isRuning=NO;
    @synchronized(self.runningOperations) {
        isRuning=self.runningOperations.count>0;
    }
    return isRuning;
}
@end






