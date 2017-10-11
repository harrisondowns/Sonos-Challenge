Sonos Challenge Code README

Folders: 


SensorDriverCode: The arduino sketch that actually controls the leds and analyzes the sensor data.

sonosiOSController: Slight variation on the example iOS app that we used to control the speakers themselves. Reads from the web server and then scales volume up and down depending on the sensor data.

webServer: Website files that the ESP chip posts to and the sonosiOSController reads from.

not used code: original draft of an app to control the sonos speakers. No code from here made it in to the final product.