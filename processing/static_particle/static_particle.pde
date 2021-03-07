import peasy.*;
import java.math.BigDecimal;
import java.math.RoundingMode;

ArrayList<particle> particle = new ArrayList<particle>();
PeasyCam camera;
int displaySize = 800;

ArrayList<Float> getDiv(int num) {
  ArrayList<Float> div = new ArrayList<Float>();
  float step = 0.01F;
  float counter = 1;
  while (counter <= num) {
    if (num % counter == 0) {
      div.add(counter);
    }
    counter = Float.parseFloat(String.valueOf(new BigDecimal(counter + step).setScale(2, RoundingMode.HALF_EVEN)));
  }
  return div;
}

public void settings() {
  size(displaySize, displaySize, P3D);
}

public void setup() {
  hint(DISABLE_DEPTH_TEST);
  camera = new PeasyCam(this, width / 2F, height / 2F, displaySize / 2F, 1.75 * displaySize);
  camera.setSuppressRollRotationMode();
  camera.setResetOnDoubleClick(false);
  colorMode(HSB);
  burst(displaySize);
}

public void draw() {
  background(0);
  //----------------------------------------------------------------------------------------------------
  stroke(255, 255 * 0.2F);
  strokeWeight(2);
  //        line(0, height / 2F, 0, width, height / 2F, 0);
  //        line(width / 2F, 0, 0, width / 2F, height, 0);
  //        line(width / 2F, height / 2F, -displaySize / 2F, width / 2F, height / 2F, displaySize / 2F);
  pushMatrix();
  noFill();
  translate(width / 2F, height / 2F, displaySize/2F);
  stroke(255, 255 * 0.1F);
  box(displaySize);
  //        sphere(displaySize/2F); // Выписанная
  //        sphere(displaySize*sqrt(3)/2F); // Описанная
  popMatrix();
  // ----------------------------------------------------------------------------------------------------

  for (int i = particle.size() - 1; i >= 0; i--) {
    particle.get(i).display();
  }
}

void burst(int displaySize) {
  println(getDiv(displaySize));
  float stp = 32; // warning displaySize % stp == 0
  for (float i = 0; i <= width; i += stp) {
    for (float j = 0; j <= height; j += stp) {
      for (float k = 0; k <= displaySize; k += stp) {
        particle.add(new particle(i, j, k));
      }
    }
  }
}

class particle {
  ArrayList<PVector> old = new ArrayList<PVector>();
  PVector location;
  // int size = 8;
  byte option1 = 1;
  byte option2 = 1;

  particle(float x, float y, float z) {
    location = new PVector(x, y, z);
  }

  void display() {
    switch (key) {
    case '1': 
      option1 = 1;
      break;
    case '2': 
      option1 = 2;
      break;
    case '3': 
      option2 = 1;
      break;
    case '4': 
      option2 = 2;
      break;
    }

    float distance = dist(width / 2F, height / 2F, displaySize/2F, location.x, location.y, location.z);
    switch (option1) {
      case (1): 
      float colour = map(distance, 0, displaySize / 2F, 0, 255);
      stroke(colour, 255, 255, 255 * 0.5F);
      strokeWeight(map(colour, 0, 255, 8, 4));
      //                    strokeWeight(size);
      break;
      case (2): 
      float part = 255;
      float r_quad = displaySize / 2F / part;
      for (float i = 0; i <= part; i++) {
        if (-r_quad * i <= location.x - width / 2F & location.x - width / 2F <= r_quad * i &
          -r_quad * i <= location.y - height / 2F & location.y - height / 2F <= r_quad * i &
          -r_quad * i <= location.z - displaySize / 2F & location.z - displaySize / 2F <= r_quad * i) {
          stroke(map(i, 0, part, 0, 255), 255, 255, 255 * 0.5F);
          strokeWeight(map(i, 0, part, 6, 2));
          //                            strokeWeight(size);
          break;
        }
      }
      break;
    }
    switch (option2) {
      case (1): 
      point(location.x, location.y, location.z);
      break;
      case (2): 
      if (distance <= displaySize / 2F) {
        point(location.x, location.y, location.z);
      }
      break;
    }
  }
}
