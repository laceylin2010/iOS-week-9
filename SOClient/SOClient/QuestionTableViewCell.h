//
//  QuestionTableViewCell.h
//  
//
//  Created by Lacey Vu on 3/30/16.
//
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isAnsweredLabel;

@end
