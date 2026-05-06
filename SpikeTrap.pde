/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-06
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: SpikeTrap.pde
 * Description: An interactable spike trap that damages the
 *              player when they walk over it
 */

class SpikeTrap extends Interactable {
  private int damageAmount;

  /**
   * Constructor: public SpikeTrap()
   *  Parameters: int damageAmount - The amount of damage dealt to the player
   * Description: Constructs a spike trap for use when
   *              randomly generating a new room
   */

  public SpikeTrap(int damageAmount) {
    this.damageAmount = damageAmount;
  }

  /**
   * Constructor: public SpikeTrap()
   *  Parameters: JSONObject object - A JSON serialization of the trap
   * Description: Constructs a spike trap from JSON save data
   */

  public SpikeTrap(JSONObject object) {
    this.damageAmount = object.getInt("damageAmount");
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the spike trap to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "SpikeTrap");
    object.setInt("damageAmount", this.damageAmount);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the spike trap as a set of upward-pointing
   *              triangular spikes on a dark base plate, centered
   *              in the current tile
   */

  public void draw() {
    // Determine tile size from the scene's coordinate space
    float size = min((float) width / 12, (float) height / 12);

    // Base plate (dark gray)
    fill(64, 64, 64);
    noStroke();
    rectMode(CENTER);
    rect(size / 2, size * 0.7, size * 0.7, size * 0.12, size * 0.03);

    // Draw three spikes (metallic gray)
    fill(180, 180, 190);
    stroke(100);
    strokeWeight(1);

    // Left spike
    triangle(
      size * 0.22, size * 0.65,
      size * 0.32, size * 0.65,
      size * 0.27, size * 0.3
    );

    // Center spike (tallest)
    triangle(
      size * 0.40, size * 0.65,
      size * 0.60, size * 0.65,
      size * 0.50, size * 0.2
    );

    // Right spike
    triangle(
      size * 0.68, size * 0.65,
      size * 0.78, size * 0.65,
      size * 0.73, size * 0.3
    );

    noStroke();
    rectMode(CORNER);
  }

  /**
   *      Method: public interact()
   *  Parameters: Player player - The player interacting with the trap
   *      Return: boolean - Whether or not the interaction succeeded
   * Description: Damages the player by the trap's damage amount;
   *              always returns true so the player still moves
   *              onto the tile after triggering the trap
   */

  public boolean interact(Player player) {
    player.updateHealth(-this.damageAmount);
    return true;
  }

  /**
   *      Method: public getDamageAmount()
   *  Parameters: void
   *      Return: int - The amount of damage the trap deals
   * Description: Returns the damage amount of the trap
   */

  public int getDamageAmount() {
    return this.damageAmount;
  }
}
