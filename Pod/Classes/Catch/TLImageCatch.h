//
//  TLImageCatch.h
//  Pods
//   缓存处理的类
//  Created by Andrew on 16/3/29.
//
//

#import <Foundation/Foundation.h>

typedef void(^TLImageCatchNoParamsBlock)();

typedef void(^TLImageCompletionBlock)(BOOL isInCache);


typedef void(^TLImageSpringCalculateSizeBlock)(NSUInteger fileCount,NSUInteger totaoSize);

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

typedef void(^TLImageQueryCompleteBlock)(UIImage *image,TLImageCatchType cacheType);



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

/**
 *  根据key判断硬盘上是否存在这个key
 *
 *  @param key key
 *
 *  @return <#return value description#>
 */
- (BOOL)diskImageExistsWithKey:(NSString *)key;


- (void)diskImageExistsWithKey:(NSString *)key completion:(TLImageCompletionBlock)completionBlock;



#pragma mark Quary --

/**
 *  根据key去内存或者硬盘上 查找图片
 *
 *  @param key 关键字
 *
 *  @return 图片
 */
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;

/**
 *  从内存中查找图片资源
 *
 *  @param key 关键字
 *
 *  @return
 */
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

/**
 *  从硬盘中查找图片资源
 *
 *  @param key 关键字
 *
 *  @return 图片资源
 */
- (UIImage *)diskImageForKey:(NSString *)key;

/**
 * 查询硬盘中的缓存
 *
 *  @param key             key
 *  @param completionBlock 回调函数
 *
 *  @return 一个线程
 */
-(NSOperation *)queryDiskCacheForKey:(NSString *)key
                                done:(TLImageQueryCompleteBlock)completionBlock;


#pragma mark
#pragma mark  删除单个key从内存中或者硬盘中
- (void)removeImageForKey:(NSString *)key;

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 * 获取硬盘缓存的大小
 */
- (NSUInteger)getSize;

/**
 * 获取硬盘上缓存的图片的数量
 */
- (NSUInteger)getDiskCount;
/**
 *  异步的计算出缓存的文件数量和总大小
 *
 *  @param completionBlock 回调函数
 */
-(void)calculateSizeAndCountInDiskWIthCompletion:(TLImageSpringCalculateSizeBlock)completionBlock;

@end
