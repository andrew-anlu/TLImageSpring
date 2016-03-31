//
//  TLImageSpringOpeProtocol.h
//  Pods
//
//  Created by Andrew on 16/3/31.
//
//

#import <Foundation/Foundation.h>

@protocol TLImageSpringOpeProtocol <NSObject>
/**
 *  取消线程操作
    用户可以调用取消图片下载的操作
 */
@optional
-(void)cancelOperation;
@end
