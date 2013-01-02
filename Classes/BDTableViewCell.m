//
//  BDTableViewCell.m
//Licensed under GPL version 2.0

#import "BDTableViewCell.h"


@implementation BDTableViewCell

@synthesize textView;

- (void)setTextView:(UITextView *)newTextView
{
	textView = newTextView;
	[self.contentView addSubview:newTextView];
	[self layoutSubviews];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect contentRect = [self.contentView bounds];
    self.textView.editable = NO;
	self.textView.frame  = CGRectMake(contentRect.origin.x + 5.0,
									  contentRect.origin.y + 5.0,
									  contentRect.size.width - (5.0*2),
									  contentRect.size.height - (5.0*2));
}

- (void)dealloc
{
   
}

@end
