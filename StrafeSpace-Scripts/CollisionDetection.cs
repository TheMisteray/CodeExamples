using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionDetection : MonoBehaviour
{
    public bool AABBCollision(GameObject obj1, GameObject obj2)
    {
        Bounds bounds1 = obj1.GetComponent<SpriteRenderer>().bounds;
        Bounds bounds2 = obj2.GetComponent<SpriteRenderer>().bounds;

        //Check for non - collisions
        if (bounds1.max.x < bounds2.min.x || bounds1.min.x > bounds2.max.x || bounds1.max.y < bounds2.min.y || bounds1.min.y > bounds2.max.y)
        {
            //Return false if any are true
            return false;
        }
        return true;
    }

    public bool CircleCollision(GameObject obj1, GameObject obj2)
    {
        Bounds bounds1 = obj1.GetComponent<SpriteRenderer>().bounds;
        Bounds bounds2 = obj2.GetComponent<SpriteRenderer>().bounds;

        Vector3 distance = bounds1.center - bounds2.center;

        //Set radii to the smaller of width and height
        float radius1 = bounds1.extents.x;
        if (bounds1.extents.x > bounds1.extents.y)
            radius1 = bounds1.extents.y;
        float radius2 = bounds2.extents.x;
        if (bounds2.extents.x > bounds2.extents.y)
            radius2 = bounds2.extents.y;

        float distanceSquare = (distance.x * distance.x) + (distance.y * distance.y);

        if (Mathf.Pow((radius1 + radius2), 2) > distanceSquare)
            return true;
        return false;
    }
}
