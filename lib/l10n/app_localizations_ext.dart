import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension RecipeLocalizationExtension on AppLocalizations {
  String getRecipeTitle(int index) {
    return switch (index) {
      1 => recipeTitle1,
      2 => recipeTitle2,
      3 => recipeTitle3,
      4 => recipeTitle4,
      5 => recipeTitle5,
      6 => recipeTitle6,
      _ => 'Recipe',
    };
  }

  String getRecipeDescription(int index) {
    return switch (index) {
      1 => recipeDescription1,
      2 => recipeDescription2,
      3 => recipeDescription3,
      4 => recipeDescription4,
      5 => recipeDescription5,
      6 => recipeDescription6,
      _ => '',
    };
  }
}
