//
//  GiphyViewController.m
//  GiphyDemo
//
//  Created by Dana Devoe on 5/18/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import "GiphyViewController.h"

@implementation GiphyViewController

- (void) viewDidAppear:(BOOL)animated
{
    [self.activity startAnimating];
    self.activity.color = [UIColor blackColor];
}

- (IBAction)didTouchShare:(id)sender {
    NSURL *url = [NSURL URLWithString:self.url];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];

}


@end
