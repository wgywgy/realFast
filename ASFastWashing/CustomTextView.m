//
//  CustomTextView.m
//  ASFastWashing
//
//  Created by Hao on 12/24/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import "CustomTextView.h"
#import <QuartzCore/QuartzCore.h>
#define kViewRoundedCornerRadius 6.0f
#define kMaxCharacterCount 100
#define kPlaceholderText @"请填入商店简介..."

@interface CustomTextView (Private)
-(void)setupView;
@end

@implementation CustomTextView

@synthesize delegate;
@synthesize messageTextView;

-(NSString*)getText
{
    NSString* mes = [messageTextView text];
    return mes;
}

-(NSString*)setText:(NSString*)aText
{
    messageTextView.text = aText;
    return messageTextView.text;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
		// Setup the view
		[self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	if( (self = [super initWithCoder:aDecoder]) ) {
		
		// Setup the view
		[self setupView];
	}
	return self;
}


- (void)dealloc
{
	[characterCountLabel release];
    [messageTextView release];
	
    [super dealloc];
}

#pragma mark - Private
-(void)setupView {
    
    // Set rounded corners on the text view
	[self.layer setCornerRadius:kViewRoundedCornerRadius];
    
	// Set showing a placeholder by default
	showingPlaceholder = YES;
	
	// Add the text view
	//messageTextView = [[UITextView alloc] initWithFrame:self.bounds];
    messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height-20)];
    [messageTextView setTag:202];
    [messageTextView setBackgroundColor:[UIColor whiteColor]];
	[messageTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [messageTextView setFont:[UIFont systemFontOfSize:17]];
	[messageTextView setReturnKeyType:UIReturnKeyDone];
	[messageTextView.layer setCornerRadius:kViewRoundedCornerRadius];
	
	[messageTextView setText:kPlaceholderText];
	[messageTextView setTextColor:[UIColor grayColor]];
	
	messageTextView.delegate = self;
	[self addSubview:messageTextView];
    [messageTextView release];
	
	// Set the max character count
	characterCount = kMaxCharacterCount;
	
	// Add a character label
    
	characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150,80,150,25)];
	[characterCountLabel setTextAlignment:NSTextAlignmentRight];
	[characterCountLabel setBackgroundColor:[UIColor clearColor]];
    [characterCountLabel setFont:[UIFont systemFontOfSize:14]];
    characterCountLabel.textColor = [UIColor grayColor];
	[characterCountLabel setText:[NSString stringWithFormat:@"还可以输入%d字", characterCount]];
	[self addSubview:characterCountLabel];
}

#pragma mark - UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
	// Check if it's showing a placeholder, remove it if so
	if(showingPlaceholder) {
		[textView setText:@""];
		[textView setTextColor:[UIColor blackColor]];
		
		showingPlaceholder = NO;
	}
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
	// Check the length and if it should add a placeholder
	if([[textView text] length] == 0 && !showingPlaceholder) {
		[textView setText:kPlaceholderText];
		[textView setTextColor:[UIColor lightGrayColor]];
		
		showingPlaceholder = YES;
	}
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 评论字数小于100
    if(range.location >= kMaxCharacterCount)
        return NO;
    
	// if the user clicked the return key
	if ([text isEqualToString: @"\n"])
    {
		// Hide the keyboard
        //[textView resignFirstResponder];
        //[self.delegate textViewShowActionSheet];
        
        // Also return if its showing a placeholder
		if(showingPlaceholder)
        {
			return NO;
		}
		
		// Notify the delegate
		if(delegate && [delegate respondsToSelector:@selector(statusTextView:postedMessage:)])
        {
			[delegate statusTextView:self postedMessage:textView.text];
		}
        
		return NO ;
	}
	
	return YES ;
}

- (void)textViewDidChange:(UITextView *)textView {
	// Update the character count
	characterCount = kMaxCharacterCount - [[textView text] length];
    
    [characterCountLabel setText:[NSString stringWithFormat:@"还可以输入%d字", characterCount]];
    
    NSString *temp = textView.text;
    if (temp.length > 100) {
        textView.text = [temp substringToIndex:100];
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"animateViewTextView" object:self];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* underneath = [[[UIBarButtonItem alloc] initWithTitle:@"下一项"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(next)]
                                                                       autorelease];
    
    UIBarButtonItem* superior = [[[UIBarButtonItem alloc] initWithTitle:@"上一项"
                                                                  style:UIBarButtonItemStyleBordered target:self
                                                                 action:@selector(previous)]
                                                                        autorelease];
    UIBarButtonItem *spaceBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil] autorelease];
    UIBarButtonItem* hide = [[[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘"
                                                              style:UIBarButtonItemStyleBordered target:self
                                                             action:@selector(hideKeyboard)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:superior,underneath,spaceBarItem,hide, nil]];
    textView.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
    return YES;
}
-(void)next
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"next" object:self];
}
-(void)previous
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"previous" object:nil];
}
-(void)hideKeyboard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hide" object:nil];
}
@end
