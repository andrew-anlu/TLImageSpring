//
//  TLImageCatch.m
//  Pods
//
//  Created by Andrew on 16/3/29.
//
//

#import "TLImageCatch.h"

#import <CommonCrypto/CommonDigest.h>

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

-(id)init{
    self=[super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllObject:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)clearAllObject:(NSNotification *)noti{
  
}
@end
