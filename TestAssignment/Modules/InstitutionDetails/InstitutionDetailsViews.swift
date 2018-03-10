//
//  InstitutionDetailsViews.swift
//  TestAssignment
//
//  Created by Ivan on 08.03.2018.
//  Copyright © 2018 MotMom. All rights reserved.
//

import UIKit
import RxSwift
import Yalta

enum InstitutionDetailsStyle {
  
  static let image = Style<UIImageView> {
    $0.layer.cornerRadius = 50
    $0.clipsToBounds = true
  }
  
  static let name = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 20)
  }
  
  static let description = Style<UILabel> {
    $0.numberOfLines = 0
  }
  
  static let rating = Style<UILabel> {
    $0.textColor = .lightGray
  }
  
  static let addresses = Style<UITableView> {
    $0.separatorStyle = .none
    $0.backgroundColor = .red
    $0.estimatedRowHeight = 80
    $0.rowHeight = UITableViewAutomaticDimension
    $0.register(reusableCellClass: InstitutionAddressCell.self)
  }
  
  static let institutionAddress = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 20)
  }
  
  static let institutionTimeTable = Style<UILabel> {
    $0.numberOfLines = 0
  }
  
  static let institutionMapTransitionButton = Style<UIButton> {
    $0.setTitle("Показать на карте", for: .normal)
    $0.backgroundColor = .red
    $0.layer.cornerRadius = 6
  }
  
}


class InstitutionAddressCell: UITableViewCell {
  
  private(set) var disposeBag = DisposeBag()
  
  let addressLabel = UILabel().styled(with: InstitutionDetailsStyle.institutionAddress)
  let timetableLabel = UILabel().styled(with: InstitutionDetailsStyle.institutionTimeTable)
  let mapTransitionButton = UIButton().styled(with: InstitutionDetailsStyle.institutionMapTransitionButton)
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    buildViewHierarchyWithConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func prepareForReuse() {
    disposeBag = DisposeBag()
    super.prepareForReuse()
  }
  
}

extension InstitutionAddressCell: Autolayouted {
  
  var viewHierarchy: ViewHierarchy {
    return .view(contentView,
                 subhierarchy: [
                  .view(addressLabel, subhierarchy: nil),
                  .view(timetableLabel, subhierarchy: nil),
                  .view(mapTransitionButton, subhierarchy: nil)
      ])
  }
  
  var autolayoutConstraints: Constraints {
    timetableLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
    mapTransitionButton.setContentHuggingPriority(UILayoutPriority(rawValue: 248), for: .vertical)
    return Constraints(for: addressLabel, timetableLabel, mapTransitionButton) {
      $0.edges(.top, .left, .right).pinToSuperview(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
      
      $1.edges(.left, .right).pinToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
      $1.top.align(with: $0.bottom, offset: 8)
      
      $2.right.pinToSuperview(inset: 16)
      $2.height.set(30)
      $2.bottom.pinToSuperview(inset: 16)
      $2.top.align(with: $1.bottom, offset: 8)

    }
    
  }

}
