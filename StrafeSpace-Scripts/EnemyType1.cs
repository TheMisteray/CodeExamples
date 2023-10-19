using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyType1 : MonoBehaviour
{
    public Vector3 swingPoint = Vector3.zero;

    private float bulletCounter = 120;

    private Vector3 velocity = Vector3.zero;

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y > swingPoint.y)
        {
            Vector3 swingArc = swingPoint - transform.position;
            swingArc.y *= 3; //make vertical move first

            velocity = swingArc.normalized * .5f * Time.deltaTime;
        }
        else
        {
            velocity = new Vector3(0, -.5f, 0) * Time.deltaTime;
        }

        transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
        transform.position += velocity;

        bulletCounter -= (60 * Time.deltaTime);
        if (bulletCounter < 0)
        {
            bulletCounter = 120;
            Shoot();
        }
    }

    private void Shoot()
    {
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet1");
        bullet.GetComponent<Playerbullet>().velocity = new Vector3(0, -2, 0);
    }
}
