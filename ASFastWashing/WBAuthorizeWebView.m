//
//  WBAuthorizeWebView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorizeWebView.h"
#import <QuartzCore/QuartzCore.h> 

@interface WBAuthorizeWebView (Private)

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (UIInterfaceOrientation)currentOrientation;
- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

@end

@implementation WBAuthorizeWebView

@synthesize delegate;

#pragma mark - WBAuthorizeWebView Life Circle

- (id)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].applicationFrame])
    {
        
        /////////////

        self.backgroundColor = [UIColor clearColor];
        [self.layer setCornerRadius:10.0];
        [self.layer setMasksToBounds:YES];
        self.clipsToBounds = YES;
        
        UIView *skinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        skinView.backgroundColor = [UIColor blackColor];
        skinView.alpha = 0.4f;
        [self addSubview:skinView];
        [skinView release];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(self.frame.size.width - 55, 0,35, 35);
        [cancelButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"close_selected.png"] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(closeAuthorizeWeb) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        //////////////
        
//        // background settings
//        [self setBackgroundColor:[UIColor clearColor]];
//        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
//        
//        // add the panel view
//        panelView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 440)];
//        [panelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
//        [[panelView layer] setMasksToBounds:NO]; // very important
//        [[panelView layer] setCornerRadius:10.0];
//        [self addSubview:panelView];
//        
//        // add the conainer view
//        containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 420)];
//        [[containerView layer] setBorderColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.7].CGColor];
//        [[containerView layer] setBorderWidth:1.0];
        
        
        // add the web view
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 30, self.frame.size.width - 40, self.frame.size.height - 60)];
		[webView setDelegate:self];
		[self addSubview:webView];
        
        //[panelView addSubview:containerView];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setCenter:CGPointMake(160, 240)];
        [self addSubview:indicatorView];
        
        [self sizeToFitOrientation:YES];

//        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [closeButton setImage:[UIImage imageNamed:@"sinaclose.png"] forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(closeAuthorizeWeb) forControlEvents:UIControlEventTouchUpInside];
//        
//        [closeButton setFrame:CGRectMake(284, 10, 40, 40)];
//        [self addSubview:closeButton];
        


    }
    return self;
}


- (void)viewAnimationShow
{
    self.alpha = 0.0;
    self.transform = CGAffineTransformScale([self transform], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.alpha = 1.0;
    self.transform = CGAffineTransformScale([self transform], 1.3, 1.3);
    [UIView commitAnimations];
}
- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transform], 1, 1);
    [UIView commitAnimations];
}
- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.transform = [self transform];
    [UIView commitAnimations];
}


- (void)sizeToFitOrientation:(BOOL)transform
{
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
    
    CGFloat width = floor(scale_factor * frame.size.width) - 20;
    CGFloat height = floor(scale_factor * frame.size.height) - 20;
    

    self.frame = CGRectMake(10, 10, width, height);
    
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation:transform];
    }
}

- (void)dealloc
{
    [panelView release], panelView = nil;
    [containerView release], containerView = nil;
    [webView release], webView = nil;
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

//- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
//{
//    [self setTransform:CGAffineTransformIdentity];
//    
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        [self setFrame:CGRectMake(0, 0, 480, 320)];
//        [panelView setFrame:CGRectMake(10, 30, 460, 280)];
//        [containerView setFrame:CGRectMake(10, 10, 440, 260)];
//        [webView setFrame:CGRectMake(0, 0, 440, 260)];
//        [indicatorView setCenter:CGPointMake(240, 160)];
//    }
//    else
//    {
//        [self setFrame:CGRectMake(0, 0, 320, 480)];
//        [panelView setFrame:CGRectMake(10, 30, 300, 440)];
//        [containerView setFrame:CGRectMake(10, 10, 280, 420)];
//        [webView setFrame:CGRectMake(0, 0, 280, 420)];
//        [indicatorView setCenter:CGPointMake(160, 240)];
//    }
//    
//    [self setCenter:CGPointMake(160, 240)];
//    
//    [self setTransform:[self transformForOrientation:orientation]];
//    
//    previousOrientation = orientation;
//}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{  
	if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	}
    else
    {
		return CGAffineTransformIdentity;
	}
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    // nothing shall be done here
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
    [self removeObservers];
	[self removeFromSuperview];
}

#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}

- (void)show:(BOOL)animated
{
    [self sizeToFitOrientation:[self currentOrientation]];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    [self viewAnimationShow];
//    if (animated)
//    {
//        [panelView setAlpha:0];
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.2];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
//        [panelView setAlpha:0.5];
//        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
//        [UIView commitAnimations];
//    }
//    else
//    {
//        [self allAnimationsStopped];
//    }
    
    [self addObservers];
}

- (void)hide:(BOOL)animated
{
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		[self setAlpha:0];
		[UIView commitAnimations];
	} 
    [self hideAndCleanUp];
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
	}
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        if ([delegate respondsToSelector:@selector(authorizeWebView:didReceiveAuthorizeCode:)])
        {
            [delegate authorizeWebView:self didReceiveAuthorizeCode:code];
        }
    }
    
    return YES;
}

-(void)closeAuthorizeWeb
{
    [self hide:YES];
}

@end
