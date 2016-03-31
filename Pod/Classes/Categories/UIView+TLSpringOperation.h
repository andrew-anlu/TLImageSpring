//
//  UIView+TLSpringOperation.h
//  Pods
//  在object-c 运行时处理NSoperation
//  Created by Andrew on 16/3/31.
//
//

#import <UIKit/UIKit.h>

@interface UIView (TLSpringOperation)

/**
 *  用指定的key加载 下载的image的operation
 *
 *  @param operation NsOperation
 *  @param key       存储NsOperation指定的key
 */
-(void)TL_setImageLoadOperation:(id)operation forKey:(NSString *)key;
/**
 *  取消NSOperation
 *
 *  @param key
 */

-(void)TL_cancelImageLoadOperationWithKey:(NSString *)key;

/**
 *  删除NsOperation指定的key
 *
 *  @param key
 */
-(void)TL_removeImageLoadOperationWithKey:(NSString *)key;



@end
