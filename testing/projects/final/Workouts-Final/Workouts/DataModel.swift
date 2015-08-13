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

import Foundation

class DataModel {
  
  var workouts = [Workout]()
  var exercises = [Exercise]()

  var allWorkouts: [Workout] {
    return workouts
  }
  
  var allExercises: [Exercise] {
    return exercises
  }
  
  var containsUserCreatedExercise: Bool {
    for exercise in allExercises {
      if exercise.userCreated == true {
        return true
      }
    }
    return false
  }
  
  var containsUserCreatedWorkout: Bool {
    for workout in allWorkouts {
      if workout.userCreated == true {
        return true
      }
    }
    return false
  }

  init() {
    addTestData()
  }

  func addWorkout(workout: Workout) {
    workouts.append(workout)
  }
  
  func removeWorkoutAtIndex(index: Int) {
    workouts.removeAtIndex(index)
  }
  
  func addExercise(exercise: Exercise) {
    exercises.append(exercise)
  }
  
  func removeExerciseAtIndex(index: Int) {
    exercises.removeAtIndex(index)
  }
  
  private func addTestData() {
    //Exercises
    
    //jumping jacks
    let jumpingJacks = Exercise()
    jumpingJacks.userCreated = false
    jumpingJacks.name = "Jumping Jacks"
    jumpingJacks.photoFileName = "squat"
    jumpingJacks.instructions = "Start with your feet together and your arms on the sides. Then jump and land with your legs slightly wider than your shoulders at the same time as you move your arms over your head. Finish by jumping back to the starting point."
    jumpingJacks.duration = 30
    
    addExercise(jumpingJacks)
    
    //wall sit
    let wallSit = Exercise()
    wallSit.userCreated = false
    wallSit.name = "Wall Sit"
    wallSit.photoFileName = "squat"
    wallSit.instructions = "Stand with your legs shoulder width apart next to a wall. Then with your back against the wall, bend your knees until they are bent 90 degrees and hold the position. Rest your arms on your knees or against the wall."
    wallSit.duration = 30
    
    addExercise(wallSit)
    
    //push-ups
    let pushups = Exercise()
    pushups.userCreated = false
    pushups.name = "Push-Ups"
    pushups.photoFileName = "squat"
    pushups.instructions = "Start with your hands slightly wider apart than your shoulders. Then bend your arms until your chest almost touches the ground and push yourself up to the starting position. Maintain a straight body line through the whole exercise. You can make it easier by placing your knees on the ground."
    pushups.duration = 30
    
    addExercise(pushups)
    
    //crunches
    let crunches = Exercise()
    crunches.userCreated = false
    crunches.name = "Crunches"
    crunches.photoFileName = "squat"
    crunches.instructions = "Lay down on your back with your legs apart and slightly bent. Then use your stomach muscles to crunch so your upper body lifts up from the ground towards your legs, then back down on the ground. Make sure you don't move your head up or down by always having free space between your chin and your chest."
    crunches.duration = 30
    
    addExercise(crunches)
    
    //step-ups
    let stepups = Exercise()
    stepups.userCreated = false
    stepups.name = "Step-Ups"
    stepups.photoFileName = "squat"
    stepups.instructions = "Stand in front of a sturdy chair and step your first foot onto the chair followed by your second foot. When both are on the chair, move down your first foot and lift it back up again. Repeat, alternating the foot you step down with so you exercise each leg."
    stepups.duration = 30
    
    addExercise(stepups)
    
    //squat
    let squat = Exercise()
    squat.userCreated = false
    squat.name = "Squat"
    squat.photoFileName = "squat"
    squat.instructions = "Start with your legs slightly wider than your hips and your toes pointing slightly outwards. Then with a straight back bend your knees until you reach a 90 degree angle. Maintain the straight back when you push yourself up to the starting position."
    squat.duration = 30
    
    addExercise(squat)
    
    //triceps dips
    let tricepsDips = Exercise()
    tricepsDips.userCreated = false
    tricepsDips.name = "Triceps Dips"
    tricepsDips.photoFileName = "squat"
    tricepsDips.instructions = "Bend your elbows 90 degrees and place them right under your shoulders. Then lift your body up so it stays straight in the air supported by your arms and feet. If it's hard, try putting down your knees. Always keep your forearms straight forward."
    tricepsDips.duration = 30
    
    addExercise(tricepsDips)
    
    //plank
    let plank = Exercise()
    plank.userCreated = false
    plank.name = "Plank"
    plank.photoFileName = "squat"
    plank.instructions = "Run in place by lifting your knees as high as possible and swinging your arms as if you were running normally. Make sure to land on the front of your foot to avoid stress on the knees."
    plank.duration = 30
    
    addExercise(plank)
    
    //high knees
    let highKnees = Exercise()
    highKnees.userCreated = false
    highKnees.name = "High Knees"
    highKnees.photoFileName = "squat"
    highKnees.instructions = "Stand up and go up and down"
    highKnees.duration = 30
    
    addExercise(highKnees)
    
    //lunges
    let lunges = Exercise()
    lunges.userCreated = false
    lunges.name = "Lunges"
    lunges.photoFileName = "squat"
    lunges.instructions = "Look forward with a straight back and relaxed shoulders. Then step forward with one left and bend it until both knees are in a 90 degree angle. Keep the weight on your heels as you push back up into the starting position and repeat with your opposite leg."
    lunges.duration = 30
    
    addExercise(lunges)
    
    //push up w/ rotation
    let pushupRotation = Exercise()
    pushupRotation.userCreated = false
    pushupRotation.name = "Push-Ups With Rotation"
    pushupRotation.photoFileName = "squat"
    pushupRotation.instructions = "Perform a regular push-up, but when you enter the top position rotate to the side with both your arms extended. One lifting your body from the ground and the second straight towards the ceiling. Then rotate back and repeat to the opposite side."
    pushupRotation.duration = 30
    
    addExercise(pushupRotation)
    
    //side plank
    let sidePlank = Exercise()
    sidePlank.userCreated = false
    sidePlank.name = "Side Plank"
    sidePlank.photoFileName = "squat"
    sidePlank.instructions = "Start from the plank position and rotate to the side with a straight body supported by your forearms and side of your foot. Keep your hips up from the ground and your ankles straight as you hold the position. Make it harder by having straight arms, or easier by resting your knees on the ground."
    sidePlank.duration = 30
    
    addExercise(sidePlank)
    
    // Workouts
    
    let workout1 = Workout()
    workout1.userCreated = false
    workout1.name = "7 Minute Workout"
    workout1.restInterval = 10
    workout1.exercises = [jumpingJacks, wallSit, pushups,
      crunches, stepups, squat, tricepsDips, plank, highKnees,
      lunges, pushupRotation, sidePlank]
    
    addWorkout(workout1)
    
    let workout2 = Workout()
    workout2.userCreated = false
    workout2.name = "Ray's Full Body Workout"
    workout2.restInterval = 10
    workout2.exercises = [jumpingJacks, wallSit, pushups,
      crunches, stepups, squat, highKnees,
      lunges, pushupRotation, sidePlank]
    
    addWorkout(workout2)
    
    let workout3 = Workout()
    workout3.userCreated = false
    workout3.name = "Upper Body Workout"
    workout3.restInterval = 10
    workout3.exercises = [pushups, tricepsDips, pushupRotation]
    
    addWorkout(workout3)
    
    let workout4 = Workout()
    workout4.userCreated = false
    workout4.name = "Lower Body Workout"
    workout4.restInterval = 10
    workout4.exercises = [jumpingJacks, wallSit, stepups,
      squat, highKnees, lunges]
    
    addWorkout(workout4)
    
    let workout5 = Workout()
    workout5.userCreated = false
    workout5.name = "Abdominal Workout"
    workout5.restInterval = 10
    workout5.exercises = [crunches, plank, sidePlank]
    
    addWorkout(workout5)
  }
  
}
