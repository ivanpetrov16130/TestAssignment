//
//  InstitutionsViews.swift
//  TestAssignment
//
//  Created by Ivan on 04.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
//import RxCocoa

enum InstitutionsViewStyles {
  
  static let institutions = Style<UITableView> {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
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
  
  let nameLabel = UILabel().styled(with: InstitutionsViewStyles.institutionName)
  let descriptionLabel = UILabel().styled(with: InstitutionsViewStyles.institutionIntro)
  let ratingLabel = UILabel().styled(with: InstitutionsViewStyles.institutionRating)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    buildViewHierarchyWithConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}

extension InstitutionCell: Autolayouted {
  var viewHierarchy: ViewHierarchy {
    return ViewHierarchy.rootless(subhierarchy:
      [ViewHierarchy.plain(nameLabel,
                           constrainted: {
                             $0.edges(.left, .top, .right).pinToSuperview(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
                          }),
       ViewHierarchy.plain(descriptionLabel,
                           constrainted: {
                            $0.edges(.left, .right).pinToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
                            $0.top.align(with: self.nameLabel.al.bottom)
                          }),
       ViewHierarchy.plain(ratingLabel,
                           constrainted: {
                            $0.top.align(with: self.descriptionLabel.al.bottom)
                            $0.edges(.left, .bottom).pinToSuperview()
       })
      ]
    )
  }
  
  
}
