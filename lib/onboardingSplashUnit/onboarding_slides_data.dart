import 'package:flutter/material.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_colors.dart';
import 'package:hafez_poems/models/onboarding_slide_data.dart';

const List<SlideData> onboardingSlides = [
  SlideData(
    icon: Icons.menu_book_rounded,
    title: "دیوان کامل حافظ",
    subtitle: "تمام غزلیات، رباعیات و قصاید حافظ\nدر یک مجموعه زیبا و خوانا",
    lightBgTop: OnboardingColors.slide1LightBgTop,
    lightBgBottom: OnboardingColors.slide1LightBgBottom,
    darkBgTop: OnboardingColors.slide1DarkBgTop,
    darkBgBottom: OnboardingColors.slide1DarkBgBottom,
    lightAccent: OnboardingColors.slide1LightAccent,
    darkAccent: OnboardingColors.slide1DarkAccent,
  ),

  SlideData(
    icon: Icons.auto_awesome_rounded,
    title: "فال حافظ",
    subtitle: "با نیتی از دل فال بگیر\nو پیام حافظ را بخوان",
    lightBgTop: OnboardingColors.slide2LightBgTop,
    lightBgBottom: OnboardingColors.slide2LightBgBottom,
    darkBgTop: OnboardingColors.slide2DarkBgTop,
    darkBgBottom: OnboardingColors.slide2DarkBgBottom,
    lightAccent: OnboardingColors.slide2LightAccent,
    darkAccent: OnboardingColors.slide2DarkAccent,
  ),

  SlideData(
    icon: Icons.headphones_rounded,
    title: "پخش صوتی اشعار",
    subtitle: "به غزل‌های حافظ با صدای دلنشین گوش بده\nو در شعرها غرق شو",
    lightBgTop: OnboardingColors.slide3LightBgTop,
    lightBgBottom: OnboardingColors.slide3LightBgBottom,
    darkBgTop: OnboardingColors.slide3DarkBgTop,
    darkBgBottom: OnboardingColors.slide3DarkBgBottom,
    lightAccent: OnboardingColors.slide3LightAccent,
    darkAccent: OnboardingColors.slide3DarkAccent,
  ),
];
