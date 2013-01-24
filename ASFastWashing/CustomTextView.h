//
//  CustomTextView.h
//  ASFastWashing
//
//  Created by Hao on 12/24/12.
//  Copyright (c) 2012 SSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTextView;

@protocol CustomTextViewDelegate <NSObject>

@optional
-(void)statusTextView:(CustomTextView *)textView postedMessage:(NSString *)message;

@end

@interface CustomTextView : UIView <UITextViewDelegate> {
    UITextView *messageTextView;
	// The character counter
	UILabel *characterCountLabel;
	
	// The character count
	int characterCount;
    CGRect rect_screen;
	// Showing a placeholder
	BOOL showingPlaceholder;
	
	// The delegate
	IBOutlet id <CustomTextViewDelegate> delegate;
}

@property(nonatomic, assign) id <CustomTextViewDelegate> delegate;
@property(nonatomic,retain)UITextView *messageTextView;
-(NSString*)getText;
-(NSString*)setText:(NSString*)aText;

@end