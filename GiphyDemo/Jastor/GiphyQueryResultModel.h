//
//  GiphyQueryResultModel.h
//  GiphyDemo
//
//  Created by Dana Devoe on 5/17/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

/* The data models for the Giphy API json data.
 Use with GiphyApi object
 */

@protocol GiphyQueryResultDictModel

@end

@protocol GiphyModel

@end


@interface GiphyQueryImageFixedWidthModel : JSONModel

@property (nonatomic,assign) float height;
@property (nonatomic,assign) float width;
@property (nonatomic,strong) NSString *url;

@end

@interface GiphyQueryImageOriginalModel : JSONModel

@property (nonatomic,assign) float height;
@property (nonatomic,assign) float width;
@property (nonatomic,strong) NSString *url;

@end


@interface GiphyQueryImagesModel : JSONModel

@property (nonatomic,strong) GiphyQueryImageFixedWidthModel *fixed_width;
@property (nonatomic,strong) GiphyQueryImageFixedWidthModel *original;

@end

@interface GiphyQueryResultModel : JSONModel

@property (nonatomic,strong) NSArray<GiphyModel> *data;

@end

@interface GiphyModel : JSONModel
@property (nonatomic,strong) NSString *bitly_gif_url;
@property (nonatomic,strong) NSString *bitly_url;
@property (nonatomic,strong) NSString *content_url;
@property (nonatomic,strong) NSString *embed_url;

@property (nonatomic,strong) GiphyQueryImagesModel *images;

@property (nonatomic,strong) NSString *slug;
@property (nonatomic,strong) NSString *type;

@end

