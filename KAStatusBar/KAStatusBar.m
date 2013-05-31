//
//  KAStatusBar.m
//
//  Copyright 2013 Alexis Creuzot
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KAStatusBar.h"

@interface KAStatusBar ()
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

static KAStatusBar *sharedView;

@implementation KAStatusBar

+ (KAStatusBar*)sharedView {
    
    if (sharedView) {
        return sharedView;
    }
    
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        UIApplication *app = [UIApplication sharedApplication];
        sharedView = [[KAStatusBar alloc] initWithFrame:CGRectMake(0, 0, app.statusBarFrame.size.width, app.statusBarFrame.size.height)];
    });
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        // init overlay window
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        
        // init self properties
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.alpha = 0;
        [_overlayWindow addSubview:self];
        
        // Add stringLabel
        float padding = 30;
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + padding, self.frame.origin.y, self.frame.size.width - (padding*2), self.frame.size.height)];
		_messageLabel.backgroundColor = [UIColor clearColor];
		_messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:_messageLabel];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
        self.activityIndicator.alpha = 0;
        [self addSubview: self.activityIndicator];
    }
    
    return self;
}

#pragma mark - public API

+ (void)showWithStatus:(NSString*)status barColor:(UIColor*)color andRemoveAfterDelay:(NSNumber *) delay;
{
    [[KAStatusBar sharedView] showWithStatus:status barColor:color removeAfterDelay:delay];
}

+ (void)showWithStatus:(NSString*)status andRemoveAfterDelay:(NSNumber *) delay
{
    [[KAStatusBar sharedView] showWithStatus:status barColor:[UIColor blackColor] removeAfterDelay:delay];
}

+ (void)showWithStatus:(NSString*)status andBarColor:(UIColor*)color;
{
    [[KAStatusBar sharedView] showWithStatus:status barColor:color removeAfterDelay:nil];
}

+ (void)showWithStatus:(NSString*)status {
    [[KAStatusBar sharedView] showWithStatus:status barColor:[UIColor blackColor] removeAfterDelay:nil];
}

+ (void)dismiss {
    [[KAStatusBar sharedView] dismiss];
}

#pragma mark - Private methods

- (void)showWithStatus:(NSString *)status barColor:(UIColor*)barColor removeAfterDelay:(NSNumber *) delay{
    
    // remove previous dismissing requests
    [KAStatusBar cancelPreviousPerformRequestsWithTarget:[KAStatusBar class] selector:@selector(dismiss) object:self];
    
    // Overlay must be shown
    [self.overlayWindow setHidden:NO];
    
    // Set background color
    self.backgroundColor = barColor;
    
    // Set label properties
    self.messageLabel.text = status;
    self.messageLabel.textColor = [KAStatusBar contrastForColor:barColor];
    self.messageLabel.alpha = 0;
        
    if(!delay){
        // Place activity indicator based on text length
        CGSize textSize = [status sizeWithFont:[self.messageLabel font]];
        float xOffset = (self.messageLabel.frame.size.width - textSize.width)/2;
        self.activityIndicator.transform = CGAffineTransformMakeTranslation(xOffset, 0);
        
        if([self.messageLabel.textColor isEqual:[UIColor whiteColor]]){
            [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        }else{
            [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        }
        
        [self.activityIndicator startAnimating];
    }else{
        [KAStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:[delay floatValue]];
        [self.activityIndicator stopAnimating];
    }
    
    // Animate apparition
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
        self.messageLabel.alpha = 1;
        
        // If no delay, show activity indicator
        if(!delay){
            self.activityIndicator.alpha = 1;
        }else{
            self.activityIndicator.alpha = 0;
        }
    }];
}

- (void) dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[KAStatusBar sharedView].activityIndicator stopAnimating];
        self.activityIndicator.alpha = 0;
        [_overlayWindow setHidden:YES];
    }];
}

#pragma mark - Color helper

+ (UIColor *) contrastForColor:(UIColor *) color
{
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    if(componentColors[0] + componentColors[1] + componentColors[2] > (0.5*3)){
        return [UIColor blackColor];
    }else{
        return [UIColor whiteColor];
    }
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
