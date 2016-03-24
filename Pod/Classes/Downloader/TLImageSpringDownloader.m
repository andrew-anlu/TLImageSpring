//
//  TLImageSpringDownloader.m
//  Pods
//
//  Created by Andrew on 16/3/24.
//
//

#import "TLImageSpringDownloader.h"
#import "SDNetworkActivityIndicator.h"

@implementation TLImageSpringDownloader
-(void)startDownload{
    SDNetworkActivityIndicator *activitivity=[SDNetworkActivityIndicator sharedActivityIndicator];
    
    [activitivity startActivity];
}
@end
