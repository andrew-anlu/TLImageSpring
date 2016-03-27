//
//  TLImageSpringDownloaderUtils.m
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import "TLImageSpringDownloaderUtils.h"
#import "TLDateUtils.h"

@interface TLImageSpringDownloaderUtils()<NSURLSessionTaskDelegate>

@property (nonatomic,strong)TLImageSpringDownloadFinishBlock finishBlock;
@property (nonatomic,strong)TLImageSpringProgroessBlock progroessBlock;
@property (nonatomic,strong)TLImageBlock tlImageBlock;

@property (nonatomic,getter=isFinished)  BOOL finished;
@property (nonatomic,getter=isExecuting) BOOL executing;
@property (nonatomic,strong)NSURLSession *urlSession;

@property (nonatomic,strong)NSMutableData *mutableImageData;
@property  UIBackgroundTaskIdentifier backgroundTaskId;
@end


@implementation TLImageSpringDownloaderUtils

@synthesize executing=_executing;
@synthesize finished=_finished;

-(id)initWithRequest:(NSURLRequest *)request
             process:(TLImageSpringProgroessBlock)processBlock
            finished:(TLImageSpringDownloadFinishBlock)finishedBlock
        tlImageBlock:(TLImageBlock)tlImageBlock{
    self=[super init];
    if(self){
        _request=request;
        _progroessBlock=processBlock;
        _finishBlock=finishedBlock;
        _tlImageBlock=tlImageBlock;
    }
    return self;
}


/**
 *  重写NSOperation的start()方法
 */
-(void)start{
    
    //加同步锁
    @synchronized(self) {
        if(self.isCancelled){
            self.finished=YES;
            [self resetOperation];
            return;
        }
        
        //用映射类名 创建
        Class UIApplicationClass=NSClassFromString(@"UIApplication");
        BOOL application=UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if(application && [self isContinueDownloadWhenEnterBackground]){
            __weak __typeof (self)weakSelf=self;
            
            UIApplication *app=[UIApplication performSelector:@selector(sharedApplication)];
            self.backgroundTaskId=[app beginBackgroundTaskWithExpirationHandler:^{
                __block typeof (weakSelf)sself=weakSelf;
                
                if(sself){
                    [sself cancel];
                    [app endBackgroundTask:(sself.backgroundTaskId)];
                    sself.backgroundTaskId=UIBackgroundTaskInvalid;
                }
            }];
        }
        
        self.executing=YES;
        
        //创建NSUrlSession
       
        NSURLSessionConfiguration *defaultConfigure=[NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession=[NSURLSession sessionWithConfiguration:defaultConfigure delegate:self delegateQueue:nil];
        NSURLSessionTask *dataTask=[_urlSession dataTaskWithRequest:_request];
        //启动
        [dataTask resume];
        
        if(_urlSession){
          
          
        }else{
            if(self.finishBlock){
                NSError *error=[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSLocalizedDescriptionKey : @"urlSession初始化失败"}];
                self.finishBlock(nil,nil,error,YES);
            }
            
        }
    }

    //进入到后台后继续下载
    Class UIApplicationClass=NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]){
        return;
    }
    if(self.backgroundTaskId !=UIBackgroundTaskInvalid){
        UIApplication *app=[UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId=UIBackgroundTaskInvalid;
    }

   
}

/**
 *  重写NSOperation的main()方法
 */
-(void)main{
  NSLog(@"执行:%s",__FUNCTION__);
}

-(void)cancel{
   NSLog(@"执行:%s",__FUNCTION__);
    
    @synchronized(self) {
        [self cancelUrlSession];
    }
}
-(void)cancelUrlSession{
  if(self.isFinished)
      return;
    
    [super cancel];
    if(self.tlImageBlock){
        self.tlImageBlock();
    }
    
    if(_urlSession){
        if(self.isExecuting){
            self.executing=NO;
        }
        if(!self.isFinished){
            self.finished=YES;
        }
    }
    
    [self resetOperation];
    
}



-(BOOL)isContinueDownloadWhenEnterBackground{
    return self.downloadOptions & TLImageSpringDownloadContinueInBackground;
}


-(void)resetOperation{
    self.tlImageBlock=nil;
    self.finishBlock=nil;
    self.progroessBlock=nil;
    self.mutableImageData=nil;
    
    
}

#pragma mark Setter finished And executing
-(void)setFinished:(BOOL)finished{
    [self willChangeValueForKey:@"isFinished"];
    _finished=finished;
    [self didChangeValueForKey:@"isFinished"];
}

-(void)setExecuting:(BOOL)executing{
    [self willChangeValueForKey:@"isExecuting"];
    _executing=executing;
    [self didChangeValueForKey:@"isExecuting"];
}


#pragma mark
#pragma mark NSURlSession delegate

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    //允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    
    NSInteger statusCode=[((NSHTTPURLResponse*)response) statusCode];
    
    if(![response respondsToSelector:@selector(statusCode)]||
       statusCode<400 ||
       statusCode!=304){
        NSInteger expected=response.expectedContentLength>0?response.expectedContentLength:0;
        self.expectedSize=expected;
        if(self.progroessBlock){
            self.progroessBlock(0,expected);
        }
        self.mutableImageData=[[NSMutableData alloc]initWithCapacity:expected];
        self.response=response;
        
    }else{
        if(statusCode==304){
            [self cancelUrlSession];
        }else{
            [self.urlSession invalidateAndCancel];
        }
        if(self.finishBlock){
            NSError *error=[NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil];
            self.finishBlock(nil,nil,error,YES);
        }
        
        [self forceDone];
    }
    
}

-(void)forceDone{
    self.executing=NO;
    self.finished=YES;
    [self resetOperation];
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
   
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"最终处理");
    NSLog(@"进入到%s，时间是:%@,当前线程是:%@",__FUNCTION__,
          [TLDateUtils getCurrentDate],[NSThread currentThread]);
}
@end













