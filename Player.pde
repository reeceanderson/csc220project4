/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Player.pde
 * Description: A user-controlled player actor
 */

class Player extends Actor {
  private char nextKey;
  private HashMap<Character, Boolean> debounce;
  private int evolutionStage;
  private PImage[] sprites;

  // Charmander(4) -> Charmeleon(5) -> Charizard(6)
  private final int[] EVOLUTION_IDS = { 4, 5, 6 };

  /**
   * Constructor: public Player()
   *  Parameters: Direction direction - The direction to face
   * Description: Constructs a player in a new room and loads
   *              Pokemon sprites for all three evolution stages
   *              from the PokeAPI sprite repository
   */

  public Player(Direction direction) {
    super(100, 10, direction, CreatureType.FIRE);
    this.nextKey = '\0';
    this.debounce = new HashMap<Character, Boolean>();
    this.evolutionStage = 1;
    this.loadAllSprites();
  }

  /**
   * Constructor: public Player()
   *  Parameters: JSONObject object - A JSON serialization of the player
   * Description: Constructs a player from JSON save data and
   *              reloads the Pokemon sprites
   */

  public Player(JSONObject object) {
    super(object);
    this.nextKey = '\0';
    this.debounce = new HashMap<Character, Boolean>();
    this.evolutionStage = object.getInt("evolutionStage", 1);
    this.loadAllSprites();
  }

  /**
   *      Method: private loadAllSprites()
   *  Parameters: void
   *      Return: void
   * Description: Loads Pokemon sprites for all three evolution
   *              stages from the PokeAPI GitHub sprite repository.
   *              Requires an active internet connection.
   */

  private void loadAllSprites() {
    this.sprites = new PImage[3];

    for (int i = 0; i < 3; i++) {
      String url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" + EVOLUTION_IDS[i] + ".png";
      this.sprites[i] = loadImage(url);
    }
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */

  public JSONObject serialize() {
    JSONObject object = super.serialize();
    object.setString("className", "Player");
    object.setInt("evolutionStage", this.evolutionStage);
    return object;
  }

  /**
   *      Method: public getEvolutionStage()
   *  Parameters: void
   *      Return: int - The current evolution stage (1, 2, or 3)
   * Description: Returns the player's evolution stage
   */

  public int getEvolutionStage() {
    return this.evolutionStage;
  }

  /**
   *      Method: public tryEvolve()
   *  Parameters: int floor - The current floor number
   *      Return: boolean - Whether the player evolved
   * Description: Checks if the player should evolve based
   *              on the floor number. Stage 2 at floor 5,
   *              stage 3 at floor 10. Boosts stats and
   *              fully heals the player on evolution.
   */

  public boolean tryEvolve(int floor) {
    if (this.evolutionStage == 1 && floor >= 5) {
      this.evolutionStage = 2;
      this.boostStats(50, 5);
      return true;
    }

    if (this.evolutionStage == 2 && floor >= 10) {
      this.evolutionStage = 3;
      this.boostStats(75, 8);
      return true;
    }

    return false;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the player using the Pokemon sprite
   *              for the current evolution stage (Charmander,
   *              Charmeleon, or Charizard). Falls back to
   *              hand-drawn shapes if sprites failed to load.
   *              Always draws the flame direction indicator.
   */

  public void draw() {
    super.draw();
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    float cy = size / 2;

    int idx = this.evolutionStage - 1;
    PImage currentSprite = (idx >= 0 && idx < this.sprites.length) ? this.sprites[idx] : null;

    if (currentSprite != null) {
      // Draw the Pokemon sprite scaled to the tile
      float padding = size * 0.1;
      imageMode(CORNER);
      image(currentSprite, padding, padding, size - padding * 2, size - padding * 2);
    } else {
      // Fallback to shape drawing if sprite didn't load
      switch (this.evolutionStage) {
      case 1:
        this.drawStage1(size, cx, cy);
        break;

      case 2:
        this.drawStage2(size, cx, cy);
        break;

      case 3:
        this.drawStage3(size, cx, cy);
        break;
      }
    }

    // Always draw flame direction indicator on top
    this.drawFlame(size, cx, cy);
  }

  /**
   *      Method: private drawStage1()
   *  Parameters: float size - The tile size
   *              float cx   - The center X of the tile
   *              float cy   - The center Y of the tile
   *      Return: void
   * Description: Draws the stage 1 creature, a small
   *              red creature with a tan belly and eyes
   */

  private void drawStage1(float size, float cx, float cy) {
    float r = size * 0.28;
    noStroke();

    // Body
    fill(239, 68, 68);
    ellipse(cx, cy, r * 2.2, r * 2.0);

    // Belly
    fill(251, 191, 146);
    ellipse(cx, cy + r * 0.15, r * 1.2, r * 1.1);

    // Eyes
    this.drawEyes(cx, cy, r);
  }

  /**
   *      Method: private drawStage2()
   *  Parameters: float size - The tile size
   *              float cx   - The center X of the tile
   *              float cy   - The center Y of the tile
   *      Return: void
   * Description: Draws the stage 2 creature, larger and
   *              darker red with two horns on top
   */

  private void drawStage2(float size, float cx, float cy) {
    float r = size * 0.33;
    noStroke();

    // Horns
    fill(200, 50, 50);
    triangle(cx - r * 0.5, cy - r * 0.7, cx - r * 0.3, cy - r * 1.4, cx - r * 0.1, cy - r * 0.7);
    triangle(cx + r * 0.5, cy - r * 0.7, cx + r * 0.3, cy - r * 1.4, cx + r * 0.1, cy - r * 0.7);

    // Body (darker red, bigger)
    fill(220, 50, 50);
    ellipse(cx, cy, r * 2.3, r * 2.1);

    // Belly
    fill(251, 180, 130);
    ellipse(cx, cy + r * 0.12, r * 1.3, r * 1.1);

    // Eyes (slightly more angular)
    this.drawEyes(cx, cy, r);

    // Brow ridges
    stroke(180, 30, 30);
    strokeWeight(2);
    line(cx - r * 0.5, cy - r * 0.4, cx - r * 0.15, cy - r * 0.3);
    line(cx + r * 0.5, cy - r * 0.4, cx + r * 0.15, cy - r * 0.3);
    noStroke();
  }

  /**
   *      Method: private drawStage3()
   *  Parameters: float size - The tile size
   *              float cx   - The center X of the tile
   *              float cy   - The center Y of the tile
   *      Return: void
   * Description: Draws the stage 3 creature, the largest
   *              form with a deep crimson body, sharp horns,
   *              and small wings on the sides
   */

  private void drawStage3(float size, float cx, float cy) {
    float r = size * 0.36;
    noStroke();

    // Wings (behind body)
    fill(180, 30, 30, 200);
    // Left wing
    triangle(cx - r * 0.8, cy - r * 0.2, cx - r * 1.6, cy - r * 0.8, cx - r * 0.8, cy + r * 0.4);
    // Right wing
    triangle(cx + r * 0.8, cy - r * 0.2, cx + r * 1.6, cy - r * 0.8, cx + r * 0.8, cy + r * 0.4);

    // Wing inner membrane
    fill(239, 68, 68, 150);
    triangle(cx - r * 0.8, cy - r * 0.1, cx - r * 1.3, cy - r * 0.5, cx - r * 0.8, cy + r * 0.3);
    triangle(cx + r * 0.8, cy - r * 0.1, cx + r * 1.3, cy - r * 0.5, cx + r * 0.8, cy + r * 0.3);

    // Horns (larger, sharper)
    fill(160, 30, 30);
    triangle(cx - r * 0.45, cy - r * 0.65, cx - r * 0.25, cy - r * 1.5, cx - r * 0.05, cy - r * 0.65);
    triangle(cx + r * 0.45, cy - r * 0.65, cx + r * 0.25, cy - r * 1.5, cx + r * 0.05, cy - r * 0.65);

    // Body (deep crimson, largest)
    fill(190, 30, 30);
    ellipse(cx, cy, r * 2.3, r * 2.2);

    // Belly (slightly more orange)
    fill(240, 160, 100);
    ellipse(cx, cy + r * 0.1, r * 1.3, r * 1.15);

    // Chest mark (V shape)
    stroke(255, 200, 80);
    strokeWeight(2);
    line(cx - r * 0.3, cy - r * 0.15, cx, cy + r * 0.15);
    line(cx + r * 0.3, cy - r * 0.15, cx, cy + r * 0.15);
    noStroke();

    // Eyes (more intense)
    this.drawEyes(cx, cy, r);
  }

  /**
   *      Method: private drawEyes()
   *  Parameters: float cx - The center X of the creature
   *              float cy - The center Y of the creature
   *              float r  - The body radius
   *      Return: void
   * Description: Draws the creature's eyes with white
   *              sclera and dark pupils
   */

  private void drawEyes(float cx, float cy, float r) {
    float eyeOffX = r * 0.35;
    float eyeY = cy - r * 0.2;
    noStroke();
    fill(255);
    ellipse(cx - eyeOffX, eyeY, r * 0.5, r * 0.55);
    ellipse(cx + eyeOffX, eyeY, r * 0.5, r * 0.55);
    fill(20);
    ellipse(cx - eyeOffX, eyeY, r * 0.22, r * 0.28);
    ellipse(cx + eyeOffX, eyeY, r * 0.22, r * 0.28);
  }

  /**
   *      Method: private drawFlame()
   *  Parameters: float size - The tile size
   *              float cx   - The center X of the tile
   *              float cy   - The center Y of the tile
   *      Return: void
   * Description: Draws a flame in the facing direction as
   *              a direction indicator, scaled by stage
   */

  private void drawFlame(float size, float cx, float cy) {
    float r = size * (0.28 + (this.evolutionStage - 1) * 0.04);
    float flameLen = size * (0.18 + (this.evolutionStage - 1) * 0.04);

    noStroke();
    fill(251, 146, 60);

    switch (this.facing) {
    case NORTH:
      triangle(cx, cy - r - flameLen * 1.4, cx - flameLen * 0.5, cy - r + flameLen * 0.2, cx + flameLen * 0.5, cy - r + flameLen * 0.2);
      fill(255, 220, 80);
      triangle(cx, cy - r - flameLen * 0.8, cx - flameLen * 0.25, cy - r + flameLen * 0.1, cx + flameLen * 0.25, cy - r + flameLen * 0.1);
      break;

    case SOUTH:
      triangle(cx, cy + r + flameLen * 1.4, cx - flameLen * 0.5, cy + r - flameLen * 0.2, cx + flameLen * 0.5, cy + r - flameLen * 0.2);
      fill(255, 220, 80);
      triangle(cx, cy + r + flameLen * 0.8, cx - flameLen * 0.25, cy + r - flameLen * 0.1, cx + flameLen * 0.25, cy + r - flameLen * 0.1);
      break;

    case EAST:
      triangle(cx + r + flameLen * 1.4, cy, cx + r - flameLen * 0.2, cy - flameLen * 0.5, cx + r - flameLen * 0.2, cy + flameLen * 0.5);
      fill(255, 220, 80);
      triangle(cx + r + flameLen * 0.8, cy, cx + r - flameLen * 0.1, cy - flameLen * 0.25, cx + r - flameLen * 0.1, cy + flameLen * 0.25);
      break;

    case WEST:
      triangle(cx - r - flameLen * 1.4, cy, cx - r + flameLen * 0.2, cy - flameLen * 0.5, cx - r + flameLen * 0.2, cy + flameLen * 0.5);
      fill(255, 220, 80);
      triangle(cx - r - flameLen * 0.8, cy, cx - r + flameLen * 0.1, cy - flameLen * 0.25, cx - r + flameLen * 0.1, cy + flameLen * 0.25);
      break;
    }
  }

  /**
   *      Method: public getAction()
   *  Parameters: void
   *      Return: Action - The selected action to perform
   * Description: Selects an action to perform
   */

  public Action getAction() {
    char currKey = this.nextKey;
    this.nextKey = '\0';
    Action action = null;

    // Convert key to action
    switch (currKey) {
    case 'W':
      this.facing = Direction.NORTH;
      action = Action.MOVE_NORTH;
      break;

    case 'S':
      this.facing = Direction.SOUTH;
      action = Action.MOVE_SOUTH;
      break;

    case 'D':
      this.facing = Direction.EAST;
      action = Action.MOVE_EAST;
      break;

    case 'A':
      this.facing = Direction.WEST;
      action = Action.MOVE_WEST;
      break;

    case ' ':
      switch (this.facing) {
      case NORTH:
        action = Action.ATTACK_NORTH;
        break;

      case SOUTH:
        action = Action.ATTACK_SOUTH;
        break;

      case EAST:
        action = Action.ATTACK_EAST;
        break;

      case WEST:
        action = Action.ATTACK_WEST;
        break;
      }

      break;
    }

    // Check if the action can be performed
    return this.getActionValidity(action) ? action : null;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Handles key release events with debouncing
   */

  public void keyPressed() {
    // Convert to uppercase
    char pressed = Character.toUpperCase(key);

    if ("WASD ".indexOf(pressed) != -1 && !debounce.getOrDefault(pressed, false)) {
      debounce.put(pressed, true);
      nextKey = pressed;
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Handles key release events with debouncing
   */

  public void keyReleased() {
    // Convert to uppercase
    char released = Character.toUpperCase(key);

    if (debounce.getOrDefault(released, false)) {
      debounce.put(released, false);
    }
  }
}
