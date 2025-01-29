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

class SavedRecipesPage extends StatefulWidget {
  final bool showSearchBar;

  const SavedRecipesPage({super.key, this.showSearchBar = true});

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  List<RecipeModel> savedRecipes = [];
  List<RecipeModel> filteredRecipes = [];
  RecipeStorage recipeStorage = RecipeStorage();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedRecipes();
  }

  Future<void> loadSavedRecipes() async {
    List<String> savedRecipeIds = await recipeStorage.getSavedRecipes();
    savedRecipes = await getRecipesByIds(savedRecipeIds);
    filteredRecipes = savedRecipes;
    setState(() {});
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = savedRecipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<List<RecipeModel>> getRecipesByIds(List<String> ids) async {
    return RecipeModel.demoRecipe
        .where((recipe) => ids.contains(recipe.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (widget.showSearchBar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: filterRecipes,
              ),
            ),
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(child: Text("No data saved"))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ListView.builder(
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetails(
                                    recipeModel: filteredRecipes[index],
                                  ),
                                ),
                              );
                            },
                            child: RecipeCard(
                              recipeModel: filteredRecipes[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
