/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-06
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: HealthPotion.pde
 * Description: An interactable health potion that restores
 *              a portion of the player's health when picked up
 */

class HealthPotion extends Interactable {
  private int healAmount;

  /**
   * Constructor: public HealthPotion()
   *  Parameters: int healAmount - The amount of health to restore
   * Description: Constructs a health potion for use when
   *              randomly generating a new room
   */

  public HealthPotion(int healAmount) {
    this.healAmount = healAmount;
  }

  /**
   * Constructor: public HealthPotion()
   *  Parameters: JSONObject object - A JSON serialization of the potion
   * Description: Constructs a health potion from JSON save data
   */

  public HealthPotion(JSONObject object) {
    this.healAmount = object.getInt("healAmount");
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the health potion to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "HealthPotion");
    object.setInt("healAmount", this.healAmount);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the health potion as a green bottle
   *              with a white cross, centered in the current
   *              tile assuming the scene has translated to
   *              the tile's top-left corner and passed the
   *              tile size via the graphics matrix
   */

  public void draw() {
    // Determine tile size from the scene's coordinate space
    float size = min((float) width / 12, (float) height / 12);

    // Bottle body (green)
    fill(34, 197, 94);
    noStroke();
    rectMode(CENTER);
    rect(size / 2, size * 0.55, size * 0.4, size * 0.45, size * 0.06);

    // Bottle neck (darker green)
    fill(22, 163, 74);
    rect(size / 2, size * 0.28, size * 0.18, size * 0.2, size * 0.04);

    // Bottle cap (brown cork)
    fill(161, 98, 7);
    rect(size / 2, size * 0.17, size * 0.22, size * 0.08, size * 0.03);

    // White cross on the bottle body
    fill(255);
    rect(size / 2, size * 0.55, size * 0.2, size * 0.06);
    rect(size / 2, size * 0.55, size * 0.06, size * 0.2);

    rectMode(CORNER);
  }

  /**
   *      Method: public interact()
   *  Parameters: Player player - The player interacting with the potion
   *      Return: boolean - Whether or not the interaction succeeded
   * Description: Heals the player by the potion's heal amount
   *              and removes the potion from the room
   */

  public boolean interact(Player player) {
    player.updateHealth(this.healAmount);
    return true;
  }

  /**
   *      Method: public getHealAmount()
   *  Parameters: void
   *      Return: int - The amount of health the potion restores
   * Description: Returns the heal amount of the potion
   */

  public int getHealAmount() {
    return this.healAmount;
  }
}
