import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pokédex",
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map pokeData = {};
  List pokeList = [];
  bool isLoading = true;
  String? errorMessage;

  Map<String, Color> typeColors = {
    "Grass": Colors.green,
    "Fire": Colors.red,
    "Water": Colors.blue,
    "Electric": Colors.yellow,
    "Bug": Colors.lightGreen,
    "Poison": Colors.purple,
    "Ground": Colors.brown,
    "Rock": Colors.grey,
    "Psychic": Colors.pink,
    "Fighting": Colors.orange,
    "Ghost": Colors.indigo,
    "Ice": Colors.cyan,
    "Dragon": Colors.deepPurple,
    "Normal": Colors.black26,
    "Fairy": Colors.pinkAccent,
    "Steel": Colors.blueGrey,
    "Dark": Colors.black87,
  };

  Future<void> getData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    const urlString =
        "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

    try {
      final uri = Uri.parse(urlString);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          pokeData = json.decode(response.body);
          pokeList = pokeData['pokemon'];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pokédex"),
        backgroundColor: const Color.fromARGB(255, 211, 18, 18),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getData,
            tooltip: "Refresh Data",
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error loading data:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: getData,
            ),
          ],
        ),
      );
    }

    if (pokeList.isEmpty) {
      return const Center(child: Text("No Pokémon found."));
    }

    return RefreshIndicator(
      onRefresh: getData,
      child: ListView.builder(
        itemCount: pokeList.length,
        itemBuilder: (context, index) {
          final pokemon = pokeList[index];
          final type = pokemon['type'][0];
          final color = typeColors[type] ?? Colors.grey;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pokemon['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Image.network(
                      pokemon['img'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Candy: ${pokemon['candy']}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
