/**
 *      Author: Reece Anderson
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-09
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: CreatureType.pde
 * Description: Defines creature types and the damage
 *              multiplier chart for type matchups
 */

enum CreatureType {
  FIRE,
  WATER,
  GRASS,
  NORMAL;

  /**
   *      Method: public getMultiplier()
   *  Parameters: CreatureType defender - The type of the
   *                                     defending creature
   *      Return: float - The damage multiplier (0.5, 1.0, or 2.0)
   * Description: Returns the damage multiplier when this type
   *              attacks the given defender type. Fire beats Grass,
   *              Grass beats Water, Water beats Fire.
   */

  public float getMultiplier(CreatureType defender) {
    if (this == NORMAL || defender == NORMAL) {
      return 1.0;
    }

    if (this == FIRE && defender == GRASS) return 2.0;
    if (this == FIRE && defender == WATER) return 0.5;
    if (this == WATER && defender == FIRE) return 2.0;
    if (this == WATER && defender == GRASS) return 0.5;
    if (this == GRASS && defender == WATER) return 2.0;
    if (this == GRASS && defender == FIRE) return 0.5;

    return 1.0;
  }

  /**
   *      Method: public getColor()
   *  Parameters: void
   *      Return: int[] - RGB values for this type's primary color
   * Description: Returns the display color for this creature type
   *              as an array of {red, green, blue} values
   */

  public int[] getColor() {
    switch (this) {
    case FIRE:
      return new int[]{239, 68, 68};

    case WATER:
      return new int[]{59, 130, 246};

    case GRASS:
      return new int[]{34, 197, 94};

    default:
      return new int[]{180, 180, 180};
    }
  }

  /**
   *      Method: public getAccent()
   *  Parameters: void
   *      Return: int[] - RGB values for this type's accent color
   * Description: Returns a secondary color for visual variety
   *              as an array of {red, green, blue} values
   */

  public int[] getAccent() {
    switch (this) {
    case FIRE:
      return new int[]{251, 146, 60};

    case WATER:
      return new int[]{96, 165, 250};

    case GRASS:
      return new int[]{74, 222, 128};

    default:
      return new int[]{220, 220, 220};
    }
  }
}
