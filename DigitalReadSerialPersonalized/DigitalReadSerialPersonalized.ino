// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  pinMode(2,INPUT);
  pinMode(3,INPUT);
  pinMode(4,INPUT);
  pinMode(5,INPUT);
  pinMode(6,INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  String dataString = "";
  int data;

  data = digitalRead(2);
  dataString += String(data);

  data = digitalRead(3);
  dataString += String(data);

  data = digitalRead(4);
  dataString += String(data);

  data = digitalRead(5);
  dataString += String(data);

  data = digitalRead(6);
  dataString += String(data);

  Serial.println(dataString);
  
  delay(1000);
}
