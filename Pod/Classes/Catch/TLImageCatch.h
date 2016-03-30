//
//  TLImageCatch.h
//  Pods
//   缓存处理的类
//  Created by Andrew on 16/3/29.
//
//

#import <Foundation/Foundation.h>

typedef void(^TLImageCatchNoParamsBlock)();

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

//在缓存中保存的时间周期，以秒为单位
@property (nonatomic) NSInteger maxCatchAge;
//在缓存中存贮的最大字节
@property (nonatomic) NSInteger maxCatcheSize;




/**
 *  单例方法
 *
 *  @return 单例
 */
+(TLImageCatch*)sharedInstance;

/**
 *  初始化一个新的缓存目录
 *
 *  @param ns 目录
 *
 *  @return
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 *  根据key对图片进行存储
 *
 *  @param image 图片
 *  @param key   对应的key
 */
-(void)storeImage:(UIImage *)image forkey:(NSString *)key;

/**
 *  存贮图片到硬盘上
 *
 *  @param image  图片资源
 *  @param key    对应的key
 *  @param toDisk 是否存储到硬盘上
 */
-(void)storeImage:(UIImage *)image forkey:(NSString *)key toDisk:(BOOL)toDisk;

-(void)storeImage:(UIImage *)image
recalculateFromImage:(BOOL)recalculate
        imageDate:(NSData*)imageData
           forkey:(NSString *)key
           toDisk:(BOOL)toDisk;





@end
