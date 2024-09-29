{ pkgs, config, ... }:

let
    cmdLineToolsVersion = "8.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "30.0.5";
    buildToolsVersions = [ "30.0.3" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    platformVersions = [ "28" "29" "30" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = ["22.0.7026061"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
in

{
  nixpkgs.config = {
    android_sdk.accept_license = true;
    oraclejdk.accept_license = true;
  };

  home.packages = with pkgs; [ 
    # dart
    # flutterPackages-source.stable
    # google-chrome
    android-studio
    android-tools
    android-udev-rules
    chromium
    flutter
    gradle
    jdk17
    scrcpy # Controlling android remotely
    simple-http-server
    vscode
  ];

  # home.file.".dart-tool/dart-flutter-telemetry.config" = {
  #   text = ''
  #     # INTRODUCTION
  #     #
  #     # This is the Flutter and Dart telemetry reporting
  #     # configuration file.
  #     #
  #     # Lines starting with a #" are documentation that
  #     # the tools maintain automatically.
  #     #
  #     # All other lines are configuration lines. They have
  #     # the form "name=value". If multiple lines contain
  #     # the same configuration name with different values,
  #     # the parser will default to a conservative value. 
  #
  #     # DISABLING TELEMETRY REPORTING
  #     #
  #     # To disable telemetry reporting, set "reporting" to
  #     # the value "0" and to enable, set to "1":
  #     reporting=0
  #
  #     # NOTIFICATIONS
  #     #
  #     # Each tool records when it last informed the user about
  #     # analytics reporting and the privacy policy.
  #     #
  #     # The following tools have so far read this file:
  #     #
  #     #   dart-tools (Dart CLI developer tool)
  #     #   devtools (DevTools debugging and performance tools)
  #     #   flutter-tools (Flutter CLI developer tool)
  #     #
  #     # For each one, the file may contain a configuration line
  #     # where the name is the code in the list above, e.g. "dart-tool",
  #     # and the value is a date in the form YYYY-MM-DD, a comma, and
  #     # a number representing the version of the message that was
  #     # displayed.
  #     flutter-tool=2024-03-07,1
  #     dart-tool=2024-03-07,1
  #   '';
  # };
}
