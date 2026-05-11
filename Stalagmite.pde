/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-10
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Stalagmite.pde
 * Description: An impassable stalagmite obstacle that blocks
 *              movement, drawn as a natural cave floor
 *              formation with rocky pointed spires
 */

class Stalagmite extends WorldObject {
  private int variant;

  /**
   * Constructor: public Stalagmite()
   *  Parameters: int variant - Visual variant seed
   * Description: Constructs a stalagmite for use when
   *              randomly generating a new room
   */

  public Stalagmite(int variant) {
    this.variant = variant;
  }

  /**
   * Constructor: public Stalagmite()
   *  Parameters: JSONObject object - A JSON serialization of the object
   * Description: Constructs a stalagmite from JSON save data
   */

  public Stalagmite(JSONObject object) {
    this.variant = object.getInt("variant", 0);
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the stalagmite to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "Stalagmite");
    object.setInt("variant", this.variant);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the stalagmite as pointed rocky
   *              spires growing up from the cave floor
   */

  public void draw() {
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    noStroke();

    // Rocky base mound
    fill(40, 32, 50);
    ellipse(cx, size * 0.82, size * 0.75, size * 0.22);

    if (this.variant % 2 == 0) {
      // Three spires, tallest in center
      // Left spire
      fill(55, 45, 65);
      triangle(cx - size * 0.22, size * 0.8, cx - size * 0.18, size * 0.3, cx - size * 0.1, size * 0.8);
      fill(70, 60, 80, 150);
      triangle(cx - size * 0.2, size * 0.75, cx - size * 0.17, size * 0.35, cx - size * 0.14, size * 0.65);

      // Center spire (tallest)
      fill(60, 50, 72);
      triangle(cx - size * 0.1, size * 0.8, cx, size * 0.1, cx + size * 0.1, size * 0.8);
      fill(80, 68, 92, 150);
      triangle(cx - size * 0.05, size * 0.7, cx + size * 0.02, size * 0.18, cx + size * 0.07, size * 0.6);

      // Right spire
      fill(50, 42, 62);
      triangle(cx + size * 0.1, size * 0.8, cx + size * 0.2, size * 0.25, cx + size * 0.24, size * 0.8);
      fill(65, 55, 78, 150);
      triangle(cx + size * 0.12, size * 0.72, cx + size * 0.19, size * 0.3, cx + size * 0.22, size * 0.65);
    } else {
      // Two thick spires
      // Left spire
      fill(58, 48, 68);
      quad(cx - size * 0.25, size * 0.8, cx - size * 0.12, size * 0.2, cx - size * 0.05, size * 0.22, cx - size * 0.08, size * 0.8);
      fill(75, 63, 85, 150);
      triangle(cx - size * 0.2, size * 0.7, cx - size * 0.11, size * 0.25, cx - size * 0.1, size * 0.6);

      // Right spire
      fill(52, 44, 64);
      quad(cx + size * 0.08, size * 0.8, cx + size * 0.1, size * 0.15, cx + size * 0.18, size * 0.18, cx + size * 0.25, size * 0.8);
      fill(70, 58, 82, 150);
      triangle(cx + size * 0.1, size * 0.7, cx + size * 0.12, size * 0.2, cx + size * 0.2, size * 0.6);
    }

    // Drip highlight at tip
    fill(100, 90, 115, 180);
    ellipse(cx, size * 0.14, size * 0.04, size * 0.06);
  }
}
