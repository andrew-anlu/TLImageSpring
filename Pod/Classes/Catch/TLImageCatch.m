//
//  TLImageCatch.m
//  Pods
//
//  Created by Andrew on 16/3/29.
//
//

#import "TLImageCatch.h"

#import <CommonCrypto/CommonDigest.h>
#import "TLEncryptionUtils.h"

@interface AutonsCatch : NSCache

@end

@implementation AutonsCatch


-(id)init{
    self=[super init];
    if(self){
        //当收到缓存警告的时候，主动调用NSCatch的`removeAllObjects`去清空缓存
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end



//一周时间
static const NSInteger kDefaultCatchMaxCatchAge=60 * 60 * 24 * 7;
static unsigned char kPNGSignatureBytes[8] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
static NSData *kPNGSignatureData = nil;

FOUNDATION_STATIC_INLINE NSUInteger TLCacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}
BOOL ImageDataHasPNGPreffix(NSData *data) {
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }
    
    return NO;
}


@interface TLImageCatch()

@property (nonatomic,strong)NSCache *tlNSCatch;
//硬盘存储的路径
@property (nonatomic,strong)NSString *diskCatchPath;

@property (nonatomic,strong)dispatch_queue_t fileQueue;

@property (nonatomic,strong)NSFileManager *fileManager;

@end

@implementation TLImageCatch

+(TLImageCatch*)sharedInstance{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance=[self new];
    });
    return instance;
}
-(id)initWithNamespace:(NSString *)ns{
    //获取缓存的路径
    NSString *path=[self makeDiskCatchPath:ns];
    return [self initWithNamespace:ns diskCatchDirectory:path];
}

-(void)storeImage:(UIImage *)image forkey:(NSString *)key{

}
-(void)storeImage:(UIImage *)image forkey:(NSString *)key toDisk:(BOOL)toDisk{

}

-(id)initWithNamespace:(NSString *)ns diskCatchDirectory:(NSString *)directory{
    self=[super init];
    if(self){
      NSString *fullPath=[@"com.tongli.tlImageSpringCatch." stringByAppendingString:ns];
        kPNGSignatureData=[NSData dataWithBytes:kPNGSignatureBytes length:8];
        
        //创建一个IOxiancheng
        _fileQueue=dispatch_queue_create("com.tongli.tlImageSpringCatch", DISPATCH_QUEUE_SERIAL);
        
        //初始化
        _maxCatchAge=kDefaultCatchMaxCatchAge;
        //缓存
        _tlNSCatch=[[NSCache alloc]init];
        _tlNSCatch.name=fullPath;
        
        if(directory!=nil){
            _diskCatchPath=[directory stringByAppendingPathComponent:fullPath];
        }else{
            NSString *path=[self makeDiskCatchPath:ns];
            _diskCatchPath=path;
        }
        
        //是否支持缓存
        _shouldCatchImagesInMemory=YES;
        
        dispatch_sync(_fileQueue, ^{
            _fileManager=[[NSFileManager alloc]init];
        });
        
        //在收到内存警告后，主动清空缓存
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}

#pragma mark
#pragma mark  初始化硬盘缓存的路径
-(NSString *)makeDiskCatchPath:(NSString *)nameSpace{
    //用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *catchDir = [paths objectAtIndex:0];
    
    return  [catchDir stringByAppendingPathComponent:nameSpace];
}

#pragma mark == 缓存 ==
-(NSString *)cachePathForkey:(NSString *)key inpath:(NSString *)path{
    //对文件名进行md5加密
    NSString *fileName=[self cachedFilenameForkey:key];
    return [path stringByAppendingPathComponent:fileName];
    
}

-(NSString *)defaultCachePathForKey:(NSString *)key{
    return [self cachePathForkey:key inpath:self.diskCatchPath];
}


/**
 *  完全清空缓存
 */
-(void)clearMemory{
    [self.tlNSCatch removeAllObjects];
}
/**
 *  部分清空硬盘缓存
 */
-(void)cleanDisk{

}
/**
 *  完全清空
 *
 *  @param complete <#complete description#>
 */
-(void)clearDiskOnCompletion:(TLImageCatchNoParamsBlock)complete{
    //异步处理
    dispatch_async(self.fileQueue, ^{
        [_fileManager removeItemAtPath:_diskCatchPath error:nil];
        
        if(complete){
          dispatch_async(dispatch_get_main_queue(), ^{
              complete();
          });
        }
    });
}

/**
 *  部分清空硬盘的存储
 *
 *  @param completionBlock 完成回调函数
 */
-(void)cleanDiskWithCompletionBlock:(TLImageCatchNoParamsBlock)completionBlock{
 dispatch_async(self.fileQueue, ^{
     NSURL *diskCacheUrl=[NSURL fileURLWithPath:self.diskCatchPath isDirectory:YES];
     //获取文件的一些属性
     /**
      *  @ NSURLIsDirectoryKey 是否是目录的key
         @ NSURLContentModificationDateKey 文件的更新日期的key
         @ NSURLTotalFileAllocatedSizeKey 文件的size的key
      */
     NSArray *resourceKeys=@[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
     
     //文件目录的遍历对象
     NSDirectoryEnumerator *fileEnumerator=[_fileManager enumeratorAtURL:diskCacheUrl includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
     
     //算出过期日期
     NSDate *expirateDate=[NSDate dateWithTimeIntervalSinceNow:-self.maxCatchAge];
     
     NSMutableDictionary *cacheFiles=[[NSMutableDictionary alloc]init];
     NSUInteger currentCacheSize=0;
     
     /**
      *  遍历目录中所有的文件，删除过期的文件，按照文件的大小进行排序
      */
     
     NSMutableArray *urlsToDelete=[[NSMutableArray alloc]init];
     
     for (NSURL *fileUrl in fileEnumerator) {
         NSDictionary *resourceValues=[fileUrl resourceValuesForKeys:resourceKeys error:NULL];
         //如果是目录(或者说是文件夹),则跳过
         if([resourceValues[NSURLIsDirectoryKey] boolValue]){
             continue;
         }
         //移除过期的文件
         NSDate *modifyFileDate=resourceValues[NSURLContentModificationDateKey];
         
         if([[modifyFileDate laterDate:expirateDate] isEqualToDate:expirateDate]){
             //加入到要删除的目录数组中
             [urlsToDelete addObject:fileUrl];
             continue;
         }
         
         NSNumber *totalAllocatedSize=resourceValues[NSURLTotalFileAllocatedSizeKey];
         currentCacheSize+=[totalAllocatedSize unsignedIntegerValue];
         //一个路径对应一个文件的字典属性
         [cacheFiles setObject:resourceValues forKey:fileUrl];
     }
     
     //删除过期的文件
     for (NSURL *deleteFileUrl in urlsToDelete) {
         [_fileManager removeItemAtURL:deleteFileUrl error:NULL];
     }
     
     //当前的缓存的大小大于规定容纳的最大值
     if(self.maxCatcheSize>0 && currentCacheSize>self.maxCatcheSize){
         const NSUInteger disiredCacheSize=self.maxCatcheSize/2;
         //按照时间排序，最新的时间排在第一位
         
         NSArray *sortedFiles=[cacheFiles keysSortedByValueWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
             return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
         }];
         
         //删除文件直到达到我们期望的缓存大小
         for (NSURL *fileURL in sortedFiles) {
             if([_fileManager removeItemAtURL:fileURL error:nil]){
                 NSDictionary *resourceValues = cacheFiles[fileURL];
                 NSNumber *totalAllocatedSize=resourceValues[NSURLContentModificationDateKey];
                 currentCacheSize-=[totalAllocatedSize unsignedIntegerValue];
                 if(currentCacheSize<disiredCacheSize){
                     break;
                 }
             }
         }
     }
     
     if(completionBlock){
         dispatch_async(dispatch_get_main_queue(), ^{
             completionBlock();
         });
     }
 });
}

/**
 *  系统进入后台后清空缓存
 */
-(void)backgroundCleanDisk{
    Class UIApplicationClass=NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]){
        return;
    }
    
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    
    __block UIBackgroundTaskIdentifier bgTask=[application beginBackgroundTaskWithExpirationHandler:^{
        
        //清空那些还没有完成工作的任务
        [application endBackgroundTask:bgTask];
        
        bgTask=UIBackgroundTaskInvalid;
    }];
    //在后台进行一些清理内存的工作，完成之后立马结束当前线程
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask=UIBackgroundTaskInvalid;
    }];
}



#pragma mark private method
-(NSString *)cachedFilenameForkey:(NSString *)key{
    return [TLEncryptionUtils md5:key];
}

-(void)storeImage:(UIImage *)image
recalculateFromImage:(BOOL)recalculate
        imageDate:(NSData*)imageData
           forkey:(NSString *)key
           toDisk:(BOOL)toDisk{

    if(!image || !key){
        return;
    }
    //如果支持内存缓存
    if(self.shouldCatchImagesInMemory){
        NSUInteger cost=TLCacheCostForImage(image);
        [self.tlNSCatch setObject:image forKey:key cost:cost];
    }
    //如果要往硬盘上存储
    if(toDisk){
       //异步操作
        dispatch_async(self.fileQueue, ^{
            NSData *data=imageData;
            if(image && (recalculate || !data)){
                int alphaInfo = CGImageGetAlphaInfo(image.CGImage);
                BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                                  alphaInfo == kCGImageAlphaNoneSkipFirst ||
                                  alphaInfo == kCGImageAlphaNoneSkipLast);
                BOOL imageIsPng = hasAlpha;
                
                if([imageData length]>=[kPNGSignatureData length]){
                    imageIsPng=ImageDataHasPNGPreffix(imageData);
                }
                
                //如果是PNG图片
                if(imageIsPng){
                    data=UIImagePNGRepresentation(image);
                }else{
                    data=UIImageJPEGRepresentation(image, 1.0);
                }
            }
            
            if(data){
                if(![_fileManager fileExistsAtPath:_diskCatchPath]){
                    [_fileManager createDirectoryAtPath:_diskCatchPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                //获取图片的缓存路径
                NSString *cachePathForKey=[self defaultCachePathForKey:key];
                [_fileManager createFileAtPath:cachePathForKey contents:data attributes:nil];
            }
        });
    }
}




@end
