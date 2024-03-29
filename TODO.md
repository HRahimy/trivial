# ToDo

- [x] add elder scrolls quiz questions
- [x] implement repository
- [ ] add custom theme
- [ ] add clear way to quit out of running quiz
- [ ] Add loading splash screen and loading message to show on startup
- [ ] Add a starter menu screen to give user information and flavor for what to expect, and a button to begin the quiz. Right now quizzes begin too abruptly.
- [ ] Increase quiz durations 30 seconds
- [ ] Adjust vertical spacing on control buttons on quiz end screens
- [ ] Fix reported spelling errors
- [ ] Update logo and title for the app
- [ ] Add panels on quiz end screen to show score, duration, and quickest question answered
- [ ] Add option on quiz end to view answers to all questions and whether or not they were correct
- [ ] Add widget on quiz screen to show current progress in the quiz (progress indicator? styled text?)
- [ ] Adjust timer to be bigger and have more contrasting colors
- [ ] Update UI view and logic to show users whether or not an answer they selected is correct before they move on to the next question in a running quiz:
  - [ ] Update state data structure to support this new state UI    
  - [ ] Add stylized text widget on quiz screen to show whether their selected answer was correct
  - [ ] Update selected choice color (if a choice was selected) to red or green based on their answer being correct or not
- [ ] Add flavor text to show for different levels of success on a quiz attempt based on their performance. E.g, "You were perfect!" if they achieve 100% score
- [ ] Experiment with new colors on different UI elements. Right now UI seems a bit bland based on feedback.
- [ ] Add sparkle animations on quiz end screen
- [ ] Add release and maintain release notes document in repo to be used in actual release descriptions
- [ ] Update CI/CD workflow to separate steps for building (both web and mobile), release (on github, using build artifacts) creation, and hosting (play store, firebase)

## Tests

- [x] quiz list state and cubit
- [x] quiz state and cubit

### Quiz list

- [x] button is rendered for a quiz
- [x] button contains correct text
- [x] pressing quiz button triggers navigation

### Quiz

- [x] update all keys to be unique based on question id

- [x] question text exists & is correct
- [x] timer exists and is animated
- [x] event to deplete the question triggers when timer runs out
- [x] score panel exists and renders correct score
- [x] options panel contains 4 buttons & renders values correctly
- [x] button for selected options are highlighted
- [x] pressing an option button triggers select event in state
- [x] option buttons are disabled and greyed when time is depleted
- [x] continue button is enabled when question is depleted or option is selected
- [x] pressing continue button triggers continue event in state

### Quiz end screen

- [x] contains flavor text including the final score
- [x] contains the 'try again' button
- [x] 'try again' button resets the quiz
- [x] contains the 'goodbye' button
- [x] 'goodbye' button navigates to last screen