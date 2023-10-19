using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyType4 : MonoBehaviour
{
    private float bulletCounter = 90;

    private Vector3 velocity = Vector3.zero;

    // Update is called once per frame
    void Update()
    {
        velocity = new Vector3(0, -1.2f, 0) * Time.deltaTime;

        transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
        transform.position += velocity;

        bulletCounter -= (60 * Time.deltaTime);
        if (bulletCounter < 0)
        {
            bulletCounter = 90;
            Shoot();
        }
    }

    private void Shoot()
    {
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet4");
        bullet.GetComponent<Playerbullet>().velocity = new Vector3(-4, 0, 0);
        GameObject bullet2 = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet4");
        bullet2.GetComponent<Playerbullet>().velocity = new Vector3(4, 0, 0);
    }
}
