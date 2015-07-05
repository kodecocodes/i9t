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

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Clear storyboard background colors
    for button in ratingButtons {
      button.backgroundColor = UIColor.clearColor()
    }

    questionLabel.text = "How would you rate \(vacationSpot.name)?"
  }

  // MARK: - Actions

  @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func submitRatingTapped() {
    // In a production app we would submit to the server here
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func ratingButtonTapped(sender: UIButton) {
    let buttonTitle = sender.titleLabel!.text!

    // Select the tapped button and unselect others
    for ratingButton in ratingButtons {
      ratingButton.selected = ratingButton == sender
    }

    let rating = ratingForButtonTitle(buttonTitle)

    showStarCount(rating)
  }

  // MARK: - Helper Methods

  func ratingForButtonTitle(buttonTitle: String) -> Int {
    switch buttonTitle {
    case "Boring":     return 1
    case "Meh":        return 2
    case "It's Ok":    return 3
    case "Like It":    return 4
    case "Fantastic!": return 5
    default:
      fatalError("Rating not found for buttonTitle: \(buttonTitle)")
    }
  }

  func showStarCount(totalStarCount: Int) {
    let starsToAdd = totalStarCount - starsStackView.arrangedSubviews.count

    if starsToAdd > 0 {
      for _ in 1...starsToAdd {
        let starImageView = UIImageView(image: UIImage(named: "star"))
        starImageView.contentMode = .ScaleAspectFit
        starsStackView.addArrangedSubview(starImageView)
      }
    } else if starsToAdd < 0 {
      let starsToRemove = abs(starsToAdd)

      for _ in 1...starsToRemove {
        guard let star = starsStackView.arrangedSubviews.last else { fatalError("Unexpected Logic Error") }
        star.removeFromSuperview() // No need to call removeArrangedSubview separately
      }
    }

    // Animate the addition
    UIView.animateWithDuration(0.25) {
      self.starsStackView.layoutIfNeeded()
    }
  }
}
