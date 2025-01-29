// This app contains various food recipes from around the world.
// To make your recipe app user-friendly and engaging, and help users discover and cook delicious meals,
// the possible features are the following:
// - Ingredients and Instructions/Procedures
// - Recipe Search and Filters
// - Recipe Categories
// - Nutritional Information
// - Meal Planner
// - others

import 'package:flutter/material.dart';
import 'package:recipe/model/RecipeMode.dart';
import 'package:recipe/model/data/recipe_storage.dart';
import 'package:recipe/screen/NewRecipe.dart';
import 'package:recipe/screen/RecipeDetails.dart';
import 'package:recipe/screen/saved.dart';
import 'package:recipe/screen/MealPlanner.dart';

class Recipepage extends StatefulWidget {
  const Recipepage({super.key});

  @override
  _Recipepage createState() => _Recipepage();
}

class _Recipepage extends State<Recipepage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [NewRecipe(), SavedRecipesPage(showSearchBar: false)];
  List<RecipeModel> savedRecipes = [];
  List<RecipeModel> filteredRecipes = [];
  RecipeStorage recipeStorage = RecipeStorage();
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadSavedRecipes();
  }

  Future<void> loadSavedRecipes() async {
    List<String> savedRecipeIds = await recipeStorage.getSavedRecipes();
    savedRecipes = await getRecipesByIds(savedRecipeIds);
    filteredRecipes = [];
    setState(() {});
  }

  Future<List<RecipeModel>> getRecipesByIds(List<String> ids) async {
    List<RecipeModel> recipes = [];
    for (String id in ids) {
      RecipeModel recipe = RecipeModel.demoRecipe.firstWhere(
        (recipe) => recipe.id == id,
        orElse: () => RecipeModel(
          id: '',
          title: 'Unknown Recipe',
          writer: 'Unknown',
          description: '',
          cookingTime: 0,
          servings: 0,
          imgPath: '',
          ingredients: [],
        ),
      );
      // Pastikan Anda hanya menambahkan resep yang valid
      if (recipe.id.isNotEmpty) {
        recipes.add(recipe);
      }
    }
    return recipes;
  }

  Future<void> toggleSaveRecipe(RecipeModel recipe) async {
    if (savedRecipes.contains(recipe)) {
      await recipeStorage.removeRecipe(recipe.id);
      setState(() {
        savedRecipes.remove(recipe);
      });
    } else {
      await recipeStorage.saveRecipe(recipe);
      setState(() {
        savedRecipes.add(recipe);
      });
    }
  }

  void filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecipes = [];
      } else {
        filteredRecipes = RecipeModel.demoRecipe
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()) ||
                recipe.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void filterByCategory(String category) {
    setState(() {
      filteredRecipes = RecipeModel.demoRecipe
          .where((recipe) => recipe.title.toLowerCase().contains(category.toLowerCase()))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToRecipe(String category) {
    List<RecipeModel> recipes;
    switch (category) {
      case 'Lamb':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Roast Lamb' || r.title == 'Classic Lamb Stew').toList();
        break;
      case 'Chicken':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Chicken Curry' || r.title == 'Spicy Honey Garlic Chicken Thighs').toList();
        break;
      case 'Beef':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Beef Steak' || r.title == 'Beef Stroganoff').toList();
        break;
      case 'Vegetables':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Sauteed Carrots' || r.title == 'Stir-Fried Mixed Vegetables in Soy Sauce').toList();
        break;
      case 'Cereal':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Cereal Bars' || r.title == 'Granola with Nuts and Honey').toList();
        break;
      case 'Carbohydrates':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Fried Rice').toList();
        break;
      case 'Seafood':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Garlic Shrimp' || r.title == 'Baked Salmon' || r.title == 'Sour Stew').toList();
        break;
      case 'Desserts':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Cherry Pudding Cake').toList();
        break;
      case 'Snacks':
        recipes = RecipeModel.demoRecipe.where((r) => r.title == 'Snack Balls').toList();
        break;
      default:
        recipes = [];
    }
    if (recipes.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeListScreen(recipes: recipes),
        ),
      );
    }
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pitoks Recipe',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Image.asset('assets/images/pitoks.png', width: 50, height: 50),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/pitoks.png', width: 200, height: 130),
                  
                  
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Meal Planner', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealPlanner()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: isDarkMode ? Colors.white : Colors.black),
              title: Text('About Us', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About Us'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 130,
                                height: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/boss.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Boss Zata',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '"Lead Developer"\nThe mind behind\nour recipe app,\nblending technology\nand culinary\ncreativity to make\ncooking effortless\nand enjoyable for all',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 130,
                                height: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/shaun.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shaun Belono-ac',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '"UI/UX Designer"\nCrafting intuitive,\nstunning designs\nfor a seamless\nand delightful recipe\napp experience.',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: isDarkMode ? Colors.white : Colors.black),
              title: Text('Dark Mode', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              onTap: toggleDarkMode,
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  if (_selectedIndex == 0)
                    Column(
                      children: [
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search recipes...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: filterRecipes,
                        ),
                        if (filteredRecipes.isNotEmpty)
                          Container(
                            color: isDarkMode ? Colors.black : Colors.white,
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredRecipes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(filteredRecipes[index].title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetails(recipeModel: filteredRecipes[index]),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (_selectedIndex == 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (_selectedIndex == 0)
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () => navigateToRecipe('Lamb'),
                            child: _buildCategoryItem('Lamb', 'assets/images/pic1.jfif'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Chicken'),
                            child: _buildCategoryItem('Chicken', 'assets/images/pic2.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Beef'),
                            child: _buildCategoryItem('Beef', 'assets/images/pic3.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Vegetables'),
                            child: _buildCategoryItem('Vegetables', 'assets/images/pic4.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Cereal'),
                            child: _buildCategoryItem('Cereal', 'assets/images/pic5.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Carbohydrates'),
                            child: _buildCategoryItem('Carbohydrates', 'assets/images/pic6.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Seafood'),
                            child: _buildCategoryItem('Seafood', 'assets/images/pic7.jpg'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Desserts'),
                            child: _buildCategoryItem('Desserts', 'assets/images/pic8.jfif'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigateToRecipe('Snacks'),
                            child: _buildCategoryItem('Snacks', 'assets/images/pic9.jpg'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 59,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 58, 146, 194),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white : Colors.black)),
      ],
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  final List<RecipeModel> recipes;

  const RecipeListScreen({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        backgroundColor: const Color.fromARGB(255, 58, 146, 194),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetails(recipeModel: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
