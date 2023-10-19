using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Playerbullet : MonoBehaviour
{
    [SerializeField]
    public Vector3 velocity;

    [SerializeField]
    HUDManager manager;

    [SerializeField]
    string name;

    private bool active = false;

    private GameObject BulletBank;

    // Update is called once per frame
    void Update()
    {
        if (active)
        {
            transform.position += velocity * Time.deltaTime;
            transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);

            //Check for far bounds
            //Stop Y
            Camera cam = Camera.main;
            float height = 2f * cam.orthographicSize;
            float width = height * cam.aspect;

            Transform t = transform;
            if (t.position.y > (height / 2) + 1)
            {
                Collide();
            }
            else if (t.position.y < -(height / 2) - 1)
            {
                Collide();
            }
            else if (t.position.x < -width/2 - 1)
            {
                Collide();
            }
            else if (t.position.x > (width/2) - (manager.hudWidth * width) + 1)
            {
                Collide();
            }
        }
    }

    public void Collide()
    {
        active = false;
        BulletBank.GetComponent<BulletBankManager>().ReturnBullet(gameObject, name);
    }

    public void Activate()
    {
        active = true;
    }

    public void SetBank(GameObject bank)
    {
        BulletBank = bank;
    }

    public void SetScreen(HUDManager screen)
    {
        manager = screen;
    }
}
