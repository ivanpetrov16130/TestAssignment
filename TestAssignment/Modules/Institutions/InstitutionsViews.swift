//
//  InstitutionsViews.swift
//  TestAssignment
//
//  Created by Ivan on 04.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import Yalta

enum InstitutionsViewStyle {
  
  static let institutions = Style<UITableView> {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.estimatedRowHeight = 80
    $0.rowHeight = UITableViewAutomaticDimension
    $0.register(reusableCellClass: InstitutionCell.self)
  }
  
  static let institutionName = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 17)
  }
  
  static let institutionIntro = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.textColor = .lightGray
  }
  
  static let institutionRating = Style<UILabel> {
    $0.textColor = .lightGray
    $0.font = UIFont.systemFont(ofSize: 21)
    $0.textAlignment = .right
  }

  static let institutionLayer = Style<UIView> {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8
  }
  
  static let background = Style<UIImageView> { imageView in
    imageView.contentMode = .scaleToFill
  }
  
}


class InstitutionCell: UITableViewCell {
  
  let layerView = UIView().styled(with: InstitutionsViewStyle.institutionLayer)
  let nameLabel = UILabel().styled(with: InstitutionsViewStyle.institutionName)
  let descriptionLabel = UILabel().styled(with: InstitutionsViewStyle.institutionIntro)
  let ratingLabel = UILabel().styled(with: InstitutionsViewStyle.institutionRating)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    backgroundColor = .clear
    buildViewHierarchyWithConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}

extension InstitutionCell: Autolayouted {

  var viewHierarchy: ViewHierarchy {
    return .view(contentView,
                 subhierarchy: [
                  .view(layerView, subhierarchy: [
                    .view(nameLabel, subhierarchy: nil),
                    .view(descriptionLabel, subhierarchy: nil),
                    .view(ratingLabel, subhierarchy: nil)
                    ])
      ])
  }
    
  var autolayoutConstraints: Constraints {
    ratingLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
    return Constraints(for: layerView, nameLabel, descriptionLabel, ratingLabel) {
      $0.edges.pinToSuperview(insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
      
      $1.edges(.left, .top, .right).pinToSuperview(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
      
      $2.edges(.left, .right).pinToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
      $2.top.align(with: $1.bottom, offset: 8)
      
      $3.top.align(with: $2.bottom, offset: 8).priority = UILayoutPriority(rawValue: 749)
      $3.edges(.left, .right, .bottom).pinToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
  }
  
}
