//
//  GiphyViewController.h
//  GiphyDemo
//
//  Created by Dana Devoe on 5/18/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import <UIKit/UIKit.h>

/* This object displays the animated GIF
 */

@interface GiphyViewController : UIViewController
@property (strong,nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIImageView *giphyImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
