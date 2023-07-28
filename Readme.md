# Flashzilla

This is project 17 of 100 Days of SwiftUI by Paul Hudson (link [here](https://www.hackingwithswift.com/books/ios-swiftui/flashzilla-introduction)). This is an app that helps users learn things using flashcards – cards with one thing written on such as “to buy”, and another thing written on the other side, such as “comprar”.

As usual, at the end of the guided tutorial there will be three challenges for me to solve on my own.

## Challenges

**Challenge #1**: When adding a card, the textfields keep their current text – fix that so that the textfields clear themselves after a card is added.

**Challenge #2**: If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: think about the way we set offset back to 0 immediately, even though the card hasn’t animated yet. You might solve this with a ternary within a ternary, but a custom modifier will be cleaner.)

**Challenge #3**: For a harder challenge: when the users gets an answer wrong, add that card goes back into the array so the user can try it again. Doing this successfully means rethinking the ForEach loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.

**Challenge #4**: Make it use documents JSON rather than UserDefaults – this is generally a good idea, so you should get practice with this.
