using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyType3 : MonoBehaviour
{

    private float lifeTimer = 0;
    private float bulletTimer = 0;
    private float smallTimer = 20;
    private int attackTracker = 0;
    private int attackCycle = 0;
    private Vector3 toPlayer = Vector3.zero;

    public GameObject player;

    // Update is called once per frame
    void Update()
    {
        lifeTimer += 60 * Time.deltaTime;
        if (lifeTimer < 180)
        {
            Vector3 velocity = new Vector3(0, -.7f, 0) * Time.deltaTime;
            transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
            transform.position += velocity;
        }
        else if (lifeTimer < 1620)
        {
            bulletTimer += 60 * Time.deltaTime;

            if (bulletTimer > 120)
            {
                switch (attackCycle)
                {
                    case 0:
                        smallTimer += 60 * Time.deltaTime;
                        if (smallTimer > 20)
                        {
                            Shoot();
                            attackTracker++;
                            smallTimer = 0;
                        }
                        if (attackTracker > 4)
                        {
                            attackCycle++;
                            attackTracker = 0;
                            bulletTimer = 0;
                        }
                        break;
                    case 1:
                        BurstShot();
                        attackCycle++;
                        attackTracker = 0;
                        bulletTimer = 0;
                        break;
                    case 2:
                        smallTimer += 60 * Time.deltaTime;
                        if (smallTimer > 20)
                        {
                            FastShot();
                            attackTracker++;
                        }
                        if (attackTracker > 2)
                        {
                            attackCycle=0;
                            attackTracker = 0;
                            bulletTimer = 0;
                        }
                        break;
                }
            }
            else
            {
                toPlayer = player.transform.position - transform.position;
                transform.rotation = Quaternion.LookRotation(Vector3.back, toPlayer.normalized);
            }

        }
        else
        {
            Vector3 velocity = new Vector3(0, -1f, 0) * Time.deltaTime;
            transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
            transform.position += velocity;
        }
    }

    private void Shoot()
    {
        for (int i = -2; i <= 2; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet3");
            Vector3 trajectory = toPlayer;
            trajectory = RotateDegrees(trajectory, 16 * i);
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 3;
        }
    }

    private Vector3 RotateDegrees(Vector3 v, float degrees)
    {
        return RotateRadians(v, degrees * Mathf.Deg2Rad);
    }

    private Vector3 RotateRadians(Vector3 v, float radians)
    {
        var ca = Mathf.Cos(radians);
        var sa = Mathf.Sin(radians);
        return new Vector3(ca * v.x - sa * v.y, sa * v.x + ca * v.y, v.z);
    }

    private void BurstShot()
    {
        for (int i = -2; i <= 2; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet3");
            Vector3 trajectory = toPlayer;
            trajectory = RotateDegrees(trajectory, 3 * i);
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 3;
        }
    }

    private void FastShot()
    {
        for (int i = 0; i <= 2; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet3");
            Vector3 trajectory = toPlayer;
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * (4 + i * 2);
        }
    }
}
