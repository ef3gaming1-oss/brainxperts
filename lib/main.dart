name: Build APK

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'

      - name: Setup Android with Firebase Support
        run: |
          mkdir -p backup
          [ -f android/app/google-services.json ] && cp android/app/google-services.json backup/ || true
          rm -rf android
          flutter create . --platforms=android --org=com.example
          mkdir -p android/app
          [ -f backup/google-services.json ] && cp backup/google-services.json android/app/ || true
          
          # Root build.gradle-এ Google Services প্লাগইন যোগ
          sed -i '/dependencies {/a \        classpath "com.google.gms:google-services:4.4.1"' android/build.gradle || true
          
          # App build.gradle-এ প্লাগইন ও minSdkVersion 21 সেট করা
          echo 'apply plugin: "com.google.gms.google-services"' >> android/app/build.gradle
          sed -i 's/minSdkVersion flutter.minSdkVersion/minSdkVersion 21/g' android/app/build.gradle || true

      - name: Get dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: brainxperts-apk
          path: build/app/outputs/flutter-apk/app-release.apk
