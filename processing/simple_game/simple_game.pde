public void settings() {
  size(600, 600);
}

Im im;
ArrayList<Bullets> bullets = new ArrayList<Bullets>();
ArrayList<Enemy> enemy = new ArrayList<Enemy>();
int time1, time2, time3;
int interval1 = 1000;
int interval2 = 1000;
int interval3 = 200;
int score = 0;
boolean over = false;

public void gameOver() {
  over = true;
  im.fill = 0;
  for (int i = enemy.size() - 1; i >= 0; i--) {
    enemy.get(i).speed = 0;
  }
  for (int i = bullets.size() - 1; i >= 0; i--) {
    bullets.get(i).vel = new PVector(0, 0);
  }

  textAlign(CENTER);
  textSize(50);
  fill(0);
  text("Game Over", width / 2, height / 2);
  textSize(18);
  text("mR to restart", width / 2, height / 2 + 30);
}

public void gameStart() {
  over = false;
  score = 0;
  bullets.clear();
  enemy.clear();
  im.pos = new PVector(width / 2, height / 2);
}

public void setup() {
  //smooth();
  im = new Im(new PVector(width / 2, height / 2));
  enemy.add(new Enemy(new PVector(width / 2, height / 2), 0));
  time1 = millis();
  time2 = millis();
  time3 = millis();
}

public void draw() {
  background(255 * 0.75F);

  textAlign(RIGHT, TOP);
  fill(0);
  textSize(12);
  text("fps: " + round(frameRate), width - 2, 2);

  textAlign(RIGHT, BOTTOM);
  fill(255);
  textSize(24);
  text("mL", width - 100, height - 50);
  text("mR", width - 50, height - 50);


  //textAlign(LEFT, BOTTOM);
  textAlign(CENTER, BOTTOM);
  text("w", 75, height - 75);
  text("a", 50, height - 50);
  text("s", 75, height - 50);
  text("d", 100, height - 50);

  textAlign(LEFT, TOP);
  text("Enemy: " + enemy.size(), 50, 75);
  text("Score: " + String.format("%04d", score), 50, 50);
  //text("Bullets: " + bullets.size(), 50, 100);
  //text("Interval: " + interval1, 50, 125);

  im.move();
  im.display();

  boolean dlta = false;
  for (int i = enemy.size() - 1; i >= 0; i--) {
    enemy.get(i).move();
    if (enemy.get(i).dead) {
      score += 1;
      enemy.remove(i);
      continue;
    }
    enemy.get(i).display();
    boolean hit1 = enemy.get(i).polyCircle(im.vert);
    dlta |= hit1;
  }
  if (dlta) {
    gameOver();
  } else {
    im.fill = 255;
  }

  for (int i = bullets.size() - 1; i >= 0; i--) {
    bullets.get(i).move();
    bullets.get(i).checkCollision(enemy);
    if (bullets.get(i).dead) {
      bullets.remove(i);
      continue;
    }
    bullets.get(i).display();
  }

  if (mousePressed & !over) {
    if (mouseButton == LEFT & millis() > time3 + interval3) {
      fill(0);
      textAlign(RIGHT, BOTTOM);
      text("mL", width - 100, height - 50);
      bullets.add(new Bullets(new PVector(im.pos.x, im.pos.y), atan2(mouseY - im.pos.y, mouseX - im.pos.x)));
      time3 = millis();
    }

    //            if (mouseButton == RIGHT) {
    //                enemy.add(new Enemy(new PVector(width / 2, height / 2), random(2 * PI)));
    //            }
  }

  if (millis() > time1 + interval1 & !over) {
    enemy.add(new Enemy(new PVector(width / 2, height / 2), random(2 * PI)));
    time1 = millis();
  }
  if (millis() > time2 + interval2 & !over) {
    interval1 = constrain(interval1 -= 25, 300, 2000);
    time2 = millis();
  }
}

public void mousePressed() {
  fill(0);
  textAlign(RIGHT, BOTTOM);
  textSize(24);
  if (mouseButton == LEFT & !over) {
    time3 = millis();
    bullets.add(new Bullets(new PVector(im.pos.x, im.pos.y), atan2(mouseY - im.pos.y, mouseX - im.pos.x)));
    text("mL", width - 100, height - 50);
  }
  //        if (mouseButton == RIGHT) {
  //            enemy.add(new Enemy(new PVector(width / 2, height / 2), random(2 * PI)));
  //             text("mR", width - 50, height - 50);
  //        }
  if (mouseButton == RIGHT & over) {
    text("mR", width - 50, height - 50);
    gameStart();
  }
}

class Bullets {
  PVector pos;
  PVector vel;
  float speed = 10;
  float ang;
  int rad = 5;
  boolean dead = false;

  Bullets(PVector pos, float ang) {

    this.pos = pos;
    this.ang = ang;
    vel = new PVector(
      cos(ang), 
      sin(ang)
      ).mult(speed);
  }

  void checkCollision(ArrayList<Enemy> enemy) {
    for (int i = enemy.size() - 1; i >= 0; i--) {
      float distanceVect = PVector.sub(pos, enemy.get(i).pos).mag();
      float minDistance = rad / 2 + enemy.get(i).size / 2;
      if (distanceVect <= minDistance) {
        enemy.get(i).dead = true;
        dead = true;
        break;
      }
    }
  }

  void move() {

    //            if (pos.x <= 0 || pos.x >= width) {
    //                vel.x *= -1;
    //            }
    //            if (pos.y <= 0 || pos.y >= height) {
    //                vel.y *= -1;
    //            }
    pos.add(vel);
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      dead = true;
    }
  }

  void display() {
    fill(255);
    ellipse(pos.x, pos.y, rad, rad);
  }
}

public void keyPressed() {
  if (key == 'w' || key == 'ц') im.up = true;
  if (key == 'a' || key == 'ф') im.left = true;
  if (key == 's' || key == 'ы') im.down = true;
  if (key == 'd' || key == 'в') im.right = true;
}

public void keyReleased() {
  if (key == 'w' || key == 'ц') im.up = false;
  if (key == 'a' || key == 'ф') im.left = false;
  if (key == 's' || key == 'ы') im.down = false;
  if (key == 'd' || key == 'в') im.right = false;
}

class Im {
  PVector pos;
  float ang;
  boolean dead = false;
  boolean up, down, left, right;
  int rad = 20;
  int fill = 255;
  int speed = 3;
  PVector[] vert = new PVector[3];

  Im(PVector pos) {
    this.pos = pos;
  }

  void move() {
    fill(0);
    textAlign(CENTER, BOTTOM);
    if (!over) {
      if (up) {
        pos.y -= speed;
        text("w", 75, height - 75);
      }
      if (left) {
        pos.x -= speed;
        text("a", 50, height - 50);
      }
      if (down) {
        pos.y += speed;
        text("s", 75, height - 50);
      }
      if (right) {
        pos.x += speed;
        text("d", 100, height - 50);
      }
    }


    if (pos.x < -rad) pos.x = width + rad;
    if (pos.x > width + rad) pos.x = -rad;
    if (pos.y < -rad) pos.y = height + rad;
    if (pos.y > height + rad) pos.y = -rad;

    if (!over) {
      ang = atan2(mouseY - pos.y, mouseX - pos.x);
    }
  }

  void my_triangle(PVector pos0, float rad, float fi) {
    float angl = 0;
    for (int i = 0; i < 3; i++) {
      vert[i] = new PVector(
        rad * cos(fi + angl) + pos0.x, 
        rad * sin(fi + angl) + pos0.y
        );
      angl += 2 * PI / 3;
    }
    triangle(vert[0].x, vert[0].y, vert[1].x, vert[1].y, vert[2].x, vert[2].y);
  }

  void display() {
    fill(fill);
    my_triangle(pos, rad, ang);
  }
}

class Enemy {
  PVector pos0;
  PVector pos;
  PVector vel;
  float ang;
  boolean dead = false;
  int size = 20;
  float rad = width/2*sqrt(2);
  //float speed = PI / 90;
  float speed = 1;

  Enemy(PVector pos0, float ang) {
    this.pos0 = pos0;
    this.ang = ang;
    pos = new PVector(
      pos0.x + cos(ang) * rad, 
      pos0.y + sin(ang) * rad
      );
  }

  void move() {
    //ang = (ang + speed) % (PI * 2)
    pos.sub(new PVector(
      cos(atan2(pos.y - im.pos.y, pos.x - im.pos.x)), 
      sin(atan2(pos.y - im.pos.y, pos.x - im.pos.x))
      ).mult(speed));

    //            if (pos.x < -rad) pos.x = width + rad;
    //            if (pos.x > width + rad) pos.x = -rad;
    //            if (pos.y < -rad) pos.y = height + rad;
    //            if (pos.y > height + rad) pos.y = -rad;
  }

  boolean polyCircle(PVector[] vertices) {
    int next;
    for (int current = 0; current < vertices.length; current++) {
      next = current + 1;
      if (next == vertices.length) next = 0;
      PVector vc = vertices[current];
      PVector vn = vertices[next];
      boolean collision = lineCircle(vc, vn, pos, size / 2);
      if (collision) return true;
    }
    //return polygonPoint(vertices,enemy);
    return false;
  }

  //    boolean polygonPoint(PVector[] vertices) {
  //        boolean collision = false;
  //        int next;
  //        for (int current = 0; current < vertices.length; current++) {
  //            next = current + 1;
  //            if (next == vertices.length) next = 0;
  //            PVector vc = vertices[current];    // c for "current"
  //            PVector vn = vertices[next];       // n for "next"
  //            if (((vc.y > pos.y && vn.y < pos.y) || (vc.y < pos.y && vn.y > pos.y)) &&
  //                    (pos.x < (vn.x - vc.x) * (pos.y - vc.y) / (vn.y - vc.y) + vc.x)) {
  //                collision = !collision;
  //            }
  //        }
  //        return collision;
  //    }

  boolean lineCircle(PVector vc, PVector vn, PVector c, float r) {
    boolean inside1 = vc.dist(c) <= r;
    boolean inside2 = vn.dist(c) <= r;
    if (inside1 || inside2) return true;
    float len = vc.dist(vn);
    float dot = PVector.sub(c, vc).dot(PVector.sub(vn, vc)) / pow(len, 2);
    PVector closest = PVector.sub(vn, vc).mult(dot).add(vc);
    boolean onSegment = linePoint(vc, vn, closest);
    if (!onSegment) return false;
    return closest.dist(c) <= r;
  }

  boolean linePoint(PVector vc, PVector vn, PVector closest) {
    float d1 = closest.dist(vc);
    float d2 = closest.dist(vn);
    float lineLen = vc.dist(vn);
    float buffer = 0.2F;
    return d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer;
  }

  void display() {
    fill(255);
    ellipse(pos.x, pos.y, size, size);
  }
}
