import 'package:recipe/model/RecipeMode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeStorage {
  static const String savedRecipesKey = 'saved_recipes';

  Future<void> saveRecipe(RecipeModel recipe) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedRecipes = prefs.getStringList(savedRecipesKey) ?? [];
    if (!savedRecipes.contains(recipe.id)) {
      savedRecipes.add(recipe.id);
      await prefs.setStringList(savedRecipesKey, savedRecipes);
    }
  }

  Future<void> removeRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedRecipes = prefs.getStringList(savedRecipesKey) ?? [];
    savedRecipes.remove(recipeId);
    await prefs.setStringList(savedRecipesKey, savedRecipes);
  }

  Future<List<String>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(savedRecipesKey) ?? [];
  }
}
