//
//  UIView+TLSpringOperation.m
//  Pods
//
//  Created by Andrew on 16/3/31.
//
//

static char loadOperationKey;

#import "UIView+TLSpringOperation.h"
#import <objc/runtime.h>
#import "TLImageSpringOpeProtocol.h"

@implementation UIView (TLSpringOperation)

-(NSMutableDictionary *)createOperationDict{
    NSMutableDictionary *dict=objc_getAssociatedObject(self, &loadOperationKey);
    if(dict){
        return dict;
    }
    dict=[[NSMutableDictionary alloc]init];
    objc_setAssociatedObject(self, &loadOperationKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return dict;
}

/**
 *  用指定的key加载 下载的image的operation
 *
 *  @param operation NsOperation
 *  @param key       存储NsOperation指定的key
 */
-(void)TL_setImageLoadOperation:(id)operation forKey:(NSString *)key{
    [self TL_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *dict=[self createOperationDict];
    [dict setObject:operation forKey:key];
}
/**
 *  取消NSOperation
 *
 *  @param key
 */

-(void)TL_cancelImageLoadOperationWithKey:(NSString *)key{
    NSMutableDictionary *operationsDict=[self createOperationDict];
    id operations=operationsDict[key];
    if(operations){
        if([operations isKindOfClass:[NSArray class]]){
            for (id<TLImageSpringOpeProtocol> springOperation in operations) {
                if(springOperation){
                    NSLog(@"进入到取消操作队列中");
                    [springOperation cancelOperation];
                }
            }
        }else if([operations conformsToProtocol:@protocol(TLImageSpringOpeProtocol)]){
            NSLog(@"进入到取消操作队列中");
            [(id<TLImageSpringOpeProtocol>)operations cancelOperation];
        }
        [operationsDict removeObjectForKey:key];
    }
}

/**
 *  删除NsOperation指定的key
 *
 *  @param key
 */
-(void)TL_removeImageLoadOperationWithKey:(NSString *)key{
 NSMutableDictionary *dict=[self createOperationDict];
    [dict removeObjectForKey:key];
}
@end
