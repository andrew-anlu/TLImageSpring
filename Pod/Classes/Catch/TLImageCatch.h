//
//  TLImageCatch.h
//  Pods
//   缓存处理的类
//  Created by Andrew on 16/3/29.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TLImageCatchType){
    /**
     *  从服务器上下载
     */
     TLImageCatchTypeNormal,
    /**
     *  从硬盘上获取
     */
    TLImageCatchTypeDISK,
    /**
     *  从内存中获取
     */
    TLImageCatchTypeMemory
    
};

@interface TLImageCatch : NSObject

//是否使用内存进行存储·
@property BOOL shouldCatchImagesInMemory;

//设置能够使用内存存储的最大量
@property (nonatomic) NSUInteger maxMemeoryCost;

@property (nonatomic) NSUInteger maxMemoryCountLimit;
/**
 *  单例方法
 *
 *  @return <#return value description#>
 */
+(TLImageCatch*)sharedInstance;

/**
 *  根据key对图片进行存储
 *
 *  @param image 图片
 *  @param key   对应的key
 */
-(void)storeImage:(UIImage *)image forkey:(NSString *)key;





@end
