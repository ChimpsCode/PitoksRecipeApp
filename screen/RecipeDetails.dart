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
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:tabler_icons/tabler_icons.dart';

class RecipeDetails extends StatefulWidget {
  final RecipeModel recipeModel;

  const RecipeDetails({super.key, required this.recipeModel});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late RecipeStorage recipeStorage;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    recipeStorage = RecipeStorage();
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    List<String> savedRecipeIds = await recipeStorage.getSavedRecipes();
    setState(() {
      isSaved = savedRecipeIds.contains(widget.recipeModel.id);
    });
  }

  Future<void> toggleSaveRecipe() async {
    if (isSaved) {
      await recipeStorage.removeRecipe(widget.recipeModel.id);
    } else {
      await recipeStorage.saveRecipe(widget.recipeModel);
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  String getPreparationText(String recipeId) {
    switch (recipeId) {
      case '1':
        return "Preparation: \n1. Crack eggs in a bowl, add the Dijon mustard, and whisk until yolks break.\n2. Season with salt and pepper.\n3. Heat olive oil in a pan and add the egg mixture.\n4. Stir in bacon, spinach, and Gruyère cheese.\n5. Cook until eggs are set and serve.";
      case '2':
        return "Preparation: \n1. Beat eggs with milk, salt, and pepper.\n2. Heat olive oil in a pan and pour the egg mixture.\n3. Cook until the eggs are set.\n4. Add spinach and cheese, fold the omelet, and serve.";
      case '3':
        return "Preparation: \n1. Preheat oven to 375°F.\n2. Arrange sausages, bell pepper, onion, and cherry tomatoes on a sheet pan.\n3. Drizzle with olive oil and season with salt and pepper.\n4. Crack eggs over the vegetables.\n5. Bake for 20 minutes or until eggs are set.";
      case '4':
        return "Preparation: \n1. Heat olive oil in a pan and cook onions and bell pepper until softened.\n2. Add garlic, cumin, paprika, and cayenne pepper, and cook for another minute.\n3. Stir in crushed tomatoes and simmer until thickened.\n4. Make wells in the sauce and crack eggs into them.\n5. Cover and cook until eggs are set. Garnish with cilantro and serve.";
      default:
        return "No preparation available.";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minHeight: (size.height / 2),
        maxHeight: size.height / 1.2,
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(widget.recipeModel.title),
              const SizedBox(height: 10),
              Text(widget.recipeModel.writer),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(TablerIcons.heart, color: Colors.red),
                  const SizedBox(width: 5),
                  const Text("198"),
                  const SizedBox(width: 10),
                  const Icon(TablerIcons.timeline),
                  const SizedBox(width: 4),
                  Text('${widget.recipeModel.cookingTime}\''),
                  const SizedBox(width: 20),
                  Container(width: 2, height: 30, color: Colors.black),
                  const SizedBox(width: 10),
                  Text('${widget.recipeModel.servings} Servings'),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.black.withOpacity(0.3)),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.red,
                        tabs: [
                          Tab(text: "Ingredients".toUpperCase()),
                          Tab(text: "Preparation".toUpperCase()),
                        ],
                        labelColor: Colors.black,
                        indicator: DotIndicator(
                          color: Colors.black,
                          distanceFromCenter: 16,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 32),
                      ),
                      Divider(color: Colors.black.withOpacity(0.3)),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Ingredients(recipeModel: widget.recipeModel),
                            Container(
                              child: Text(getPreparationText(widget.recipeModel.id)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.recipeModel.imgPath,
                    child: ClipRRect(
                      child: Image(
                        width: double.infinity,
                        height: (size.height / 2) + 50,
                        fit: BoxFit.cover,
                        image: AssetImage(widget.recipeModel.imgPath),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                right: 20,
                child: InkWell(
                  onTap: toggleSaveRecipe,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        isSaved
                            ? TablerIcons.bookmark
                            : TablerIcons.bookmark_off,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    TablerIcons.arrow_back,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ingredients extends StatelessWidget {
  const Ingredients({super.key, required this.recipeModel});

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: recipeModel.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text('⚫️ ${recipeModel.ingredients[index]}'),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Colors.black.withOpacity(0.3));
              },
            ),
          ],
        ),
      ),
    );
  }
}
