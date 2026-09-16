import processing.serial.*;

Serial myPort;
String angle = "";
String distance = "";
String data = "";
int iAngle, iDistance;
int index1 = 0;

// Trail persistence buffers
int[] objectDistances = new int[181];
int[] objectFade = new int[181]; // Tracks fade opacity for each angle

void setup() {
  size(1200, 700);
  smooth();
  
  // Console prints available ports upon startup
  printArray(Serial.list());
  
  // Connects to COM4 (Index 0). Change [0] if on a different port index
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('.');
  
  // Initialize target buffers
  for (int i = 0; i <= 180; i++) {
    objectDistances[i] = 400;
    objectFade[i] = 0;
  }
}

void draw() {
  background(0); // Clears background every frame for smooth rendering
  
  drawRadar(); 
  drawPersistentTargets(); // Draws extended glowing red target beams
  drawLine();
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.substring(0, data.length() - 1);
    index1 = data.indexOf(",");
    if (index1 > 0) {
      angle = data.substring(0, index1);
      distance = data.substring(index1 + 1, data.length());
      
      iAngle = int(angle);
      iDistance = int(distance);
      
      // Update target storage for valid sweep angles
      if (iAngle >= 0 && iAngle <= 180) {
        objectDistances[iAngle] = iDistance;
        if (iDistance < 30) {
          objectFade[iAngle] = 255; // Full red brightness when detected
        }
      }
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  
  // Radar grid arcs (10cm, 20cm, 30cm, 40cm scale)
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  
  // Radial angle lines
  line(-width / 2, 0, width / 2, 0);
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30)));
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60)));
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90)));
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120)));
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150)));
  popMatrix();
}

void drawPersistentTargets() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(7); // Thick, bold red beam lines
  
  for (int a = 0; a <= 180; a++) {
    if (objectFade[a] > 0 && objectDistances[a] < 30) {
      // Red beam with decaying alpha opacity
      stroke(255, 10, 10, objectFade[a]); 
      
      float pixsDistance = objectDistances[a] * ((height - height * 0.1666) * 0.025);
      float maxArcDistance = (height - height * 0.12);
      
      // Extended line stretching from target distance out to the outer radar boundary
      line(pixsDistance * cos(radians(a)), -pixsDistance * sin(radians(a)),
           maxArcDistance * cos(radians(a)), -maxArcDistance * sin(radians(a)));
      
      // Decay opacity rate (lower value = longer trail persistence for video)
      objectFade[a] -= 2; 
    }
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(6);
  stroke(30, 250, 60); // Green sweep line
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.064, width, height);
  fill(98, 245, 31);
  textSize(20);
  
  // Distance scale labels
  text("10cm", width - width * 0.385, height - height * 0.083);
  text("20cm", width - width * 0.28, height - height * 0.083);
  text("30cm", width - width * 0.177, height - height * 0.083);
  text("40cm", width - width * 0.072, height - height * 0.083);
  
  // Telemetry readouts
  text("Angle: " + iAngle + "°", width * 0.05, height - height * 0.027);
  text("Distance: " + (iDistance < 40 ? iDistance + " cm" : "Out of Range"), width * 0.2, height - height * 0.027);
  
  if (iDistance < 30) {
    fill(255, 0, 0);
    text("TARGET DETECTED AT " + iAngle + "° (" + iDistance + " cm)", width * 0.45, height - height * 0.027);
  }
  popMatrix();
}
