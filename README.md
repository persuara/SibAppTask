
https://github.com/user-attachments/assets/aa9ab621-7c3a-40d5-800e-9bbd2a243570
# PocketWords – SibApp iOS Task

**PocketWords** is a single-screen iOS vocabulary learning app built with SwiftUI and SwiftData. It allows users to create flashcards, look up meanings, receive instant feedback, and track XP-based progress. All data is stored locally, with no networking or AI components.

## Architecture

- **Pattern:** MVVM (Model–View–ViewModel)  
  The project is structured into four main modules: **App**, **Logic**, **DataLayer**, and **Model**, with a clear one-way dependency flow:  
  `App → Logic → DataLayer → Model`  
  Each layer depends only on the one below it and is unaware of the layers above, ensuring a clean separation of concerns.

- **Logic Isolation:**  
  Business logic is encapsulated in `WordCardViewModel`, responsible for answer validation, XP tracking, and handling CRUD operations via WordCardPersistentRepository within **Datalayer**.

- **Data Isolation:**  
  A dedicated repository layer handles all CRUD operations and directly interacts with the `Model`.

- **Model Isolation:**  
  All @Model objects are available here.
  
- **Storage:**  
  Uses SwiftData with `@Model` entities for local persistence.

- **Views:**  
  Built with SwiftUI, featuring 3D Y-axis flip animations for flashcards. Key UI components:
  1. `FlippableView` — a generic reusable view that takes front and back content.
  2. `WordFlipView` — the primary flashcard displaying a word and its meaning.
  3. `AddCardModalView` — a modal form sheet with input fields and a submit button (presentation-ready).

- **Accessibility:**  
  VoiceOver support is included via `accessibilityLabel` and `accessibilityHint` modifiers (optional).


## Features

- Add new word cards with a modal sheet (`Word`, `Meaning`)
- Flip cards to view either side
- Input answers and get real-time ✓/✗ feedback
- XP system (+10 XP for each correct answer)
- Determinate progress bar reflecting accuracy
- State and XP persistence with SwiftData

## Build & Run

1. Open the project in **Xcode 16**
2. Ensure the target is **iOS 18**
3. Build and run on simulator or device 

## Testing

- Includes unit test for ViewModel’s answer-checking logic
- Includes unit tests for 

Data layer, aka Repository’s CRUD logic
- Includes UI testing for App add card transaction.
- SwiftUI previews provided
- Optional snapshot test helper stubbed

## Trade-offs

- Focused on delivering clean architecture, persistent storage, and accurate answer validation with functional UI and animations.
- Traditional card-to-card navigation (e.g., flipping through a stack) was not implemented; users interact with one card at a time and can delete it to proceed.
- Basic accessibility support (e.g., VoiceOver labels and hints) was implemented, though full accessibility coverage was out of scope for this time-boxed task.




https://github.com/user-attachments/assets/4796a0a7-fa5a-47bd-97ed-e622b211aa65

