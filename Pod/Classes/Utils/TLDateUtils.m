//
//  TLDateUtils.m
//  Pods
//
//  Created by Andrew on 16/3/27.
//
//

#import "TLDateUtils.h"

@implementation TLDateUtils
+(NSString *)getCurrentDate{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormattter=[[NSDateFormatter alloc]init];
    dateFormattter.dateFormat=@"hh:mm:ss";
    
    NSString *currentTime=[dateFormattter stringFromDate:date];
    return  currentTime;
                  
}
@end
