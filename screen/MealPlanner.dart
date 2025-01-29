import 'package:flutter/material.dart';
import 'package:recipe/model/RecipeMode.dart';

class MealPlanner extends StatefulWidget {
  const MealPlanner({super.key});

  @override
  _MealPlannerState createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
  Map<String, Map<String, RecipeModel?>> mealPlan = {
    'Monday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Tuesday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Wednesday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Thursday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Friday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Saturday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
    'Sunday': {'Breakfast': null, 'Lunch': null, 'Dinner': null},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
        backgroundColor: const Color.fromARGB(255, 58, 146, 194),
      ),
      body: ListView(
        children: mealPlan.keys.map((day) {
          return ExpansionTile(
            title: Text(day),
            children: mealPlan[day]!.keys.map((meal) {
              return ListTile(
                title: Text(meal),
                subtitle: mealPlan[day]![meal] != null
                    ? Text(mealPlan[day]![meal]!.title)
                    : Text('No recipe selected'),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    RecipeModel? selectedRecipe = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeSelectionScreen(),
                      ),
                    );
                    if (selectedRecipe != null) {
                      setState(() {
                        mealPlan[day]![meal] = selectedRecipe;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class RecipeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Recipe'),
        backgroundColor: const Color.fromARGB(255, 58, 146, 194),
      ),
      body: ListView.builder(
        itemCount: RecipeModel.demoRecipe.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(RecipeModel.demoRecipe[index].title),
            onTap: () {
              Navigator.pop(context, RecipeModel.demoRecipe[index]);
            },
          );
        },
      ),
    );
  }
}
