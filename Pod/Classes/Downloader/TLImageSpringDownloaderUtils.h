//
//  TLImageSpringDownloaderUtils.h
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import <Foundation/Foundation.h>
#import "TLImageSpringDownloader.h"

@interface TLImageSpringDownloaderUtils : NSOperation

/**
 *  网络请求
 */
@property (nonatomic,strong,readonly) NSURLRequest *request;


/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 *  相应的数据
 */
@property (nonatomic,strong) NSURLResponse *response;

@property (nonatomic)TLImageSpringDownloadOptions downloadOptions;

/**
 *  初始化一个下载的工具类
 *
 *  @param request       请求
 *  @param processBlock  监控下载进度的回调
 *  @param finishedBlock 下载完成时候的回调
 *  @param tlImageBlock  普通回调
 *
 *  @return 当前实例
 */
-(id)initWithRequest:(NSURLRequest *)request
             process:(TLImageSpringProgroessBlock)processBlock
            finished:(TLImageSpringDownloadFinishBlock)finishedBlock
        tlImageBlock:(TLImageBlock)tlImageBlock;



@end
