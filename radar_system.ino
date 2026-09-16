#include <ESP32Servo.h>

const int TRIG_PIN   = 12;
const int ECHO_PIN   = 14;
const int SERVO_PIN  = 13;
const int ALARM_PIN  = 27;

const int ALERT_THRESHOLD_CM = 30;
Servo radarServo;

int currentAngle = 0;
int sweepDirection = 1;

float getDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH, 30000);
  if (duration == 0) return 400.0;
  return (duration * 0.0343) / 2.0;
}

void setup() {
  Serial.begin(115200);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  pinMode(ALARM_PIN, OUTPUT);

  ESP32PWM::allocateTimer(0);
  radarServo.setPeriodHertz(50);
  radarServo.attach(SERVO_PIN, 500, 2400);
}

void loop() {
  radarServo.write(currentAngle);
  delay(30);

  float distance = getDistance();
  
  if (distance < ALERT_THRESHOLD_CM) {
    digitalWrite(ALARM_PIN, HIGH);
  } else {
    digitalWrite(ALARM_PIN, LOW);
  }

  // Sends raw data formatted specifically for Processing: angle,distance.
  Serial.print(currentAngle);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");

  currentAngle += sweepDirection;
  if (currentAngle >= 180 || currentAngle <= 0) {
    sweepDirection *= -1;
  }
}