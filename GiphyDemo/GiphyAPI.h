//
//  GiphyAPI.h
//  GiphyDemo
//
//  Created by Dana Devoe on 5/17/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import <Foundation/Foundation.h>

/* This object handles the retrieval, searching of trending and random aninmated GIFs
 All provide it data in a completion block which is called once the images have been loaded or if their is an error
 if error is non-nil, there was a error and the array will be nil, otherwise the array should contain and array
 of GiphyModel data
 */

@class GiphyModel;
@class UIImage;
@interface GiphyAPI : NSObject

- (void) search:(NSString * _Nonnull )term completion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block;
- (void) gifID:(NSString * _Nonnull )gifID completion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block;
- (void) randomWithCompletion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block;
- (void) trendingWithCompletion:(void(^ _Nonnull )(NSArray<GiphyModel *> * _Nullable giphies,NSError * _Nullable error))block;

- (void) loadImageFromGiphy:(NSString * _Nonnull)urlString withCompletion:(void (^ _Nonnull)(UIImage * _Nullable theImage,NSError * _Nullable error))block;

@end
