/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class RatingViewController: UIViewController {

  var vacationSpot: VacationSpot!

  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet var ratingButtons: [UIButton]!
  @IBOutlet weak var starsStackView: UIStackView!
  @IBOutlet weak var submitRatingButton: UIButton!
  @IBOutlet weak var deleteRatingButton: UIButton!

  var currentUserRating: Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey("currentUserRating-\(vacationSpot.identifier)")
    }
    set {
      NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "currentUserRating-\(vacationSpot.identifier)")
    }
  }

  private let ratingToButtonTitleDict = [
    1: "Boring",
    2: "Meh",
    3: "It's Ok",
    4: "Like It",
    5: "Fantastic!"
  ]

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    questionLabel.text = "How would you rate \(vacationSpot.name)?"

    showStarCount(currentUserRating, animated: false)

    let titleOfButtonToSelect = ratingToButtonTitleDict[currentUserRating]

    if currentUserRating > 0 {
      submitRatingButton.setTitle("Update Your Rating", forState: .Normal)
    }

    deleteRatingButton.hidden = currentUserRating == 0

    for ratingButton in ratingButtons {
      ratingButton.selected = ratingButton.titleLabel!.text! == titleOfButtonToSelect
    }
  }

  @IBAction func submitRatingTapped() {
    currentUserRating = starsStackView.arrangedSubviews.count
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func deleteRatingTapped() {
    currentUserRating = 0
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func ratingButtonTapped(sender: UIButton) {
    let buttonTitle = sender.titleLabel!.text!

    for ratingButton in ratingButtons {
      ratingButton.selected = ratingButton == sender
    }

    let rating = ratingForButtonTitle(buttonTitle)
    showStarCount(rating)
  }

  func ratingForButtonTitle(buttonTitle: String) -> Int {
    for (rating, title) in ratingToButtonTitleDict where title == buttonTitle {
      return rating
    }

    fatalError("Rating not found for buttonTitle: \(buttonTitle)")
  }

  @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func showStarCount(totalStarCount: Int, animated: Bool = true) {
    let starsShowing = starsStackView.arrangedSubviews.count
    let starsToAdd = totalStarCount - starsShowing

    if starsToAdd > 0 {
      for _ in 1...starsToAdd {
        let starImageView = UIImageView(image: UIImage(named: "star"))
        starsStackView.addArrangedSubview(starImageView)
        starImageView.contentMode = .ScaleAspectFit
      }
    } else if starsToAdd < 0 {
      let starsToRemove = abs(starsToAdd)

      for _ in 1...starsToRemove {
        let star = starsStackView.arrangedSubviews.last

        if let star = star {
          star.removeFromSuperview()
        } else {
          fatalError()
        }
      }
    }

    if animated {
      UIView.animateWithDuration(0.25) {
        self.starsStackView.layoutIfNeeded()
      }
    }
  }
}
