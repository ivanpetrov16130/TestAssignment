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
  
  static let background = Style<UIImageView> { imageView in
    imageView.contentMode = .scaleToFill
  }
  
  static let image = Style<UIImageView> {
    $0.clipsToBounds = true
  }
  
  static let name = Style<UILabel> {
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 26)
  }
  
  static let description = Style<UILabel> {
    $0.font = UIFont.systemFont(ofSize: 15)
    $0.numberOfLines = 0
  }
  
  static let rating = Style<UILabel> {
    $0.textColor = .darkGray
    $0.font = UIFont.systemFont(ofSize: 21)
    $0.textAlignment = .right
  }
  
  static let addresses = Style<UITableView> {
    $0.isScrollEnabled = false
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
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
    $0.tintColor = #colorLiteral(red: 0.8740364655, green: 0.189141253, blue: 1, alpha: 1)
    $0.setBackgroundImage(#imageLiteral(resourceName: "mapIcon"), for: .normal)
    $0.layer.cornerRadius = 6
  }
  
  static let closeButton = Style<UIButton> {
    $0.tintColor = #colorLiteral(red: 0.8814959094, green: 0.4806738335, blue: 1, alpha: 1)
    $0.setBackgroundImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
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
    backgroundColor = UIColor(white: 1, alpha: 0.5)
    
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

      $0.edges(.top, .left).pinToSuperview(insets: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0))
      $0.right.align(with: $2.left, offset: -8, relation: NSLayoutRelation.lessThanOrEqual)
      
      $1.left.pinToSuperview(inset: 16)
      $1.top.align(with: $0.bottom, offset: 8)
      $1.right.align(with: $2.left, offset: -8, relation: NSLayoutRelation.lessThanOrEqual)
      $1.bottom.pinToSuperview(inset: 16)

      $2.right.pinToSuperview(inset: 16)
      $2.size.set(CGSize(width: 30, height: 30))
      $2.centerY.alignWithSuperview()
      
    }
    
  }

}
