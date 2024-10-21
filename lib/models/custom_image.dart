enum CustomImage {
  defaultLandscape,
  rainbowRoad,
  morningFogMountains,
}

final Map<CustomImage, String> imageToName = {
  CustomImage.defaultLandscape: "lib/assets/images/default_landscape.jpg",
  CustomImage.rainbowRoad: "lib/assets/images/rainbow_road.jpg",
  CustomImage.morningFogMountains:
      "lib/assets/images/morning_fog_mountains.jpg",
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
