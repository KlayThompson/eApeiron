//
//  DetailIssueCell.m
//  Investigator
//
//  Created by Kim on 2018/3/5.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import "DetailIssueCell.h"
#import "YYWebImage.h"
#import "UIView+Size.h"

@implementation DetailIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configDetailIssueCellWithKey:(NSString *)key value:(id)value {
    
    self.keyLabel.text = key;
    
    if ([key isEqualToString:@"Secondary Codes"]) {
        
        [self showProductSchemaWith:value];
    } else if ([key isEqualToString:@"Description"]) {
        [self showDescWithValue:value];
    } else if ([key isEqualToString:@"Image"]) {
        [self showImageWithVlaue:value];
    } else {
        [self showNormalValue:value];
    }
}

- (void)showNormalValue:(id)value {
    
    self.productImageView.hidden = YES;
    self.valueLabel.hidden = NO;
    self.schmaBgView.hidden = YES;
    
    NSString *str = (NSString *)value;
    self.valueLabel.text = str;
    CGSize size = [self.valueLabel sizeThatFits:CGSizeMake(self.valueLabel.frame.size.width, CGFLOAT_MAX)];
    self.valueBgViewHeightCons.constant = size.height;
}

- (void)showProductSchemaWith:(NSDictionary *)dict {
    
    if (DICT_IS_NIL(dict)) {
        return;
    }
    self.productImageView.hidden = YES;
    self.valueLabel.hidden = NO;
    self.valueLabel.text = @"";
    self.schmaBgView.hidden = NO;
    
    int labelHeight = 20, topMargin = 5, leftMargin = 15, keyLabelWidth = 100;
    
    for (int index = 0; index < dict.allKeys.count; index++) {
        NSString *key = [dict.allKeys objectAtIndex:index];
        NSString *value = [dict objectForKey:key];
        
        //创建key value label
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (topMargin + labelHeight)*index + 23, keyLabelWidth, labelHeight)];
        keyLabel.font = [UIFont systemFontOfSize:15];
        keyLabel.textColor = [UIColor blackColor];
        keyLabel.text = key;
        [self.schmaBgView addSubview:keyLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyLabel.right + leftMargin, keyLabel.top, self.schmaBgView.width - keyLabelWidth - leftMargin, labelHeight)];
        valueLabel.font = [UIFont systemFontOfSize:15];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.text = value;
        [self.schmaBgView addSubview:valueLabel];
        
    }
    
    //设置背景视图的高度约束
    self.valueBgViewHeightCons.constant = 40 + dict.allKeys.count * (labelHeight + topMargin);
}

- (void)showDescWithValue:(id)value {
    self.productImageView.hidden = YES;
    self.valueLabel.hidden = NO;
    self.schmaBgView.hidden = YES;

    NSString *desc = (NSString *)value;

    NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSData *data = [desc dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data
                                                                         options:optoins
                                                              documentAttributes:nil
                                                                           error:nil];
    
    self.valueLabel.attributedText = attributeString;
    CGSize size = [self.valueLabel sizeThatFits:CGSizeMake(self.valueLabel.frame.size.width, CGFLOAT_MAX)];
    self.valueBgViewHeightCons.constant = size.height;
}

- (void)showImageWithVlaue:(id)value {
    
    self.productImageView.hidden = NO;
    self.valueLabel.hidden = YES;
    self.schmaBgView.hidden = YES;
    
    NSString *imageUrlStr = (NSString *)value;
    
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
    
    self.valueBgViewHeightCons.constant = 45;
}
@end
