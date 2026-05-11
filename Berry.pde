/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-09
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Berry.pde
 * Description: An interactable berry that restores a portion
 *              of the player's health when picked up
 */

class Berry extends Interactable {
  private int healAmount;

  /**
   * Constructor: public Berry()
   *  Parameters: int healAmount - The amount of health to restore
   * Description: Constructs a berry for use when randomly
   *              generating a new room
   */

  public Berry(int healAmount) {
    this.healAmount = healAmount;
  }

  /**
   * Constructor: public Berry()
   *  Parameters: JSONObject object - A JSON serialization of the berry
   * Description: Constructs a berry from JSON save data
   */

  public Berry(JSONObject object) {
    this.healAmount = object.getInt("healAmount");
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the berry to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "Berry");
    object.setInt("healAmount", this.healAmount);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the berry as a round blue fruit
   *              with a small green stem on top
   */

  public void draw() {
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    float cy = size * 0.55;

    // Berry body (blue, round)
    noStroke();
    fill(59, 130, 246);
    ellipse(cx, cy, size * 0.4, size * 0.38);

    // Highlight
    fill(96, 165, 250, 150);
    ellipse(cx - size * 0.06, cy - size * 0.06, size * 0.15, size * 0.12);

    // Stem (green)
    stroke(34, 197, 94);
    strokeWeight(2);
    line(cx, cy - size * 0.18, cx + size * 0.02, cy - size * 0.28);
    noStroke();

    // Leaf
    fill(34, 197, 94);
    ellipse(cx + size * 0.06, cy - size * 0.25, size * 0.12, size * 0.06);
  }

  /**
   *      Method: public interact()
   *  Parameters: Player player - The player interacting with the berry
   *      Return: boolean - Whether or not the interaction succeeded
   * Description: Adds the berry to the player's inventory
   *              for later use instead of healing immediately
   */

  public boolean interact(Player player) {
    player.addBerry(this.healAmount);
    return true;
  }

  /**
   *      Method: public getHealAmount()
   *  Parameters: void
   *      Return: int - The amount of health the berry restores
   * Description: Returns the heal amount of the berry
   */

  public int getHealAmount() {
    return this.healAmount;
  }
}
