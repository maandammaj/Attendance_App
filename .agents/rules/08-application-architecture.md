# Application Architecture & API Design

## API Design Principles
* **Consider the User:** Design APIs to be intuitive and easy to use correctly.
* **Documentation is Essential:** Provide concise documentation with clear examples.

## Application Architecture
* **Separation of Concerns:** Maintain distinct roles (similar to MVC/MVVM).
* **Logical Layers:**
  * **Presentation:** Widgets and screens.
  * **Domain:** Business logic classes.
  * **Data:** Models and API clients.
  * **Core:** Shared utilities, extensions, and common classes.
* **Feature-based Organization:** For large projects, organize folders by feature with presentation, domain, and data subfolders.