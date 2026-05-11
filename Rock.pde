/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-10
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Rock.pde
 * Description: An impassable rock obstacle that blocks
 *              movement, drawn as a dark cave boulder
 */

class Rock extends WorldObject {
  private int variant;

  /**
   * Constructor: public Rock()
   *  Parameters: int variant - Visual variant seed
   * Description: Constructs a rock for use when randomly
   *              generating a new room
   */

  public Rock(int variant) {
    this.variant = variant;
  }

  /**
   * Constructor: public Rock()
   *  Parameters: JSONObject object - A JSON serialization of the rock
   * Description: Constructs a rock from JSON save data
   */

  public Rock(JSONObject object) {
    this.variant = object.getInt("variant", 0);
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the rock to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "Rock");
    object.setInt("variant", this.variant);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the rock as a rough dark boulder
   *              that fills the tile. Variant controls
   *              whether it is a single large rock or
   *              a cluster of smaller stones.
   */

  public void draw() {
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    float cy = size / 2;
    noStroke();

    if (this.variant % 2 == 0) {
      // Large single boulder
      // Shadow
      fill(25, 20, 35);
      ellipse(cx + size * 0.03, cy + size * 0.04, size * 0.82, size * 0.72);

      // Main body
      fill(55, 50, 65);
      ellipse(cx, cy, size * 0.8, size * 0.7);

      // Cracks
      stroke(40, 35, 50);
      strokeWeight(1.5);
      line(cx - size * 0.15, cy - size * 0.1, cx + size * 0.05, cy + size * 0.15);
      line(cx + size * 0.05, cy + size * 0.15, cx + size * 0.2, cy + size * 0.05);
      noStroke();

      // Highlight
      fill(75, 70, 85, 150);
      ellipse(cx - size * 0.12, cy - size * 0.12, size * 0.2, size * 0.15);
    } else {
      // Rock cluster (3 smaller stones)
      // Stone 1 (back, largest)
      fill(25, 20, 35);
      ellipse(cx + size * 0.05, cy - size * 0.06, size * 0.52, size * 0.44);
      fill(60, 55, 70);
      ellipse(cx + size * 0.03, cy - size * 0.08, size * 0.5, size * 0.42);

      // Stone 2 (left)
      fill(25, 20, 35);
      ellipse(cx - size * 0.16, cy + size * 0.16, size * 0.4, size * 0.34);
      fill(50, 45, 60);
      ellipse(cx - size * 0.18, cy + size * 0.14, size * 0.38, size * 0.32);

      // Stone 3 (right front)
      fill(25, 20, 35);
      ellipse(cx + size * 0.18, cy + size * 0.18, size * 0.38, size * 0.32);
      fill(65, 60, 75);
      ellipse(cx + size * 0.16, cy + size * 0.16, size * 0.36, size * 0.3);

      // Highlights
      fill(80, 75, 95, 120);
      ellipse(cx - size * 0.05, cy - size * 0.15, size * 0.1, size * 0.08);
      ellipse(cx + size * 0.1, cy + size * 0.1, size * 0.08, size * 0.06);
    }
  }
}
