/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Project4.pde
 * Description: A dungeon crawler game
 */

import processing.sound.*;
import java.util.LinkedList;
import java.util.Map;

Scene scene;
String fileName;
SoundFile bgMusic;

/**
 *      Method: setup()
 *  Parameters: void
 *      Return: void
 * Description: Constructs a scene from JSON
 *              save data or in a random state
 */

void setup() {
  size(1280,720);
  pixelDensity(1);
  fileName = sketchPath("data/save.json");
  File file = new File(fileName);

  if (file.exists()) {
    JSONObject data = loadJSONObject(fileName);
    scene = new Scene(data);
  } else {
    scene = new Scene();
    JSONObject data = scene.serialize();
    file.getParentFile().mkdirs();
    saveJSONObject(data, fileName);
  }

  bgMusic = new SoundFile(this, "Pokemon Dungeon Crawler (Nate Koenig).mp3");
  if (bgMusic != null) {
    bgMusic.loop();
  }
}

/**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Draws the scene and all objects
 *              within it, additionally performing
 *              logic for the main game loop
 */

void draw() {
  background(0);

  if (scene.tryTurn()) {
    // Save the state of the scene
    saveJSONObject(scene.serialize(), fileName);
  }

  scene.draw();
}

/**
 *      Method: keyPressed()
 *  Parameters: void
 *      Return: void
 * Description: Passes key press events to the scene
 */

void keyPressed() {
  scene.keyPressed();
}

/**
 *      Method: keyReleased()
 *  Parameters: void
 *      Return: void
 * Description: Passes key release events to the scene
 */

void keyReleased() {
  scene.keyReleased();
}
