using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossBeam : MonoBehaviour
{
    [SerializeField]
    Sprite OrbSprite;
    [SerializeField]
    Sprite BeamSprite;

    private float timer = 0;

    public bool BeamMode = false;

    // Update is called once per frame
    void Update()
    {
        if (BeamMode)
        {
            gameObject.GetComponent<SpriteRenderer>().sprite = BeamSprite;
            gameObject.GetComponent<Playerbullet>().velocity = new Vector3(0, -5, 0);
        }
        else
        {
            gameObject.GetComponent<SpriteRenderer>().sprite = OrbSprite;

            timer += 60 * Time.deltaTime;
            if (timer > 120)
            {
                BeamMode = true;
                timer = 0;
            }
        }
    }
}
