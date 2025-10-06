API Used:
Pokémon GO Pokédex API
Example endpoint:
https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json

How to Run:

Clone or download the project folder.

Open it in VS Code or Android Studio.

Run flutter pub get in the terminal to install dependencies.

Connect a device or emulator and run flutter run.

User Action (Refresh/Search):

Tap the 🔄 refresh button in the AppBar to fetch the latest data.

You can also pull down on the list (pull-to-refresh) to reload Pokémon data.

Edge Case & Handling:

Edge Case: If the API request fails (e.g., no internet connection or server issue).

Handling: The app displays an error message and a “Retry” button so the user can attempt to fetch the data again without crashing.

