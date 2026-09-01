# Code Quality

* **Code Structure:** Adhere to maintainable code structure and separation of concerns (e.g., UI logic separate from business logic).
* **Naming Conventions:** Avoid abbreviations and use meaningful, consistent, descriptive names for variables, functions, and classes.
* **Conciseness & Simplicity:** Write code that is concise yet clear. Avoid obscure/clever code.
* **Error Handling:** Anticipate and handle potential errors. Don't let code fail silently.
* **Styling Rules:**
  * Line length: Lines should be 80 characters or fewer.
  * Use `PascalCase` for classes, `camelCase` for members/variables/functions/enums, and `snake_case` for files.
* **Functions:** Keep functions short with a single purpose (strive for less than 20 lines).
* **Testing:** Write code with testing in mind. Inject mockable versions of objects using standard packages.
* **Logging:** Use the `logging` package instead of `print`.