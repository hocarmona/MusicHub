
To set up and run the application, follow these steps:

Clone the repository to your local machine using the following command:

git clone https://github.com/hocarmona/MusicHub.git
Open the project in Xcode by navigating to the cloned directory and double-clicking the .xcodeproj file.

Run the Application:
Select the desired simulator or your connected device in Xcode and click the run button to build and run the application.

Analysis and Development Process
During the development process, the following steps were taken:

Requirement Analysis:
Initially, requirements were gathered to understand the core features of the application, such as artist search functionality and displaying artist details.

Design:
A design plan was established, focusing on the user interface and user experience to ensure ease of use and accessibility.

Implementation:
The application was built using SwiftUI for the user interface, combined with the MVVM (Model-View-ViewModel) architecture to separate concerns and improve maintainability. This architecture allows for better management of UI-related code and business logic.

Testing:
The application was thoroughly tested to ensure all features worked as expected, with specific focus on the search functionality and data presentation.

Architecture Description
The application is built using the MVVM (Model-View-ViewModel) architecture, which offers several advantages:

Separation of Concerns: MVVM separates the user interface (View) from the business logic (ViewModel), making the codebase cleaner and easier to maintain.

Data Binding: The use of @Published properties in the ViewModel allows for automatic updates in the View when the data changes, ensuring the user interface is always in sync with the underlying data model.

Testability: This architecture makes it easier to test the business logic independently from the user interface, which can help identify and fix bugs more efficiently.

Scalability: The separation provided by MVVM allows the application to grow more easily, as new features can be added to the ViewModel without significantly impacting the View.

By following these guidelines, you should be able to set up and run the application smoothly while understanding the rationale behind the architecture choices made during development.
