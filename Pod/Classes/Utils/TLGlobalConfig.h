//
//  TLGlobalConfig.h
//  Pods
//
//  Created by Andrew on 16/3/28.
//
//

#ifndef TLGlobalConfig_h
#define TLGlobalConfig_h


typedef void(^TLImageNoParamsBlock)();

//在主线程同步调用
#define dispatch_sync_mainThread(block)\
    if([NSThread isMainThread]){\
       block();\
    }else{\
        dispatch_sync(dispatch_get_main_queue(),block);\
    }

//在主线程异步调用
#define dispatch_aync_mainThread(block)\
    if([NSThread isMainThread]){\
       block();\
    } else{\
      dispatch_async(dispatch_get_main_queue(),block);\
}



#endif /* TLGlobalConfig_h */
