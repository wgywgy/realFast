//
//  JHStatusTextView.m
//  Status
//
//  Created by Jeff Hodnett on 19/04/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import "JHStatusTextView.h"
#import <QuartzCore/QuartzCore.h>
//#define kViewRoundedCornerRadius 5.0f
#define kMaxCharacterCount 40
#define kPlaceholderText @"亲说点什么..."

@interface JHStatusTextView (Private)
-(void)setupView;
@end

@implementation JHStatusTextView

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
	//[self.layer setCornerRadius:kViewRoundedCornerRadius];

	// Set showing a placeholder by default
	showingPlaceholder = YES;
	
	// Add the text view
	messageTextView = [[UITextView alloc] initWithFrame:self.bounds];
	[messageTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [messageTextView setFont:[UIFont systemFontOfSize:15]];
	[messageTextView setReturnKeyType:UIReturnKeyDone];
	//[messageTextView.layer setCornerRadius:kViewRoundedCornerRadius];
	
	[messageTextView setText:kPlaceholderText];
	[messageTextView setTextColor:[UIColor lightGrayColor]];
    [messageTextView becomeFirstResponder];
	
	messageTextView.delegate = self;
	[self addSubview:messageTextView];
//	[messageTextView release];
	
	// Set the max character count
	characterCount = kMaxCharacterCount;
	
	// Add a character label

	characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(130,70,150,25)];
	[characterCountLabel setTextAlignment:NSTextAlignmentRight];
    [characterCountLabel  setTextColor:[UIColor brownColor]];
    [characterCountLabel setFont:[UIFont systemFontOfSize:12]];
	[characterCountLabel setBackgroundColor:[UIColor clearColor]];
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
    // 评论字数小于40
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
  
}
@end
