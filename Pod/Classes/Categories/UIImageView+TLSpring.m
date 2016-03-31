//
//  UIImageView+TLSpring.m
//  Pods
//
//  Created by Andrew on 16/3/31.
//
//

#import "UIImageView+TLSpring.h"
#import "UIView+TLSpringOperation.h"

static char tlImageRuntimeKey;

NSString *const TLImageErrorDomoin=@"TLImageErrorDomoin";

NSString *const TLImagedownloadOperation=@"TLImagedownloadOperation";

@implementation UIImageView (TLSpring)


/**
 *  获取当前的image的url
 *
 *  @return
 */
-(NSURL *)TL_imageURL{
    
}

/**
 *  设置当前Imageview的URL
 *
 *  @param url 图片的服务器地址
 */
-(void)TL_setImageWithURL:(NSURL *)url{
    [self TL_setImageWithURL:url
            placeholderImage:nil
                     options:0
                    progress:nil
                    finished:nil];
}
/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url         图片的服务器地址
 *  @param placeholder 占位符图片
 */
-(void)TL_setImageWithURL:(NSURL *)url
         placeholderImage:(UIImage *)placeholder{
    [self TL_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil finished:nil];
}

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
                  options:(TLImageSpringOptions)options{
    [self TL_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:nil
                    finished:nil];
    
}
/**
 *  设置当前图片的服务器地址，在服务器的图片资源响应之前，用占位图片代替
 *
 *  @param url             图片的服务器地址
 *  @param placeholder     占位符图片
 *  @param completionBlock 图片请求成功之后的回调函数
 */
-(void)TL_setImageWithURL:(NSURL *)url
         placeholderImage:(UIImage *)placeholder
          completionBlock:(TLImageSpringWithFinishedBlock)completionBlock{
    [self TL_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:nil
                    finished:completionBlock];
}

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
          completionBlock:(TLImageSpringWithFinishedBlock)completionBlcok{
    [self TL_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:progressBlock
                    finished:completionBlcok];
}

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
                 finished:(TLImageSpringWithFinishedBlock)finishedBlock{
    
    //用运行时函数把当前的ImageView和 URL进行绑定
    objc_setAssociatedObject(self, &tlImageRuntimeKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(!(options & TLImageSpringDelayPlaceholder)){
        dispatch_aync_mainThread(^{
            self.image=placeholder;
            NSLog(@"执行占位符图片了");
        });
    }
    if([url isKindOfClass:[NSNull class]] || [[url absoluteString] isKindOfClass:[NSNull class]]){
        dispatch_aync_mainThread(^{
            if(finishedBlock){
                NSError *error=[self createNsError];
                finishedBlock(nil,error,TLImageCatchTypeNormal,YES,url);
            }
        });
        return;
    }
   //强制转化成NSURL
    if([url isKindOfClass:NSString.class]){
        url=[NSURL URLWithString:(NSString *)url];
    }
   
    __weak __typeof (self)weakSelf=self;
    
    TLImageSpringManager *springManager=[TLImageSpringManager sharedInstance];
    id<TLImageSpringOpeProtocol> operation=[springManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        
        if(!weakSelf)
            return;
        
        dispatch_aync_mainThread(^{
            if(image){
                weakSelf.image=image;
            }else if((options)&TLImageSpringDelayPlaceholder){
                weakSelf.image=image;
            }
            if(finished && finishedBlock){
                finishedBlock(image,error,cacheType,finished,imageUrl);
            }
        });
    }];
    
     [self TL_setImageLoadOperation:operation forKey:TLImagedownloadOperation];
}

-(NSError *)createNsError{
    NSError *error = [NSError errorWithDomain:TLImageErrorDomoin code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
    return error;
}

/**
 *  取消当前图片下载
 */
-(void)TL_cancelCurrentImageDownload{
    [self TL_cancelImageLoadOperationWithKey:TLImagedownloadOperation];
}
@end
