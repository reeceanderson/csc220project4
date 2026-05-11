/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-10
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Crystal.pde
 * Description: An impassable crystal formation obstacle
 *              that blocks movement, drawn as glowing
 *              purple/blue crystals growing from the
 *              cave floor
 */

class Crystal extends WorldObject {
  private int variant;

  /**
   * Constructor: public Crystal()
   *  Parameters: int variant - Visual variant seed
   * Description: Constructs a crystal for use when randomly
   *              generating a new room
   */

  public Crystal(int variant) {
    this.variant = variant;
  }

  /**
   * Constructor: public Crystal()
   *  Parameters: JSONObject object - A JSON serialization of the crystal
   * Description: Constructs a crystal from JSON save data
   */

  public Crystal(JSONObject object) {
    this.variant = object.getInt("variant", 0);
  }

  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the crystal to JSON
   */

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "Crystal");
    object.setInt("variant", this.variant);
    return object;
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the crystal as a cluster of pointed
   *              shards growing upward from a rocky base,
   *              with a subtle glow effect
   */

  public void draw() {
    float size = min((float) width / 12, (float) height / 12);
    float cx = size / 2;
    noStroke();

    // Glow effect behind the crystals
    fill(120, 80, 200, 40);
    ellipse(cx, size * 0.55, size * 0.85, size * 0.7);

    // Rocky base
    fill(45, 35, 55);
    ellipse(cx, size * 0.78, size * 0.7, size * 0.22);

    if (this.variant % 3 == 0) {
      // Tall center crystal with two small ones
      // Left small shard
      fill(100, 60, 180);
      triangle(cx - size * 0.2, size * 0.7, cx - size * 0.26, size * 0.35, cx - size * 0.14, size * 0.7);
      fill(140, 100, 220, 180);
      triangle(cx - size * 0.2, size * 0.65, cx - size * 0.24, size * 0.4, cx - size * 0.18, size * 0.55);

      // Center tall shard
      fill(120, 70, 200);
      triangle(cx - size * 0.08, size * 0.72, cx, size * 0.12, cx + size * 0.08, size * 0.72);
      fill(160, 120, 240, 180);
      triangle(cx - size * 0.03, size * 0.65, cx + size * 0.01, size * 0.2, cx + size * 0.05, size * 0.55);

      // Right small shard
      fill(90, 50, 170);
      triangle(cx + size * 0.14, size * 0.7, cx + size * 0.22, size * 0.3, cx + size * 0.26, size * 0.7);
      fill(130, 90, 210, 180);
      triangle(cx + size * 0.16, size * 0.65, cx + size * 0.21, size * 0.35, cx + size * 0.24, size * 0.6);
    } else if (this.variant % 3 == 1) {
      // Two medium crystals leaning apart
      // Left shard (leaning left)
      fill(80, 130, 210);
      triangle(cx - size * 0.05, size * 0.72, cx - size * 0.22, size * 0.15, cx - size * 0.18, size * 0.72);
      fill(120, 170, 240, 180);
      triangle(cx - size * 0.08, size * 0.6, cx - size * 0.2, size * 0.22, cx - size * 0.14, size * 0.55);

      // Right shard (leaning right)
      fill(90, 140, 220);
      triangle(cx + size * 0.05, size * 0.72, cx + size * 0.24, size * 0.18, cx + size * 0.18, size * 0.72);
      fill(130, 180, 245, 180);
      triangle(cx + size * 0.08, size * 0.6, cx + size * 0.22, size * 0.25, cx + size * 0.16, size * 0.55);

      // Tiny center shard
      fill(100, 150, 230);
      triangle(cx - size * 0.03, size * 0.72, cx + size * 0.01, size * 0.4, cx + size * 0.05, size * 0.72);
    } else {
      // Wide cluster of four small crystals
      float[] offsets = { -0.25, -0.08, 0.1, 0.25 };
      float[] heights = { 0.35, 0.2, 0.25, 0.38 };
      int[] r = { 110, 90, 130, 100 };
      int[] g = { 70, 120, 80, 100 };
      int[] b = { 190, 220, 210, 200 };

      for (int i = 0; i < 4; i++) {
        float ox = cx + offsets[i] * size;
        float hw = size * 0.05;

        fill(r[i], g[i], b[i]);
        triangle(ox - hw, size * 0.72, ox, heights[i] * size, ox + hw, size * 0.72);

        // Highlight edge
        fill(r[i] + 40, g[i] + 40, b[i] + 30, 160);
        triangle(ox - hw * 0.3, size * 0.65, ox + hw * 0.2, (heights[i] + 0.08) * size, ox + hw * 0.5, size * 0.6);
      }
    }

    // Sparkle highlight on top crystal
    fill(255, 255, 255, 180);
    ellipse(cx + size * 0.02, size * 0.22, size * 0.04, size * 0.04);
  }
}
