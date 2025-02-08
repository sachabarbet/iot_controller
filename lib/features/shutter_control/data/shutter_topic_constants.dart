const String espShutterIdTopic = "esp-shutter";
const String shutterDataTopic = "$espShutterIdTopic/data"; // Subscribe
const String shutterModeTopic = "$espShutterIdTopic/mode"; // Publish
const String shutterControlTopic = "$espShutterIdTopic/control"; // Publish
const String shutterPingTopic = "$espShutterIdTopic/ping"; // Publish (trigger data topic)