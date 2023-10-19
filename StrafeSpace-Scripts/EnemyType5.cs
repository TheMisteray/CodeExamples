using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyType5 : MonoBehaviour
{
    private float bulletCounter = 120;
    private float moveTimer = 0;
    private float delayTimer = 30;
    private int bulletsFired;

    public GameObject player;

    public HUDManager screen;

    private bool moving = true;

    private Vector3 moveTo = Vector3.zero;

    // Update is called once per frame
    void Update()
    {
        if (bulletsFired >= 10)
        {
            if (delayTimer > 0)
            {
                delayTimer -= 60 * Time.deltaTime;
            }
            else
            {
                Vector3 velocity = new Vector3(0, -3f, 0) * Time.deltaTime;

                transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
                transform.position += velocity;
            }
        }
        else
        {
            if (moving)
            {
                if (delayTimer > 0)
                {
                    delayTimer -= 60 * Time.deltaTime;
                }
                else
                {
                    moveTimer += 60 * Time.deltaTime;

                    Vector3 velocity = moveTo - transform.position;
                    velocity *= Time.deltaTime;
                    transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
                    transform.position += velocity;

                    if (moveTimer > 60)
                    {
                        moving = false;
                        moveTimer = 0;
                        delayTimer = 30;
                    }
                }
            }
            else
            {
                //shooting
                bulletCounter -= 60 * Time.deltaTime;
                Vector3 toPlayer = player.transform.position - transform.position;
                transform.rotation = Quaternion.LookRotation(Vector3.back, toPlayer.normalized);
                if (bulletCounter < 0)
                {
                    Shoot();
                    moving = true;
                    bulletCounter = 120;
                    bulletsFired++;

                    Camera cam = Camera.main;
                    float height = 2f * cam.orthographicSize;
                    float width = height * cam.aspect;

                    moveTo.y = Random.Range((height / 2) - (height / 5), height / 2);
                    moveTo.x = Random.Range(-width / 2, (width / 2) - screen.hudWidth * width);
                }
            }
        }
    }

    private void Shoot()
    {
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet5");
        Vector3 trajectory = player.transform.position - bullet.transform.position;
        bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 5;
        bullet.GetComponent<Homing>().player = player;
    }
}
