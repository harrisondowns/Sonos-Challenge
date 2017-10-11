// ---------------------------------------------------------------------------
// Example NewPing library sketch that does a ping about 20 times per second.
// ---------------------------------------------------------------------------

#include <NewPing.h>

#include <ESP8266WiFi.h>

#define TRIGGER_PIN  5  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     4  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 500 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
#define RED_PIN 0
#define GREEN_PIN 2
#define BLUE_PIN 14

const char* ssid     = "Tufts_Guest";
const char* password = "";
//const char* ssid     = "Fios-8QF4L";
//const char* password = "row7210slap5434wet";
const char* host = "sonos-challenge.herokuapp.com";
int sensorData[60];
int red = 255;
int green = 0;
int sstatus = 0;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

void setup() {
  Serial.begin(115200); // Open serial monitor at 115200 baud to see ping results.
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
  analogWrite(RED_PIN, red);
  analogWrite(GREEN_PIN, green);
  analogWrite(BLUE_PIN, 0);
  /*###### Wifi stuff ########*/
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  for (int i = 0; i < 60; i++) {
    sensorData[i] = 0;
  }
  analogWrite(RED_PIN, red);
  analogWrite(GREEN_PIN, green);
  //  analogWrite(BLUE_PIN, 255);

  sendData();
}


#define FADESPEED 25
int rb = 0;
int gb = 0;
int newPerson = 1;



void handleFade() {

  if (red < 253 && green > 2 && sstatus == 0) {
    red += 3;
    green -= 3;
  }
  if (green < 254 && red > 1 && sstatus == 1) {
    red -= 2;
    green += 2;
  }
  /*
    if (red <= 0){// || green > 0){
    rb = 0;
    }
    if (green <= 0){
    gb = 0;
    }
    if (red >= 255){
    rb = 0;
    }
    if (green >= 255){
    gb = 0;
    }
    red += rb;
    green += gb;*/
  analogWrite(RED_PIN, red);
  analogWrite(GREEN_PIN, green);
  analogWrite(BLUE_PIN, 0);
  delay(FADESPEED);

}

void sendData() {
  Serial.print("connecting to ");
  Serial.println(host);

  // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }

  // We now create a URI for the request
  String url = "/";


  Serial.print("Requesting URL: ");
  Serial.println(url);
  String data = "distance=" + String(sstatus);
  Serial.println(data);

  client.println("POST /sensor1.php HTTP/1.1");
  client.println(String("Host: ") + host);
  client.println("Accept: */*");
  client.println("Content-Type: application/x-www-form-urlencoded");
  client.print("Content-Length: ");
  client.println(data.length());
  client.println();
  client.print(data);
  unsigned long timeout = millis();
  while (client.available() == 0) {
    if (millis() - timeout > 5000) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }

  // Read all the lines of the reply from server and print them to Serial
  while (client.available()) {
    String line = client.readStringUntil('\r');
    Serial.print(line);
  }

  Serial.println();
  Serial.println("closing connection");
}

void handleData() {
  int over200 = 0;
  int zero = 0;
  int farther = 0;
  int closer = 0;
  int last = sensorData[0];
  int total = 0;
  for (int i = 0; i < 60; i++) {
    if (sensorData[i] >= 200) {
      over200++;
    }
    if (sensorData[i] == 0 || sensorData[i] == 250) {
      zero++;
    }
    else if (sensorData[i] > last) {
      farther++;
      last = sensorData[i];
      total += last;
    }
    else if (sensorData[i] <= last) {
      closer++;
      last = sensorData[i];
      total += last;
    }
  }
  int average = total / (60 - zero);
  int topAvg = 0;
  int botAvg = 0;
  for (int i = 0; i < 10; i++) {
    botAvg += sensorData[i];
    topAvg += sensorData[59 - i];
  }
  topAvg /= 10;
  botAvg /= 10;
  int derivative = topAvg - botAvg;
  if (zero >= 30) {
    newPerson = 1;
  }
  else {
    if (average <= 50) {
      if (newPerson == 1 && sstatus == 0) {
        Serial.println("Turning ON speaker! due to average");
        for (int i = 0; i < 60; i++){
        //  Serial.print(sensorData[i])
        }
        newPerson = 0;
        sstatus = 1;
        sendData();
      }
    }
    if (derivative <= -30) {
      if ( sstatus == 0) { //topAvg <= 170 &&
        Serial.println("Turning ON speaker! due to derivative");
        newPerson = 0;
        sstatus = 1;
        sendData();
      }
    }
 //   Serial.println("Garbo");
    if (derivative >= 30) {
      // Serial.println("der > 50 bavg is ");
      // Serial.println(botAvg);
      if (sstatus == 1) { //topAvg >= 150 &&
        Serial.println("Turning OFF speaker! due to derivative");
        sstatus = 0;
        sendData();
      }
    }
  //  Serial.println("alal");
  }


}

int numZ = 0;



void loop() {

  handleFade();                     // Wait 50ms between pings (about 20 pings/sec). 29ms should be the shortest delay between pings.
  int s = sonar.ping_cm();
  if (s > 140){
    s = 140;
  }
  if (s != 0) {
    for (int i = 0; i < 59; i++) {
      sensorData[i] = sensorData[i + 1];
    }
    sensorData[59] = s;
    if (s < 140) {
      if (numZ >= 20){
        Serial.println("nunZ flush");
        for (int i = 0; i < 59; i++){
          sensorData[i] = s;
        }
      }
      numZ = 0;
      
    }
  }
  if (s == 0 || s >= 140) {
    numZ ++;
  }
  if (numZ >= 5) {
    //Serial.println("FLUSH!");
    for (int i = 0; i < 60; i++) {
      sensorData[i] = 140;
    }
  }
  else if (s != 0) {
  //if (s != 0) {
    Serial.println(s);
  }

  
  handleData();

  //  digitalWrite(RED_PIN, HIGH);

  handleFade();


}
