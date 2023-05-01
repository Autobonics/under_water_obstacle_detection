//Servo
#include <Servo.h>
static const int servoPin = 33;
Servo servo1;
int pos = 0;

//Ultrasonics sensor
const int trigPin = 32;
const int echoPin = 34;

//define sound speed in cm/uS
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

long duration;
float distanceCm;
float distanceInch;

//Tilt sensor


#define wifiLedPin 2

//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyAGgaTx60-oYH2pOHT5t_3TE009BLIYwqs"
/* 3. Define the RTDB URL */  
#define DATABASE_URL "https://accident-detection-c160e-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device2@gmail.com"
#define USER_PASSWORD "autobonics@123"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;


unsigned long printDataPrevMillis = 0;



void setup() {

  Serial.begin(115200); // Starts the serial communication
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input

  servo1.attach(servoPin);
 
  pinMode(wifiLedPin, INPUT);
  digitalWrite(wifiLedPin, LOW);
   
  //WIFI
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  digitalWrite(wifiLedPin, HIGH);
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";
}

void loop() {
  readDistance();
  printData();
  updateData();
}

bool isIncrementing  = false;

void updateData() {
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0))
  {
    runServo();
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("p", pos);
    json.set("d", distanceCm);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.set(&fbdo, path.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    Serial.println("");
  }
}


void runServo(){
  if(pos == 0){
    isIncrementing = true;
  } else if(pos == 180){
    isIncrementing = false;
  }
  if(isIncrementing){
    pos+=5;
  } else {
    pos-=5;
  }
  servo1.write(pos);
}


void printData() {
  if (millis() - printDataPrevMillis > 2000 || printDataPrevMillis == 0)
  {
    printDataPrevMillis = millis();
    Serial.print("Distance in cm: ");
    Serial.println(distanceCm);
  }
}



void readDistance() {
  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  
  // Calculate the distance
  distanceCm = duration * SOUND_SPEED/2;
  
  // Convert to inches
  distanceInch = distanceCm * CM_TO_INCH;
  
  // Prints the distance in the Serial Monitor
  // Serial.print("Distance (cm): ");
  // Serial.println(distanceCm);
  // Serial.print("Distance (inch): ");
  // Serial.println(distanceInch);
  
  delay(1000);
}