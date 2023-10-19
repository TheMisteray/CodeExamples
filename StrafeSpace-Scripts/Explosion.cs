using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explosion : MonoBehaviour
{
    [SerializeField]
    List<Sprite> spritesheet = new List<Sprite>();

    private float spriteTimer = 0;
    private int spriteNum;

    // Update is called once per frame
    void Update()
    {
        spriteTimer += 60 * Time.deltaTime;
        if (spriteTimer > 20) //Simple spritesheet loop
        {
            gameObject.GetComponent<SpriteRenderer>().sprite = spritesheet[spriteNum];
            spriteTimer = 0;
            spriteNum++;
            if (spriteNum >= spritesheet.Count)
                Destroy(gameObject);
        }
    }
}
