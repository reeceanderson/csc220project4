/**
 *      Author: Nate Koenig
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-01
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Enemy.pde
 * Description: A CPU-controlled enemy actor (Pokemon) that
 *              pursues and attacks the player. Each enemy is
 *              assigned a random Pokemon sprite from PokeAPI.
 *              The sprite is loaded from a URL, so an internet
 *              connection is required at runtime!!
 */

class Enemy extends Actor {
  private PImage sprite;
  private int pokemonId;

  private int stuckCounter;
  private Direction lastAttempted;

  /**
   * Constructor: public Enemy()
   *  Parameters: int          health - Starting (and max) health
   *              int          damage - Base damage per attack
   *              Direction    facing - Initial facing direction
   *              CreatureType type   - Elemental type of this enemy
   * Description: Constructs a new Enemy and loads a random
   *              Pokemon sprite from the PokeAPI sprite repo
   */
  public Enemy(int health, int damage, Direction facing, CreatureType type) {
    super(health, damage, facing, type);
    this.stuckCounter = 0;
    this.lastAttempted = null;
    this.pokemonId = pickPokemonId(type);
    this.sprite = loadSprite(this.pokemonId);
  }

  /**
   * Constructor: public Enemy()
   *  Parameters: JSONObject object - Saved JSON data for this enemy
   * Description: Reconstructs an Enemy from a save file,
   *              reloading the same Pokemon sprite it had before
   */
  public Enemy(JSONObject object) {
    super(object);
    this.stuckCounter = 0;
    this.lastAttempted = null;
    this.pokemonId = object.getInt("pokemonId", int(random(1, 152)));
    this.sprite = loadSprite(this.pokemonId);
  }

  /**
   *      Method: private pickPokemonId()
   *  Parameters: CreatureType type - The enemy's elemental type
   *      Return: int - A Pokemon ID (1-151, original 151 only)
   * Description: Picks a random Pokemon ID from a curated pool
   *              that matches the enemy's elemental type.
   *              Falls back to a fully random ID if NORMAL type.
   *
   *              ID reference (Gen 1):
   *                FIRE  - Charmander(4), Charmeleon(5),
   *                        Charizard(6), Vulpix(37), Ninetales(38),
   *                        Growlithe(58), Arcanine(59), Ponyta(77),
   *                        Rapidash(78), Magmar(126), Flareon(136),
   *                        Moltres(146)
   *                WATER - Squirtle(7), Wartortle(8), Blastoise(9),
   *                        Psyduck(54), Golduck(55), Poliwag(60),
   *                        Tentacool(72), Slowpoke(79), Seel(86),
   *                        Shellder(90), Horsea(116), Goldeen(118),
   *                        Lapras(131), Vaporeon(134), Omanyte(138),
   *                        Kabuto(140), Gyarados(130)
   *                GRASS - Bulbasaur(1), Ivysaur(2), Venusaur(3),
   *                        Oddish(43), Gloom(44), Vileplume(45),
   *                        Bellsprout(69), Weepinbell(70),
   *                        Victreebel(71), Exeggcute(102),
   *                        Tangela(114), Leafeon(470 - Gen4, skip)
   *                NORMAL - anything 1-151
   */
  private int pickPokemonId(CreatureType type) {
    int[] firePool = { 4, 5, 6, 37, 38, 58, 59, 77, 78, 126, 136, 146 };
    int[] waterPool = { 7, 8, 9, 54, 55, 60, 72, 79, 86, 90, 116, 118, 130, 131, 134, 138, 140 };
    int[] grassPool = { 1, 2, 3, 43, 44, 45, 69, 70, 71, 102, 114 };

    switch (type) {
    case FIRE:
      return firePool[int(random(firePool.length))];

    case WATER:
      return waterPool[int(random(waterPool.length))];

    case GRASS:
      return grassPool[int(random(grassPool.length))];

    default: 
      return int(random(1, 152));
    }
  }

  /**
   *      Method: private loadSprite()
   *  Parameters: int id - The Pokemon's National Dex number
   *      Return: PImage - The loaded sprite, or null on failure
   * Description: Downloads the front-facing sprite PNG from the
   *              PokeAPI GitHub sprite repository. Requires an
   *              active internet connection. If the load fails
   *              (offline / bad ID) the game falls back to the
   *              placeholder shape drawing in draw().
   */
  private PImage loadSprite(int id) {
    String url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" + id + ".png";
    PImage img = loadImage(url);
    return img;
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - JSON representation of this enemy
   * Description: Calls the Actor serializer, tags the class name,
   *              and saves the pokemonId so the same sprite is
   *              restored when loading a save file
   */
  public JSONObject serialize() {
    JSONObject object = super.serialize();
    object.setString("className", "Enemy");
    object.setInt("pokemonId", this.pokemonId);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the enemy inside the current tile.
   *              Calls super.draw() for the health bar.
   *              If the sprite loaded successfully, draws it
   *              scaled to fill the tile. Otherwise falls back
   *              to a type-colored placeholder shape.
   *              Always draws the directional arrow on top.
   */
  public void draw() {
    super.draw();

    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    float cy = size / 2;
    float r = size * 0.30;

    if (this.sprite != null) {
      float padding = size * 0.12;
      imageMode(CORNER);
      image(this.sprite, padding, padding, size - padding * 2, size - padding * 2);
    } else {
      int[] primary = this.getCreatureType().getColor();
      int[] accent = this.getCreatureType().getAccent();

      noStroke();
      fill(primary[0], primary[1], primary[2], 80);
      ellipse(cx, cy, r * 2.6, r * 2.6);
      fill(primary[0], primary[1], primary[2]);
      ellipse(cx, cy, r * 2.0, r * 2.0);
      fill(accent[0], accent[1], accent[2]);
      ellipse(cx, cy + r * 0.15, r * 1.1, r * 1.0);

      float eyeOff = r * 0.32;
      float eyeY = cy - r * 0.22;
      fill(255);
      ellipse(cx - eyeOff, eyeY, r * 0.42, r * 0.48);
      ellipse(cx + eyeOff, eyeY, r * 0.42, r * 0.48);
      fill(20);
      ellipse(cx - eyeOff, eyeY, r * 0.20, r * 0.24);
      ellipse(cx + eyeOff, eyeY, r * 0.20, r * 0.24);
    }

    this.drawDirectionArrow(cx, cy, r);
  }

  /**
   *      Method: private drawDirectionArrow()
   *  Parameters: float cx - Tile centre X
   *              float cy - Tile centre Y
   *              float r  - Body radius
   *      Return: void
   * Description: Draws a bright yellow triangle pointing in
   *              the direction the enemy is currently facing
   */
  private void drawDirectionArrow(float cx, float cy, float r) {
    float tip = r * 0.50;
    float base = r * 0.28;

    fill(255, 220, 40);
    noStroke();

    switch (this.facing) {
    case NORTH:
      triangle(cx, cy - r - tip, cx - base, cy - r + base * 0.5, cx + base, cy - r + base * 0.5);
      break;

    case SOUTH:
      triangle(cx, cy + r + tip, cx - base, cy + r - base * 0.5, cx + base, cy + r - base * 0.5);
      break;

    case EAST:
      triangle(cx + r + tip, cy, cx + r - base * 0.5, cy - base, cx + r - base * 0.5, cy + base);
      break;

    case WEST:
      triangle(cx - r - tip, cy, cx - r + base * 0.5, cy - base, cx - r + base * 0.5, cy + base);
      break;
    }
  }

  /**
   *      Method: public getAction()
   *  Parameters: void
   *      Return: Action - The action the enemy will perform
   * Description: 1. Attack if any adjacent attack is valid.
   *              2. Otherwise move using a ranked direction list.
   *              3. Stuck counter shuffles directions after 2
   *                 blocked turns to escape dead-ends.
   */
  public Action getAction() {
    Action attack = this.bestAttack();
    if (attack != null) {
      this.facing = attack.direction;
      this.stuckCounter = 0;
      this.lastAttempted = null;
      return attack;
    }

    Direction[] preferred = this.buildMoveOrder();

    if (this.stuckCounter >= 2) {
      preferred = shuffled(preferred);
      this.stuckCounter = 0;
    }

    for (Direction dir : preferred) {
      Action move = moveAction(dir);
      if (move != null && this.getActionValidity(move)) {
        if (dir.equals(this.lastAttempted)) {
          this.stuckCounter++;
        } else {
          this.stuckCounter = 0;
          this.lastAttempted = dir;
        }
        this.facing = dir;
        return move;
      }
    }

    this.stuckCounter++;
    return null;
  }

  private Action bestAttack() {
    Action facingAttack = attackAction(this.facing);
    if (facingAttack != null && this.getActionValidity(facingAttack)) {
      return facingAttack;
    }
    for (Direction dir : Direction.values()) {
      if (dir == this.facing) continue;
      Action a = attackAction(dir);
      if (a != null && this.getActionValidity(a)) return a;
    }
    return null;
  }

  private Direction[] buildMoveOrder() {
    boolean canN = this.getActionValidity(Action.MOVE_NORTH);
    boolean canS = this.getActionValidity(Action.MOVE_SOUTH);
    boolean canE = this.getActionValidity(Action.MOVE_EAST);
    boolean canW = this.getActionValidity(Action.MOVE_WEST);

    boolean verticalOpen = canN || canS;
    boolean horizontalOpen = canE || canW;
    boolean swapAxes = (random(1) < 0.25);

    Direction primary, secondary, tertiary, quaternary;

    if ((!swapAxes && verticalOpen) || (swapAxes && !horizontalOpen)) { //don't think we went over the ternary operator in class but I learned it in 136 and 242. 
      primary = canN ? Direction.NORTH : Direction.SOUTH;
      secondary = canS ? Direction.SOUTH : Direction.NORTH;
      tertiary = canE ? Direction.EAST : Direction.WEST;
      quaternary = canW ? Direction.WEST : Direction.EAST;
    } else {
      primary = canE ? Direction.EAST : Direction.WEST;
      secondary = canW ? Direction.WEST : Direction.EAST;
      tertiary = canN ? Direction.NORTH : Direction.SOUTH;
      quaternary = canS ? Direction.SOUTH : Direction.NORTH;
    }

    return new Direction[]{ primary, secondary, tertiary, quaternary };
  }

  private Direction[] shuffled(Direction[] dirs) {
    Direction[] copy = dirs.clone();
    for (int i = copy.length - 1; i > 0; i--) {
      int j = int(random(i + 1));
      Direction tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    return copy;
  }

  private Action moveAction(Direction dir) {
    switch (dir) {
    case NORTH: return Action.MOVE_NORTH;
    case SOUTH: return Action.MOVE_SOUTH;
    case EAST: return Action.MOVE_EAST;
    case WEST: return Action.MOVE_WEST;
    default: return null;
    }
  }

  private Action attackAction(Direction dir) {
    switch (dir) {
    case NORTH: return Action.ATTACK_NORTH;
    case SOUTH: return Action.ATTACK_SOUTH;
    case EAST: return Action.ATTACK_EAST;
    case WEST: return Action.ATTACK_WEST;
    default: return null;
    }
  }
}
