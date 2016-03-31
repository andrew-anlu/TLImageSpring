//
//  TLImageSpringComposeOper.h
//  Pods
//  这是一个组合的操作类
//  Created by Andrew on 16/3/31.
//
//

#import <Foundation/Foundation.h>
#import "TLImageSpringOpeProtocol.h"
#import "TLImageSpringManager.h"
#import "TLGlobalConfig.h"

@interface TLImageSpringComposeOper : NSObject<TLImageSpringOpeProtocol>

@property (getter=isCanceled) BOOL canceled;
@property (nonatomic,strong)TLImageNoParamsBlock cancelBlock;
@property (nonatomic,strong)NSOperation *cacheOperation;



@end
