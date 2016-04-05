//
//  UIImageView+UIActivityIndicatorForTLImageSpring.m
//  Pods
//
//  Created by Andrew on 16/4/5.
//
//

#import "UIImageView+UIActivityIndicatorForTLImageSpring.h"
#import <objc/runtime.h>

static char TAG_ACTIVITY_INDICATOR;

@implementation UIImageView (UIActivityIndicatorForTLImageSpring)

@dynamic indicatorView;

-(UIActivityIndicatorView *)indicatorView{
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}
-(void)setIndicatorView:(UIActivityIndicatorView *)indicatorView{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 
 *  @param activityStyle UIActivityIndicatorViewStyleWhiteLarge,
 UIActivityIndicatorViewStyleWhite,
 UIActivityIndicatorViewStyleGray
 三种样式
 */
- (void)setImageWithURL:(NSURL *)url
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    
    [self setImageWithURL:url
         placeholderImage:nil
                  options:0
                 progress:nil
                completed:nil
usingActivityIndicatorStyle:activityStyle];

}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 *  @param placeholder   占位符图片
 *  @param activityStyle 转子显示的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:0
                 progress:nil
                completed:nil
usingActivityIndicatorStyle:activityStyle];

}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url           图片的服务器地址
 *  @param placeholder   占位符图片
 *  @param options       图片的下载策略
 *  @param activityStyle 转子显示的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:options
                 progress:nil
                completed:nil
usingActivityIndicatorStyle:activityStyle];
}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url
         placeholderImage:nil
                  options:0
                 progress:nil
                completed:completedBlock
usingActivityIndicatorStyle:activityStyle];
}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:0
                 progress:nil
                completed:completedBlock
usingActivityIndicatorStyle:activityStyle];
}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param options        下载策略
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
    [self setImageWithURL:url
         placeholderImage:placeholder
                  options:options
                 progress:nil
                completed:completedBlock
usingActivityIndicatorStyle:activityStyle];
}

/**
 *  设置Imageview的图片服务器地址，还没加载成功的时候显示一个UIActivityIndicatorView
 *
 *  @param url            图片的服务器地址
 *  @param placeholder    占位符图片
 *  @param options        下载的策略
 *  @param progressBlock  进度条回调函数
 *  @param completedBlock 下载完成的回调函数
 *  @param activityStyle  转子的样式
 */
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
                options:(TLImageSpringOptions)options
               progress:(TLImageSpringProgroessBlock)progressBlock
              completed:(TLImageSpringWithFinishedBlock)completedBlock
usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle{
  
    [self addActivityIndicator:activityStyle];
    __weak typeof(self) weakSelf=self;
    
    [self TL_setImageWithURL:url
            placeholderImage:placeholder
                    progress:progressBlock
             completionBlock:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        
                 if(completedBlock){
                     completedBlock(image,error,cacheType,finished,imageUrl);
                  }
                 [weakSelf removeActivityIndicator];
    }];
    
}

/**
 *  添加一个转子
 */
-(void)addActivityIndicator:(UIActivityIndicatorViewStyle)style{
    if(!self.indicatorView){
        self.indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:style];
        self.indicatorView.autoresizingMask=UIViewAutoresizingNone;
        
        [self updateActiviIndicatorFrame];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:self.indicatorView];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView startAnimating];
    });
}

-(void)updateActiviIndicatorFrame{
    if(self.indicatorView){
        CGRect activityIndicatorBounds=self.indicatorView.bounds;
        CGFloat originX=self.frame.size.width/2-activityIndicatorBounds.size.width/2;
        CGFloat originY=self.frame.size.height/2-activityIndicatorBounds.size.height/2;
        
        self.indicatorView.frame=CGRectMake(originX, originY, activityIndicatorBounds.size.width, activityIndicatorBounds.size.height);
    }
}

/**
 *  移除转子
 */
- (void)removeActivityIndicator{
    if(self.indicatorView){
        [self.indicatorView removeFromSuperview];
        self.indicatorView=nil;
    }
}
@end
