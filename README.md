# Calculator
A basic calculator that can perform mathematical tasks

## Objective
Develop a simple calculator that can perform simple arithmetic tasks.

## Design
I decided to base the design on the iOS calculator app, as I enjoyed the rounded buttons. I paid special attention to making sure that the app would be accessible to someone using VoiceOver, and the other advantage of this is UI tests are easier to write, as they use accessibility identifiers to locate controls on screen.

Deviating from Apple's design, I've added a calculation display that shows the state of the calculation. This made it easier to debug the application, and also adds value to a user who is inputting a complicated calculation. The application moves the input to the right side when running on the compact height size class, to make the buttons less flat.

## Calculation
For calculation, I build a tree of values and operators, which can be evaluated. A node takes an input, and returns a new node representing the result of the applied input. I enjoy this functional approach, but it does make it a little more difficult to understand at a glance. Other options I considered was having a running accumulator, but I found it more difficult to implement order of operations this way. I could also take each input into a stack

## Testing
The calculation code is almost completely covered. My approach to testing is to user test the app, and make all anomalous results into test cases that I can work again. UI tests ensure that the minimal functionality of the main UIViewController is functional.

## Future Extensions
- Implement more buttons. The actual iOS calculator presents more controls when rotated horizontally, all of which would be fun to implement.
- Implement a reverse polish notation mode.
