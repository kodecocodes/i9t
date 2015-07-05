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

class VacationSpotViewController: UIViewController {

  var vacationSpot: VacationSpot!

  @IBOutlet var allLabels: [UILabel]!
  @IBOutlet weak var whyVisitLabel: UILabel!
  @IBOutlet weak var whatToSeeLabel: UILabel!
  @IBOutlet weak var weatherInfoLabel: UILabel!
  @IBOutlet weak var userRatingLabel: UILabel!
  @IBOutlet weak var weatherHideOrShowButton: UIButton!
  @IBOutlet weak var submitRatingButton: UIButton!
  @IBOutlet weak var viewInMapButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Clear storyboard background colors
    for label in allLabels {
      label.backgroundColor = UIColor.clearColor()
    }

    title = vacationSpot.name
    
    whyVisitLabel.text = vacationSpot.whyVisit
    whatToSeeLabel.text = vacationSpot.whatToSee
    weatherInfoLabel.text = vacationSpot.weatherInfo
    userRatingLabel.text = String(vacationSpot.userRating)

    let shouldHideWeatherInfo = NSUserDefaults.standardUserDefaults().boolForKey("shouldHideWeatherInfo")
    updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfo, animated: false)

    // TODO: Space the "Submit a Rating" and "View in Map" buttons equally on each side
  }

  @IBAction func weatherHideOrShowButtonTapped(sender: UIButton) {
    let shouldHideWeatherInfo = sender.titleLabel!.text! == "Hide"
    NSUserDefaults.standardUserDefaults().setBool(shouldHideWeatherInfo, forKey: "shouldHideWeatherInfo")

    updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfo, animated: true)
  }

  func updateWeatherInfoViews(hideWeatherInfo shouldHideWeatherInfo: Bool, animated: Bool) {
    let newButtonTitle = shouldHideWeatherInfo ? "Show" : "Hide"
    weatherHideOrShowButton.setTitle(newButtonTitle, forState: .Normal)

    if animated {
      UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: [],
        animations: {
          self.weatherInfoLabel.hidden = shouldHideWeatherInfo
        }, completion: nil
      )
    } else {
      weatherInfoLabel.hidden = shouldHideWeatherInfo
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.identifier! {
    case "presentMapViewController":
      guard let navigationController = segue.destinationViewController as? UINavigationController,
        let mapViewController = navigationController.topViewController as? MapViewController else {
          fatalError("Unexpected view hierarchy")
      }
      mapViewController.locationToShow = vacationSpot.coordinate
      mapViewController.title = vacationSpot.name
    case "presentRatingViewController":
      guard let navigationController = segue.destinationViewController as? UINavigationController,
        let ratingViewController = navigationController.topViewController as? RatingViewController else {
          fatalError("Unexpected view hierarchy")
      }
      ratingViewController.vacationSpot = vacationSpot
    default:
      fatalError("Unhandled Segue: \(segue.identifier!)")
    }
  }
}
