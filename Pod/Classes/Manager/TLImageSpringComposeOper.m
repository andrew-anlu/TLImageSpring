//
//  TLImageSpringComposeOper.m
//  Pods
//
//  Created by Andrew on 16/3/31.
//
//

#import "TLImageSpringComposeOper.h"

@implementation TLImageSpringComposeOper

-(void)setCancelBlock:(TLImageNoParamsBlock)cancelBlock{
    if(self.isCanceled){
        if(cancelBlock){
            cancelBlock();
        }
        _cancelBlock=nil;
    }else{
        _cancelBlock=cancelBlock;
    }
}

#pragma mark TLImageSpringOpeProtocol method
-(void)cancelOperation{
    self.canceled=YES;
    if(self.cacheOperation){
        [self.cacheOperation cancel];
        self.cacheOperation=nil;
    }
    
    if(self.cancelBlock){
        self.cancelBlock();
        
        _cancelBlock=nil;
    }
    
}
@end
