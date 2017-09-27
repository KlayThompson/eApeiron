//
//  CheckBoxCotrol.m
//  tranb
//
//  Created by yanchoujie on 24/11/2014.
//  Copyright (c) 2014年 cmf. All rights reserved.
//

#import "CheckBoxCotrol.h"
#import "UIView+Size.h"

@interface CheckBoxCotrol (){

    UIImageView *selectImage;
    UILabel     *titleContent;
    
}

@end

@implementation CheckBoxCotrol

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonUIBuild];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self commonUIBuild];
    }
    return self;
}

- (void)commonUIBuild{
    
    selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - 17)/2, 17, 17)];
    selectImage.image = [UIImage imageNamed:@"purchesUnSelectedBoxes"];
    selectImage.highlightedImage = [UIImage imageNamed:@"purchesBoxes"];
    selectImage.exclusiveTouch = YES;
    [self addSubview:selectImage];
    titleContent = [[UILabel alloc] initWithFrame:CGRectMake(selectImage.width + 10, (self.height - 21)/2, self.width - selectImage.width - 10, 21)];
    titleContent.backgroundColor = [UIColor clearColor];
//    titleContent.font = [UIFont fontWithName:@"Heiti SC" size:13.0f];
    titleContent.font = Font14;
    titleContent.textColor = [UIColor blackColor];
    titleContent.highlightedTextColor = [UIColor colorWithRed:9/255.0f
                                                        green:81/255.0f
                                                         blue:198/255.0f
                                                        alpha:1.0f];
    [self addSubview:titleContent];
    
}


- (void)setMContent:(NSString *)mContent{

    if (_mContent != mContent) {
        _mContent = mContent;
    }
    if (_mContent) {
        titleContent.text = _mContent;
    }
}

 
- (void)setMSelected:(BOOL)mSelected{
    if (_mSelected != mSelected) {
        _mSelected = mSelected;
    }
    
    selectImage.highlighted = mSelected;
    titleContent.highlighted = mSelected;
    selectImage.highlighted = mSelected;
    titleContent.highlighted = mSelected;
    self.mWorning = NO;
   
}

- (void)setMWorning:(BOOL)mWorning{

    if (_mWorning != mWorning) {
        _mWorning = mWorning;
    }
    
    if (_mWorning) {
        selectImage.image = [UIImage imageNamed:@"purchesUnitWarning"];
    } else {
        selectImage.image = [UIImage imageNamed:@"purchesUnSelectedBoxes"];
    }
}

@end
