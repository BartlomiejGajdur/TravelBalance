import 'package:flutter/material.dart';

enum CustomImage {
  defaultLandscape,
  rainbowRoad,
  morningFogMountains,
  colorfulCity,
  desert,
  forest,
  greece,
  greenLandscape,
  italyMountains,
  vacations
}

final Map<CustomImage, String> imageToName = {
  CustomImage.defaultLandscape: "lib/assets/images/default_landscape.jpg",
  CustomImage.rainbowRoad: "lib/assets/images/rainbow_road.jpg",
  CustomImage.morningFogMountains:
      "lib/assets/images/morning_fog_mountains.jpg",
  CustomImage.colorfulCity: "lib/assets/images/colorful_city.jpg",
  CustomImage.desert: "lib/assets/images/desert.jpg",
  CustomImage.forest: "lib/assets/images/forest.jpg",
  CustomImage.greece: "lib/assets/images/greece.jpg",
  CustomImage.greenLandscape: "lib/assets/images/green_landscape.jpg",
  CustomImage.italyMountains: "lib/assets/images/italy_mountains.jpg",
  CustomImage.vacations: "lib/assets/images/vacations.jpg",
};

CustomImage getImageById(int id) {
  if (id < 0 || id >= CustomImage.values.length) {
    return CustomImage.defaultLandscape;
  } else {
    return CustomImage.values[id];
  }
}

String getPathToImage(CustomImage customImage) {
  return imageToName[customImage] ?? imageToName[CustomImage.defaultLandscape]!;
}

void precacheAllImages(BuildContext context) {
  imageToName.forEach((customImage, imagePath) {
    precacheImage(AssetImage(imagePath), context);
  });
}
