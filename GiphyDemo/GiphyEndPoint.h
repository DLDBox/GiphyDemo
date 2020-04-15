//
//  GiphyEndPoint.h
//  GiphyDemo
//
//  Created by Dana Devoe on 5/16/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import <Foundation/Foundation.h>

/* This object manages the endpoints to the GiphyAPI
 Each method returns the URL string and endpoint on the development server only
 */

@interface GiphyEndPoint : NSObject

+ (NSString const*)baseURL;

+ (NSString *)searchURLFor:(NSString *)searchTerm;
+ (NSString *)gifIDURLFor:(NSString *)gifID;
+ (NSString *)randomGifURL;
+ (NSString *)trendingGifURL;

@end
