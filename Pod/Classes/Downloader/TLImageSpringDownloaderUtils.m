//
//  TLImageSpringDownloaderUtils.m
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import "TLImageSpringDownloaderUtils.h"
#import "TLDateUtils.h"
#import <ImageIO/ImageIO.h>
#import "TLGlobalConfig.h"
#import "SDWebImageCompat.h"

NSString *const TLImageErrorDomain = @"TLImageErrorDomain";

@interface TLImageSpringDownloaderUtils()<NSURLSessionDataDelegate>{
    size_t widht,height;
    
    UIImageOrientation imageOrientation;
}

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
        NSURLSessionDataTask *dataTask=[_urlSession dataTaskWithRequest:_request];
        //启动
        [dataTask resume];
        
        NSLog(@"进入到%s，时间是:%@,当前线程是:%@",__FUNCTION__,
              [TLDateUtils getCurrentDate],[NSThread currentThread]);
        
        if(_urlSession){
          
            CFRunLoopRun();
          
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

-(void)cancelUrlSessionAndStop{
    if(self.finished){
        return;
    }
    [self cancelUrlSession];
    CFRunLoopStop(CFRunLoopGetCurrent());
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

+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
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

-(void)forceDone{
    self.executing=NO;
    self.finished=YES;
    [self resetOperation];
}

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return SDScaledImageForKey(key, image);
}

#pragma mark
#pragma mark NSURlSession delegate

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    //允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseBecomeDownload);
    
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



// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.mutableImageData appendData:data];
    // 处理每次接收的数据
    if((self.downloadOptions & TLImageSpringDownloadProgressiveDownload)&&self.expectedSize>0 && self.finishBlock){
     
        //获取下载的所有字节
        const NSInteger totalSize=self.mutableImageData.length;
        
        //更新数据源
        CGImageSourceRef imageSource=CGImageSourceCreateWithData((__bridge CFDataRef)self.mutableImageData, NULL);
        //如果没有接收到图片bytes
        if(widht+height==0){
            CFDictionaryRef properties=CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
            if(properties){
                NSInteger orientationValue=-1;
                CFTypeRef val=CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
                if(val){
                    CFNumberGetValue(val, kCFNumberLongLongType, &height);
                }
                val=CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
                
                if(val){
                    CFNumberGetValue(val, kCFNumberLongLongType, &widht);
                }
                val=CFDictionaryGetValue(val, kCGImagePropertyOrientation);
                
                if(val){
                    CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
                }
                
                CFRelease(properties);
            }
        }
        //如果接收到了图片数据
        if(widht+height>0 && totalSize<self.expectedSize){
           //创建图像
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
            if(imageRef){
                const size_t partialHeight=CGImageGetHeight(imageRef);
                CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
                CGContextRef bmContext=CGBitmapContextCreate(NULL, widht, height, 8, widht*4, colorSpace, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                
                if(bmContext){
                    CGRect rect=CGRectMake(0, 0, widht, partialHeight);
                    
                    CGContextDrawImage(bmContext, rect, imageRef);
                    CGImageRelease(imageRef);
                    
                    imageRef=CGBitmapContextCreateImage(bmContext);
                    CGContextRelease(bmContext);
                    
                }else{
                    CGImageRelease(imageRef);
                    imageRef=nil;
                }
            }
            
            if(imageRef){
                UIImage *image=[UIImage imageWithCGImage:imageRef scale:1 orientation:imageOrientation];
                
                CGImageRelease(imageRef);
                
                //在主线程回调
                dispatch_sync_mainThread(^{
                    if(self.finishBlock){
                        self.finishBlock(image,nil,nil,NO);
                    }
                });
            }
        }
        CFRelease(imageSource);
    }
    if(self.progroessBlock){
        self.progroessBlock(self.mutableImageData.length,self.expectedSize);;
    }
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"最终处理");
    NSLog(@"进入到%s，时间是:%@,当前线程是:%@",__FUNCTION__,
          [TLDateUtils getCurrentDate],[NSThread currentThread]);
    
    //加上同步锁
    //@synchronized(self) {
        //如果下载出错了
        if(error){
            if(self.finishBlock){
                self.finishBlock(nil,nil,error,YES);
            }
            self.finishBlock=nil;
            [self forceDone];
        }else{
            NSLog(@"成功下载到了图片");
            [self finishDownloadHandler];
        }
    //}
}

/**
 *  下载完成的处理函数
 */
-(void)finishDownloadHandler{
    if(self.finishBlock){
        if(self.mutableImageData){
            UIImage *image=[UIImage imageWithData:self.mutableImageData];
            NSString *key = [self.request.URL absoluteString];
            
            //对图片进行压缩
            image = [self scaledImageForKey:key image:image];
            
            
            if(CGSizeEqualToSize(image.size, CGSizeZero)){
                self.finishBlock(nil, nil, [NSError errorWithDomain:TLImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Downloaded image has 0 pixels"}], YES);
            }else{
                self.finishBlock(image,self.mutableImageData,nil,YES);
            }
        }else{//图片是空的
            NSError *error=[NSError errorWithDomain:TLImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"图片是空的"}];
            _finishBlock(nil,nil,error,YES);
        }
    }
    
    self.finishBlock=nil;
    [self forceDone];
}



@end













