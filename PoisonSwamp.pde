/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-09
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: PoisonSwamp.pde
 * Description: An interactable poison swamp tile that
 *              damages the player when they walk over it
 */

class PoisonSwamp extends Interactable {
  private int damageAmount;

  /**
   * Constructor: public PoisonSwamp()
   *  Parameters: int damageAmount - The amount of damage dealt
   * Description: Constructs a poison swamp for use when
   *              randomly generating a new room
   */

  public PoisonSwamp(int damageAmount) {
    this.damageAmount = damageAmount;
  }

  /**
   * Constructor: public PoisonSwamp()
   *  Parameters: JSONObject object - A JSON serialization of the swamp
   * Description: Constructs a poison swamp from JSON save data
   */

  public PoisonSwamp(JSONObject object) {
    this.damageAmount = object.getInt("damageAmount");
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the poison swamp to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "PoisonSwamp");
    object.setInt("damageAmount", this.damageAmount);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the poison swamp as a bubbling purple
   *              puddle with toxic bubble effects
   */

  public void draw() {
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    float cy = size * 0.55;

    // Swamp puddle (dark purple, irregular shape)
    noStroke();
    fill(88, 28, 135, 180);
    ellipse(cx, cy, size * 0.7, size * 0.45);

    // Inner toxic glow
    fill(147, 51, 234, 120);
    ellipse(cx - size * 0.05, cy, size * 0.5, size * 0.3);

    // Toxic bubbles
    fill(192, 132, 252, 200);
    ellipse(cx - size * 0.12, cy - size * 0.06, size * 0.09, size * 0.09);
    ellipse(cx + size * 0.15, cy + size * 0.02, size * 0.07, size * 0.07);
    ellipse(cx + size * 0.05, cy - size * 0.1, size * 0.05, size * 0.05);
  }

  /**
   *      Method: public interact()
   *  Parameters: Player player - The player interacting with the swamp
   *      Return: boolean - Whether or not the interaction succeeded
   * Description: Damages the player by the swamp's damage amount;
   *              returns true so the player still moves onto the tile
   */

  public boolean interact(Player player) {
    player.updateHealth(-this.damageAmount);
    return true;
  }

  /**
   *      Method: public getDamageAmount()
   *  Parameters: void
   *      Return: int - The amount of damage the swamp deals
   * Description: Returns the damage amount of the swamp
   */

  public int getDamageAmount() {
    return this.damageAmount;
  }
}
