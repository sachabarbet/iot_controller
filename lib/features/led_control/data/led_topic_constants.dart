const String espLedIdTopic = "esp-led";
const String ledDataTopic = "$espLedIdTopic/data"; // Subscribe
const String ledModeTopic = "$espLedIdTopic/mode"; // Publish
const String ledControlTopic = "$espLedIdTopic/control"; // Publish
const String ledPingTopic = "/get/$ledDataTopic"; // Publish (trigger data topic)