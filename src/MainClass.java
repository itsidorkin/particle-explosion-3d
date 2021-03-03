import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

import peasy.*;


public class MainClass extends PApplet {
    public static MainClass processing;

    public static void main(String[] args) {
        PApplet.main("MainClass", args);
    }

    ArrayList<particle> particle = new ArrayList<>();
    PeasyCam camera;
    int count_particle = 100;
    int angle_step = 1;
    int displaySize = 800;

    public void settings() {
        processing = this;
        size(displaySize, displaySize, P3D);
    }

    public void setup() {
        hint(DISABLE_DEPTH_TEST);
        camera = new PeasyCam(this, width / 2, height / 2, 0, 1.73 * displaySize);
        camera.setSuppressRollRotationMode();
        camera.setResetOnDoubleClick(false);
        colorMode(HSB);
        burst(count_particle);
    }

    public void draw() {
        background(0);
        stroke(255, 255 * 0.1F);
        strokeWeight(2);

        line(0, height / 2, 0, width, height / 2, 0);
        line(width / 2, 0, 0, width / 2, height, 0);
        line(width / 2, height / 2, -displaySize / 2, width / 2, height / 2, displaySize / 2);

        pushMatrix();
        fill(255, 255 * 0.1F);
        translate(width / 2, height / 2);
        box(displaySize);
        popMatrix();

        for (int i = particle.size() - 1; i >= 0; i--) {
            particle.get(i).update();
            if (particle.get(i).dead) {
                particle.remove(i);
                continue;
            }
            particle.get(i).display();
        }
    }

    void burst(int count_particle) {
        for (int i = 0; i < count_particle; i++) {
            float angleAlpha = (int) random(360 / angle_step) * PI * angle_step / 180;
            float angleBeta = (int) random(360 / angle_step) * PI * angle_step / 180;
            particle.add(new particle(width / 2, height / 2, 0, angleAlpha, angleBeta));
        }
    }


    public void mouseReleased() {
        burst(count_particle);
    }

    class particle {
        ArrayList<PVector> old = new ArrayList<>();
        PVector location;
        float alpha, beta;
        float speed = 4;
        float rotation_chance = 0.05F;
        int size = 4;
        int tail = 8;
        int quality = 1;
        boolean dead = false;

        particle(float x, float y, float z, float alpha, float beta) {
            location = new PVector(x, y, z);
            this.alpha = alpha;
            this.beta = beta;
        }

        void update() {
            if (random(1) > 1 - rotation_chance) alpha += random(1) > 0.5 ? PI / 4 : -PI / 4;
            if (random(1) > 1 - rotation_chance) beta += random(1) > 0.5 ? PI / 4 : -PI / 4;

            old.add(new PVector(location.x, location.y, location.z));
            while (old.size() > tail) old.remove(0);

            location.add(new PVector(
                    cos(alpha) * cos(beta) * speed,
                    sin(alpha) * cos(beta) * speed,
                    sin(beta) * speed
            ));

            if (old.get(0).x < 0 || old.get(0).x > width ||
                    old.get(0).y < 0 || old.get(0).y > height ||
                    old.get(0).z < -width / 2 || old.get(0).z > width / 2) {
                dead = true;
            }
        }

        void display() {
            float distance = dist(width / 2, height / 2, 0, location.x, location.y, location.z);
            float colour = map(distance, 0, displaySize / 2, 0, 255);
            fill(colour, 255, 255, 255 * 0.5F);
            noStroke();
            sphereDetail(quality);
            if (location.x > 0 & location.x < width &
                    location.y > 0 & location.y < height &
                    location.z > -displaySize / 2 & location.z < displaySize / 2) {
                pushMatrix();
                translate(location.x, location.y, location.z);
                sphere(size);
                popMatrix();
            }

            if (old.size() > 1) {
                for (int i = 0; i < old.size(); i++) {
                    float colour_alpha = map(i, 0, old.size() - 1, 0, 255);
                    fill(colour, 255, 255, colour_alpha);
                    if ((old.get(i).x > 0 & old.get(i).x < width) &
                            (old.get(i).y > 0 & old.get(i).y < height) &
                            (old.get(i).z > -width / 2 & old.get(i).z < width / 2)) {
                        pushMatrix();
                        translate(old.get(i).x, old.get(i).y, old.get(i).z);
                        sphere(size);
                        popMatrix();
                    }

                }
            }

        }

    }


}
