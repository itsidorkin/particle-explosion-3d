import processing.core.PApplet;
import processing.core.PVector;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;

import peasy.*;


public class MainClass extends PApplet {
    public static MainClass processing;

    public static void main(String[] args) {
        PApplet.main("MainClass", args);
    }

    ArrayList<particle> particle = new ArrayList<>();
    PeasyCam camera;
    int displaySize = 800;

    ArrayList<Float> getDiv(int num){
        ArrayList<Float> div = new ArrayList<>();
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
        processing = this;
        size(displaySize, displaySize, P3D);
    }

    public void setup() {
        hint(DISABLE_DEPTH_TEST);
        camera = new PeasyCam(this, 0, 0, 0, 1.75 * displaySize);
        camera.setSuppressRollRotationMode();
        camera.setResetOnDoubleClick(false);
        colorMode(HSB);
        burst(displaySize);
    }
float m=1;
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
        //translate(width / 2F, height / 2F, displaySize/2F);
        stroke(255, 255 * 0.1F);
        strokeWeight(1);
        box(displaySize);

//        sphere(displaySize/2F); // Выписанная
//        sphere(displaySize*sqrt(3)/2F); // Описанная
        popMatrix();
// ----------------------------------------------------------------------------------------------------
if (key =='5'){
    m+=0.01;
}
        if (key =='6'){
            m-=0.01;
        }

        for (int i = particle.size() - 1; i >= 0; i--) {
           particle.get(i).update();
            if (particle.get(i).dead) {
                particle.remove(i);
                continue;
            }

            pushMatrix();
            //translate(width/2, height/2, displaySize/2);
            scale(m,m ,m);

            particle.get(i).display();
            popMatrix();
        }
    }
float a,b;
    void burst(int displaySize) {
        println(getDiv(displaySize));
        float stp = 100; // warning displaySize % stp == 0
        for (float x = -width/2; x <= width/2; x += stp) {
            for (float y = -width/2; y <= height/2; y += stp) {
                for (float z = -width/2; z <= displaySize/2; z += stp)  {
                        a = atan2(y , x);
                        b = atan2(z , x);

//                if (x<width/2) {
//                    a = a - PI;
//                    b = b - PI;
//                }
                    //a = map(a, 0, PI, -PI, PI);
                    //b = map(b, 0, PI, -PI, PI);
                    //println(a, b);
                    //line();
//                    PVector q = new PVector(x,y,z);
//                    float r = q.dist()
//                    a = PVector.angleBetween(new PVector(x,0), new PVector(0,y));
//                    b = PVector.angleBetween(new PVector(y,0), new PVector(0,z));

                    particle.add(new particle(x, y, z, a, b));
                }
            }
        }
    }

    class particle {
        ArrayList<PVector> old = new ArrayList<>();
        PVector location;
        // int size = 8;
        byte option1 = 1;
        byte option2 = 1;
        int speed = 4;
        float a, b;
        boolean dead = false;

        particle(float x, float y, float z, float a, float b) {
            location = new PVector(x, y, z);
            this.a = a;
            this.b = b;
        }

        void update() {
//            println(
//                    degrees(atan2(location.y - height / 2F, location.x - width / 2F)),
//                    degrees(atan2(location.z - displaySize/2, location.x - width / 2F))
//            );

//            float alpha = degrees(atan2(location.y - height / 2F, location.x - width / 2F));
//            float beta = degrees(atan2(location.z - displaySize/2, location.x - width / 2F));


           // a = atan2( location.y, location.x);
            //b = atan2(location.z, location.x );
            location.add(new PVector(
                    cos(a) * cos(b) * speed,
                    sin(a) * cos(b) * speed,
                    sin(b) * speed
            ));

            if (location.x <= -4*width || location.x >= 4*width ||
                   location.y <= -4*height ||location.y >= 4*height ||
                    location.z <= -4*displaySize || location.z >= 4*displaySize) {
                dead = true;
            }

        }
        void display() {
            switch (key) {
                case '1' -> option1 = 1;
                case '2' -> option1 = 2;
                case '3' -> option2 = 1;
                case '4' -> option2 = 2;
            }

            float distance = dist(width / 2F, height / 2F, displaySize/2F, location.x, location.y, location.z);
            switch (option1) {
                case (1) -> {
                    float colour = map(distance, 0, displaySize / 2F, 0, 255);
//                    stroke(colour, 255, 255, 255 * 0.5F);
//                    strokeWeight(map(colour, 0, 255, 8, 4));
                    stroke(255);
                    strokeWeight(2);

//                    strokeWeight(size);
                }
                case (2) -> {
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
                }
            }
            switch (option2) {
                case (1) -> point(location.x, location.y, location.z);
                case (2) -> {
                    if (distance <= displaySize / 2F) {

                        point(location.x, location.y, location.z);
                    }
                }
            }
        }
    }
}
