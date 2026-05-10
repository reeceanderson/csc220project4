/**
 *      Author: Prof. Morales, Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Scene.pde
 * Description: The game scene that handles each room
 *              and all objects within those rooms,
 *              including the player and enemies
 */

import java.util.LinkedList;
import java.util.Map;

class Scene {
  private int roomWidth;
  private int roomHeight;
  private WorldObject[][] room;
  private Direction entry;
  private Player player;
  private LinkedList<Actor> enemies;
  private HashMap<WorldObject, Position> positions;
  private HashMap<Direction, Position> doors;
  private int roomsCleared;
  private boolean dead;

  /**
   * Constructor: public Scene()
   *  Parameters: void
   * Description: Constructs a scene with a randomly
   *              generated room and a new player
   */

  public Scene() {
    this.roomWidth = int(random(7, 11));
    this.roomHeight = int(random(7, 11));
    this.room = new WorldObject[this.roomWidth][this.roomHeight];
    this.enemies = new LinkedList<Actor>();
    this.positions = new HashMap<WorldObject, Position>();
    this.doors = new HashMap<Direction, Position>();
    this.roomsCleared = 0;
    this.dead = false;
    this.player = new Player(Direction.NORTH);
    this.reset(Direction.NORTH);
  }

  /**
   * Constructor: public Scene()
   *  Parameters: JSONObject object - A JSON serialization of the scene
   * Description: Constructs a scene from JSON save data
   */

  public Scene(JSONObject object) {
    this.roomWidth = object.getInt("roomWidth");
    this.roomHeight = object.getInt("roomHeight");
    this.entry = Direction.valueOf(object.getString("entry"));
    this.room = new WorldObject[this.roomWidth][this.roomHeight];
    this.enemies = new LinkedList<Actor>();
    this.positions = new HashMap<WorldObject, Position>();
    this.doors = new HashMap<Direction, Position>();
    this.roomsCleared = object.getInt("roomsCleared", 0);
    this.dead = false;

    // Load the player
    JSONObject playerObj = object.getJSONObject("player");
    this.player = new Player(playerObj);
    int px = object.getInt("playerX");
    int py = object.getInt("playerY");
    this.room[px][py] = this.player;
    this.positions.put(this.player, new Position(px, py, this));

    // Load doors
    JSONArray doorsArr = object.getJSONArray("doors");

    for (int i = 0; i < doorsArr.size(); i++) {
      JSONObject doorObj = doorsArr.getJSONObject(i);
      Direction dir = Direction.valueOf(doorObj.getString("direction"));
      this.doors.put(dir, new Position(doorObj.getInt("x"), doorObj.getInt("y"), this));
    }

    // Load room objects
    JSONArray objects = object.getJSONArray("objects");

    for (int i = 0; i < objects.size(); i++) {
      JSONObject obj = objects.getJSONObject(i);
      String className = obj.getString("className");
      int ox = obj.getInt("x");
      int oy = obj.getInt("y");
      WorldObject worldObj = null;

     if (className.equals("Berry")) {
  worldObj = new Berry(obj);
} else if (className.equals("PoisonSwamp")) {
  worldObj = new PoisonSwamp(obj);
} else if (className.equals("Enemy")) {
  worldObj = new Enemy(obj);
}

      if (worldObj != null) {
        this.room[ox][oy] = worldObj;
        this.positions.put(worldObj, new Position(ox, oy, this));

        if (worldObj instanceof Actor) {
          this.enemies.add((Actor) worldObj);
        }
      }
    }

    this.updateActions(this.player);
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the scene
   * Description: Serializes the entire scene state to JSON,
   *              including the room dimensions, player, doors,
   *              and all objects in the room
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setInt("roomWidth", this.roomWidth);
    object.setInt("roomHeight", this.roomHeight);
    object.setString("entry", this.entry.name());
    object.setInt("roomsCleared", this.roomsCleared);

    // Serialize the player and their position
    object.setJSONObject("player", this.player.serialize());
    Position playerPos = this.positions.get(this.player);
    object.setInt("playerX", playerPos.getX());
    object.setInt("playerY", playerPos.getY());

    // Serialize doors
    JSONArray doorsArr = new JSONArray();

    for (Map.Entry<Direction, Position> doorEntry : this.doors.entrySet()) {
      JSONObject doorObj = new JSONObject();
      doorObj.setString("direction", doorEntry.getKey().name());
      doorObj.setInt("x", doorEntry.getValue().getX());
      doorObj.setInt("y", doorEntry.getValue().getY());
      doorsArr.append(doorObj);
    }

    object.setJSONArray("doors", doorsArr);

    // Serialize all room objects except the player
    JSONArray objects = new JSONArray();

    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        if (this.room[x][y] != null && this.room[x][y] != this.player) {
          JSONObject obj = this.room[x][y].serialize();
          obj.setInt("x", x);
          obj.setInt("y", y);
          objects.append(obj);
        }
      }
    }

    object.setJSONArray("objects", objects);
    return object;
  }

  /**
   *      Method: private reset()
   *  Parameters: Direction entry - The direction from which
   *                                the player entered the room
   *      Return: void
   * Description: Resets the room to a random state, placing
   *              the player at the entry door and randomly
   *              generating interactables, obstacles, and enemies
   */

  private void reset(Direction entry) {
    if (entry == null) {
      return;
    }

    // Store entry direction and regenerate room dimensions
    this.entry = entry;
    this.roomsCleared++;
    this.roomWidth = int(random(7, 11));
    this.roomHeight = int(random(7, 11));
    this.room = new WorldObject[this.roomWidth][this.roomHeight];
    this.enemies.clear();
    this.positions.clear();
    this.doors.clear();

    // Difficulty scaling based on depth
    float depthScale = 1.0 + (this.roomsCleared - 1) * 0.15;

    // Check if the player should evolve
    this.player.tryEvolve(this.roomsCleared);

    // Determine the player's starting position based on entry direction
    // Entry is the direction the player was facing when entering,
    // so they come through the opposite wall (entry.inverse() side)
    int playerX = this.roomWidth / 2;
    int playerY = this.roomHeight / 2;
    Direction entryWall = entry.inverse();

    switch (entryWall) {
    case NORTH:
      playerX = this.roomWidth / 2;
      playerY = 0;
      break;

    case SOUTH:
      playerX = this.roomWidth / 2;
      playerY = this.roomHeight - 1;
      break;

    case EAST:
      playerX = this.roomWidth - 1;
      playerY = this.roomHeight / 2;
      break;

    case WEST:
      playerX = 0;
      playerY = this.roomHeight / 2;
      break;
    }

    // Place the player at the entry position
    this.room[playerX][playerY] = this.player;
    this.player.facing = entry;
    this.positions.put(this.player, new Position(playerX, playerY, this));

    // Place exit doors on walls other than the entry wall
    for (Direction dir : Direction.values()) {
      if (dir == entryWall) {
        continue;
      }

      int doorX = 0;
      int doorY = 0;

      switch (dir) {
      case NORTH:
        doorX = int(random(1, this.roomWidth - 1));
        doorY = 0;
        break;

      case SOUTH:
        doorX = int(random(1, this.roomWidth - 1));
        doorY = this.roomHeight - 1;
        break;

      case EAST:
        doorX = this.roomWidth - 1;
        doorY = int(random(1, this.roomHeight - 1));
        break;

      case WEST:
        doorX = 0;
        doorY = int(random(1, this.roomHeight - 1));
        break;
      }

      // Avoid placing a door on top of the player
      if (doorX != playerX || doorY != playerY) {
        this.doors.put(dir, new Position(doorX, doorY, this));
      }
    }

    // --- BERRY SPAWNING ---
    // Generous early (3-4 strong berries), scarce late (1 weak berry)
    int numBerries;
    int minHeal, maxHeal;

    if (this.roomsCleared <= 3) {
      numBerries = int(random(3, 5));
      minHeal = 25;
      maxHeal = 40;
    } else if (this.roomsCleared <= 7) {
      numBerries = int(random(2, 4));
      minHeal = max(10, int(20 / depthScale));
      maxHeal = max(15, int(30 / depthScale));
    } else {
      numBerries = int(random(1, 3));
      minHeal = max(5, int(15 / depthScale));
      maxHeal = max(8, int(20 / depthScale));
    }

    for (int i = 0; i < numBerries; i++) {
      int x = int(random(this.roomWidth));
      int y = int(random(this.roomHeight));

      if (this.room[x][y] == null) {
        Berry berry = new Berry(int(random(minHeal, maxHeal + 1)));
        this.room[x][y] = berry;
        this.positions.put(berry, new Position(x, y, this));
      }
    }

    // --- SWAMP SPAWNING ---
    // None on floor 1, ramps up after that
    int numSwamps = 0;

    if (this.roomsCleared == 1) {
      numSwamps = 0;
    } else if (this.roomsCleared <= 3) {
      numSwamps = int(random(0, 2));
    } else {
      numSwamps = int(random(1, 3)) + this.roomsCleared / 4;
    }

    for (int i = 0; i < numSwamps; i++) {
      int x = int(random(this.roomWidth));
      int y = int(random(this.roomHeight));

      if (this.room[x][y] == null) {
        int swampDmg = int(random(5, 16) * depthScale);
        PoisonSwamp swamp = new PoisonSwamp(swampDmg);
        this.room[x][y] = swamp;
        this.positions.put(swamp, new Position(x, y, this));
      }
    }

    // TODO: Randomly place obstacles
    // int numObstacles = int(random(3, 7));
    // for (int i = 0; i < numObstacles; i++) {
    //   int x = int(random(this.roomWidth));
    //   int y = int(random(this.roomHeight));
    //   if (this.room[x][y] == null) {
    //     YourObstacle obs = new YourObstacle();
    //     this.room[x][y] = obs;
    //     this.positions.put(obs, new Position(x, y, this));
    //   }
    // }

    // --- ENEMY SPAWNING ---
    // Floor 1: 1 weak normal-type enemy to learn controls
    // Floor 2-3: 1-2 enemies, grass-biased (easy for fire player)
    // Floor 4-6: 2-3 enemies, mixed types
    // Floor 7+: 3+ enemies, all types, stats scale hard
    int numEnemies;
    int baseHealth, baseDamage;

    if (this.roomsCleared <= 1) {
      numEnemies = 1;
      baseHealth = 30;
      baseDamage = 5;
    } else if (this.roomsCleared <= 3) {
      numEnemies = int(random(1, 3));
      baseHealth = 40;
      baseDamage = 6;
    } else if (this.roomsCleared <= 6) {
      numEnemies = int(random(2, 4));
      baseHealth = 50;
      baseDamage = 8;
    } else {
      numEnemies = int(random(3, 5)) + (this.roomsCleared - 7) / 2;
      baseHealth = 50;
      baseDamage = 8;
    }

    for (int i = 0; i < numEnemies; i++) {
      int x = int(random(this.roomWidth));
      int y = int(random(this.roomHeight));

      if (this.room[x][y] == null) {
        Direction dir = Direction.values()[int(random(4))];

        // Pick enemy type based on floor difficulty
        CreatureType type;

        if (this.roomsCleared <= 1) {
          // Floor 1: only normal types (no type advantage against player)
          type = CreatureType.NORMAL;
        } else if (this.roomsCleared <= 3) {
          // Floor 2-3: mostly grass (weak to fire player) with some normal
          float roll = random(1);
          type = (roll < 0.6) ? CreatureType.GRASS : CreatureType.NORMAL;
        } else if (this.roomsCleared <= 6) {
          // Floor 4-6: mix of all types, water still rare
          float roll = random(1);
          if (roll < 0.35) type = CreatureType.GRASS;
          else if (roll < 0.6) type = CreatureType.NORMAL;
          else if (roll < 0.8) type = CreatureType.FIRE;
          else type = CreatureType.WATER;
        } else {
          // Floor 7+: fully random, water becomes common
          type = CreatureType.values()[int(random(CreatureType.values().length))];
        }

        int enemyHealth = int(baseHealth * depthScale);
        int enemyDamage = int(baseDamage * depthScale);
        Enemy enemy = new Enemy(enemyHealth, enemyDamage, dir, type);
        this.room[x][y] = enemy;
        this.enemies.add(enemy);
        this.positions.put(enemy, new Position(x, y, this));
      }
    }

    this.updateActions(this.player);
  }

  /**
   *      Method: private updateActions()
   *  Parameters: Actor actor - The actor whose actions will be
   *                            updated to reflect their validity
   *      Return: void
   * Description: Updates an actor's list of valid actions
   */

  private void updateActions(Actor actor) {
    for (Action action : Action.values()) {
      actor.setActionValidity(action, this.isActionValid(actor, action));
    }
  }

  /**
   *      Method: public tryTurn()
   *  Parameters: void
   *      Return: boolean - Whether or not the state of
   *                        the scene should be saved
   * Description: Tries to execute a single turn of game
   *              logic for the player and all enemies
   */

  public boolean tryTurn() {
    // If on the death screen, do nothing until respawn
    if (this.dead) {
      return false;
    }

    // If the player is dead, show the death screen
    if (this.player == null || this.player.getHealth() == 0) {
      this.dead = true;
      return true;
    }

    // Get the player's action
    Action action = this.player.getAction();

    // If no action was chosen, do nothing
    if (action == null) {
      return false;
    }

    // If the player attacked or entered a new room, save the game
    Position door = this.doors.get(action.direction);
    boolean save = action.isAttack || door != null && door.equals(this.positions.get(this.player)) && this.enemies.size() == 0;

    // If the action failed, do nothing
    if (!this.tryAction(this.player, action)) {
      return false;
    }

    for (int i = 0; i < this.enemies.size(); ++i) {
      Actor enemy = this.enemies.get(i);

      // Remove dead enemies
      if (enemy.getHealth() == 0) {
        this.enemies.remove(i--);
        continue;
      }

      // Get the enemy's action
      this.updateActions(enemy);
      action = enemy.getAction();

      if (this.tryAction(enemy, action) && action.isAttack) {
        // If the player died, show the death screen
        if (player.getHealth() == 0) {
          this.dead = true;
          return true;
        }

        // If the enemy attacked, save the game
        save = true;
      }
    }

    this.updateActions(this.player);
    return save;
  }

  /**
   *      Method: private tryAction()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action succeeded
   * Description: Tries to execute an action on behalf of an actor
   */

  private boolean tryAction(Actor actor, Action action) {
    if (!isActionValid(actor, action)) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position doorPos = this.doors.get(action.direction);

      if (doorPos != null && doorPos.equals(position)) {
        this.reset(action.direction);
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      boolean isActionValid = this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);

      if (isActionValid) {
        Actor target = (Actor) this.room[x][y];

        if (target.getHealth() > 0) {
          target.updateHealth(-actor.getDamageAgainst(target));
        } else {
          this.room[x][y] = null;
        }
      }

      return isActionValid;
    }

    // Check if the actor can interact with an interactable object
    if (actor == this.player && this.room[x][y] instanceof Interactable) {
      Interactable interactable = (Interactable) this.room[x][y];

      if (!interactable.interact(this.player)) {
        return false;
      }
    } else if (this.room[x][y] != null) {
      return false;
    }

    // Move the actor
    this.room[x][y] = actor;
    this.room[position.getX()][position.getY()] = null;
    position.move(action.direction);
    return true;
  }

  /**
   *      Method: private isActionValid()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action is valid
   * Description: Determines if an actor's action would be valid
   */

  private boolean isActionValid(Actor actor, Action action) {
    if (actor == null || action == null || actor.getHealth() == 0) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position doorPos = this.doors.get(action.direction);

      if (doorPos != null && doorPos.equals(position)) {
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      return this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);
    }

    // Check if the actor can move
    return this.room[x][y] == null || this.room[x][y] instanceof Interactable && actor == this.player;
  }

  /**
   *      Method: public getRoomWidth()
   *  Parameters: void
   *      Return: int - The width of the room, in number of columns
   * Description: Returns the width of the room
   */

  public int getRoomWidth() {
    return roomWidth;
  }

  /**
   *      Method: public getRoomHeight()
   *  Parameters: void
   *      Return: int - The height of the room, in number of rows
   * Description: Returns the height of the room
   */

  public int getRoomHeight() {
    return roomHeight;
  }

  /**
   *      Method: public getRoomsCleared()
   *  Parameters: void
   *      Return: int - The number of rooms the player has cleared
   * Description: Returns the current room depth
   */

  public int getRoomsCleared() {
    return roomsCleared;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Passes key press events to the player
   */

  public void keyPressed() {
    if (this.dead) {
      // Respawn on any key press
      Direction[] directions = Direction.values();
      Direction direction = directions[int(random(directions.length))];
      this.player = new Player(direction);
      this.roomsCleared = 0;
      this.dead = false;
      this.reset(direction);
      return;
    }

    if (this.player != null) {
      this.player.keyPressed();
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Passes key release events to the player
   */

  public void keyReleased() {
    if (this.player != null) {
      this.player.keyReleased();
    }
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the scene, including the room floor,
   *              walls, doors, and all objects within the room
   */

  public void draw() {
    // Determine the tile size and offset to center the room
    float size = min((float) width / (this.roomWidth + 2), (float) height / (this.roomHeight + 2));
    float offsetX = (width - this.roomWidth * size) / 2;
    float offsetY = (height - this.roomHeight * size) / 2;

    // Draw the room floor tiles with a cave-themed checkerboard
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        float tileX = offsetX + x * size;
        float tileY = offsetY + y * size;

        if ((x + y) % 2 == 0) {
          fill(35, 30, 55);
        } else {
          fill(28, 24, 48);
        }

        stroke(22, 18, 40);
        strokeWeight(1);
        rect(tileX, tileY, size, size);
      }
    }

    // Draw cave walls around the room
    fill(55, 40, 80);
    noStroke();
    rect(offsetX - size, offsetY - size, (this.roomWidth + 2) * size, size);
    rect(offsetX - size, offsetY + this.roomHeight * size, (this.roomWidth + 2) * size, size);
    rect(offsetX - size, offsetY, size, this.roomHeight * size);
    rect(offsetX + this.roomWidth * size, offsetY, size, this.roomHeight * size);

    // Draw doors as colored openings in the walls
    for (Map.Entry<Direction, Position> doorEntry : this.doors.entrySet()) {
      Direction dir = doorEntry.getKey();
      Position doorPos = doorEntry.getValue();
      float doorX = 0;
      float doorY = 0;

      switch (dir) {
      case NORTH:
        doorX = offsetX + doorPos.getX() * size;
        doorY = offsetY - size;
        break;

      case SOUTH:
        doorX = offsetX + doorPos.getX() * size;
        doorY = offsetY + this.roomHeight * size;
        break;

      case EAST:
        doorX = offsetX + this.roomWidth * size;
        doorY = offsetY + doorPos.getY() * size;
        break;

      case WEST:
        doorX = offsetX - size;
        doorY = offsetY + doorPos.getY() * size;
        break;
      }

      // Green doors when all enemies are defeated, red when locked
      if (this.enemies.size() == 0) {
        fill(34, 197, 94);
      } else {
        fill(180, 60, 60);
      }

      rect(doorX, doorY, size, size);
    }

    // Draw all objects in the room
    for (int x = 0; x < this.roomWidth; x++) {
      for (int y = 0; y < this.roomHeight; y++) {
        if (this.room[x][y] != null) {
          float tileX = offsetX + x * size;
          float tileY = offsetY + y * size;

          pushMatrix();
          translate(tileX, tileY);
          this.room[x][y].draw();
          popMatrix();
        }
      }
    }

    // Draw floor HUD in the top-left corner
    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    String[] stageNames = {"", "Charmander", "Charmeleon", "Charizard"};
    String stageName = stageNames[this.player.getEvolutionStage()];
    text("Floor: " + this.roomsCleared + "  |  " + stageName + " (Stage " + this.player.getEvolutionStage() + ")", 10, 10);

    // Draw inventory HUD in the top-right corner
    int berryCount = this.player.getInventorySize();
    textAlign(RIGHT, TOP);
    fill(59, 130, 246);
    text("Berries: " + berryCount + "  [E] to use", width - 10, 10);

    // Draw blackout screen overlay
    if (this.dead) {
      // Semi-transparent dark overlay
      fill(0, 0, 0, 200);
      rectMode(CORNER);
      rect(0, 0, width, height);

      // "You blacked out!" text
      fill(251, 146, 60);
      textAlign(CENTER, CENTER);
      textSize(52);
      text("You blacked out!", width / 2, height / 2 - 40);

      // Floor count and evolution reached
      fill(200);
      textSize(24);
      String[] deathNames = {"", "Charmander", "Charmeleon", "Charizard"};
      text("Reached floor " + this.roomsCleared + " as " + deathNames[this.player.getEvolutionStage()], width / 2, height / 2 + 30);

      // Continue prompt
      fill(255);
      textSize(18);
      text("Press any key to return to the entrance", width / 2, height / 2 + 80);
    }
  }
}
