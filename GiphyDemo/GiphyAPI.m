//
//  GiphyAPI.m
//  GiphyDemo
//
//  Created by Dana Devoe on 5/17/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import "GiphyAPI.h"
#import <AFNetworking/AFNetworking.h>

#import "GiphyEndPoint.h"
#import "GiphyQueryResultModel.h"
#import "UIGifImage.h"


@interface GiphyAPI()
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@end

@implementation GiphyAPI


#pragma mark - Lazy Initializer
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return _sessionManager;
}

#pragma mark - Public Methods
- (void) search:(NSString * _Nonnull )term completion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block
{
    NSString *urlString = [GiphyEndPoint searchURLFor:[self formatSearchTerm:term]];
    
    [self retreiveGiphyFromEndPoint:urlString completion:block];
}

- (void) gifID:(NSString * _Nonnull )gifID completion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block
{
    NSString *urlString = [GiphyEndPoint gifIDURLFor:[self formatSearchTerm:gifID]];
    
    [self retreiveGiphyFromEndPoint:urlString completion:block];
}

- (void) randomWithCompletion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block
{
    NSString *urlString = [GiphyEndPoint randomGifURL];
    
    [self retreiveGiphyFromEndPoint:urlString completion:block];
}

- (void) trendingWithCompletion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block
{
    NSString *urlString = [GiphyEndPoint trendingGifURL];
    
    [self retreiveGiphyFromEndPoint:urlString completion:block];
}

- (void) loadImageFromGiphy:(NSString * _Nonnull)urlString withCompletion:(void (^ _Nonnull)(UIImage * _Nullable theImage,NSError * _Nullable error))block
{
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.sessionManager GET:urlString
                      parameters:nil
                        progress:NULL
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
                             NSData *imageData = responseObject;
                             UIGifImage *gif = [UIGifImage imageWithData:imageData];
                             
                             block(gif,nil);
                         }
                         failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
                             NSLog( @"error = %@",error );
                             block(nil,error);
                         }];
        
    } );
}

#pragma mark - Help Methods
- (NSString *)formatSearchTerm:(NSString *)searchTerm
{
    NSArray *terms = [searchTerm componentsSeparatedByString:@" "];
    NSMutableString *results = [[NSMutableString alloc] init];
    
    for (NSString *string in terms) {
        [results appendFormat:@"%@%@",results.length ? @"+" : @"",string];
    }
    
    return results;
}

- (void) retreiveGiphyFromEndPoint:(NSString *)urlString completion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [self.sessionManager GET:urlString
                      parameters:nil
                        progress:^(NSProgress *downloadProgress){
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject){
                             
                             @try
                             {
                                 NSError *error;
                                 GiphyQueryResultModel *giphyQueryModel;
                                 
                                 //There seems to be a bug with AFNetworking and it returns a NSData object sometimes
                                 if ( [responseObject isKindOfClass:NSData.class] ) {
                                     giphyQueryModel = [[GiphyQueryResultModel alloc ]initWithData:responseObject error:&error];
                                 }
                                 else{
                                     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                                                        options:NSJSONWritingPrettyPrinted
                                                                                          error:&error];
                                     
                                     giphyQueryModel = [[GiphyQueryResultModel alloc ]initWithData:jsonData error:&error];
                                 }
                                 
                                 block( giphyQueryModel.data,nil );
                             }
                             @catch(NSException *exception){
                                 block( nil, [NSError errorWithDomain:@"Exception"  code:-1 userInfo:@{ @"error" : exception}]);
                             }
                         }
                         failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
                             NSLog( @"error = %@",error );
                             block(nil,error);
                         }];
        
    });    
}

@end
