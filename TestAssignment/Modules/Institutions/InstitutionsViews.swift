//
//  InstitutionsViews.swift
//  TestAssignment
//
//  Created by Ivan on 04.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Yalta
//import RxCocoa

enum InstitutionsViewStyle {
  
  static let institutions = Style<UITableView> {
    $0.separatorStyle = .none
    $0.backgroundColor = .red
    $0.estimatedRowHeight = 80
    $0.rowHeight = UITableViewAutomaticDimension
    $0.register(reusableCellClass: InstitutionCell.self)
  }
  
  static let institutionName = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 20)
  }
  
  static let institutionIntro = Style<UILabel> {
    $0.numberOfLines = 0
  }
  
  static let institutionRating = Style<UILabel> {
    $0.textColor = .lightGray
  }

  
}


class InstitutionCell: UITableViewCell {
  
  let nameLabel = UILabel().styled(with: InstitutionsViewStyle.institutionName)
  let descriptionLabel = UILabel().styled(with: InstitutionsViewStyle.institutionIntro)
  let ratingLabel = UILabel().styled(with: InstitutionsViewStyle.institutionRating)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    buildViewHierarchyWithConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}

extension InstitutionCell: Autolayouted {

  var viewHierarchy: ViewHierarchy {
    return .view(contentView,
                 subhierarchy: [
                  .view(nameLabel, subhierarchy: nil),
                  .view(descriptionLabel, subhierarchy: nil),
                  .view(ratingLabel, subhierarchy: nil)
      ])
  }
    
  var autolayoutConstraints: Constraints {
    return Constraints(for: nameLabel, descriptionLabel, ratingLabel) {
      $0.edges(.left, .top, .right).pinToSuperview(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
      
      $1.edges(.left, .right).pinToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
      $1.top.align(with: $0.bottom)
      
      $2.top.align(with: $1.bottom).priority = UILayoutPriority(rawValue: 749)
      $2.edges(.left, .bottom).pinToSuperview()
    }
  }
  
}
