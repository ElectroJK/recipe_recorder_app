import 'package:flutter/material.dart';
import 'package:recipe_recorder_app/HomePage/home_page.dart';
import 'package:recipe_recorder_app/models/recipe.dart';

final List<Recipe> recipes = [
  Recipe(
    id: '1',
    title: 'Spaghetti Carbonara',
    description: 'Creamy pasta with bacon and parmesan.',
    image:
        'https://static01.nyt.com/images/2021/02/14/dining/carbonara-horizontal/carbonara-horizontal-threeByTwoMediumAt2X-v2.jpg',
  ),
  Recipe(
    id: '2',
    title: 'Chicken Curry',
    description: 'Spicy Indian-style curry with chicken.',
    image:
        'https://www.allrecipes.com/thmb/FL-xnyAllLyHcKdkjUZkotVlHR8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/46822-indian-chicken-curry-ii-DDMFS-4x3-39160aaa95674ee395b9d4609e3b0988.jpg',
  ),
  Recipe(
    id: '3',
    title: 'Beef Stroganoff',
    description: 'Tender beef in mushroom cream sauce.',
    image:
        'https://www.allrecipes.com/thmb/mSWde3PHTu-fDkbvWBw0D1JlS8U=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/25202beef-stroganoff-iii-ddmfs-3x4-233-0f26fa477e9c446b970a32502468efc6.jpg',
  ),
  Recipe(
    id: '4',
    title: 'Tuna Salad',
    description: 'Fresh and quick salad with tuna and veggies.',
    image:
        'https://littlespoonfarm.com/wp-content/uploads/2021/08/tuna-salad-recipe-card.jpg',
  ),
  Recipe(
    id: '5',
    title: 'Pancakes',
    description: 'Fluffy pancakes with maple syrup.',
    image:
        'https://www.allrecipes.com/thmb/FE0PiuuR0Uh06uVh1c2AsKjRGbc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/21014-Good-old-Fashioned-Pancakes-mfs_002-0e249c95678f446291ebc9408ae64c05.jpg',
  ),
  Recipe(
    id: '6',
    title: 'Tomato Soup',
    description: 'Warm soup with fresh tomatoes and herbs.',
    image:
        'https://cdn.loveandlemons.com/wp-content/uploads/2023/01/tomato-soup-recipe.jpg',
  ),
];
