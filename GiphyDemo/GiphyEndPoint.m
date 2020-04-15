//
//  GiphyEndPoint.m
//  GiphyDemo
//
//  Created by Dana Devoe on 5/16/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import "GiphyEndPoint.h"

static NSString const* domain = @"http://api.giphy.com";
static NSString const* apiKey = @"api_key=dc6zaTOxFJmzC";

@implementation GiphyEndPoint

+ (NSString const*)baseURL
{
    return domain;
}

+ (NSString *)searchURLFor:(NSString *)searchTerm
{
    return [NSString stringWithFormat:@"%@/v1/gifs/search?q=%@&%@",domain,searchTerm,apiKey];
}

+ (NSString *)gifIDURLFor:(NSString *)gifID
{
    return [NSString stringWithFormat:@"%@/v1/gifs/%@?%@",domain,gifID,apiKey];
}

+ (NSString *)randomGifURL
{
    return [NSString stringWithFormat:@"%@/v1/gifs/random?%@",domain,apiKey];
}

+ (NSString *)trendingGifURL
{
    return [NSString stringWithFormat:@"%@/v1/gifs/trending?%@",domain,apiKey];
    
}

@end
