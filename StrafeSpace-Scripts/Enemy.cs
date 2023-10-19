using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    [SerializeField]
    public int health;

    [SerializeField]
    public CollisionManager collisionManager;

    [SerializeField]
    int pointAmount;

    [SerializeField]
    public BulletBankManager bulletBankManager;

    [SerializeField]
    string powerType;

    private void Update()
    {
        Camera cam = Camera.main;
        float height = 2f * cam.orthographicSize;
        float width = height * cam.aspect;

        if (transform.position.y < -(height/2))
        {
            Despawn();
        }
    }

    public void damage(int damage)
    {
        health -= damage;
        if (health < 0)
            kill();
    }

    public int PointAmount
    {
        get { return pointAmount; }
    }

    private void kill()
    {
        collisionManager.RemoveEnemy(gameObject);
        collisionManager.RegisterKill(pointAmount);
        Destroy(gameObject);
        bulletBankManager.RequestBullet(transform.position, powerType);
    }

    public void Despawn()
    {
        collisionManager.RemoveEnemy(gameObject);
        Destroy(gameObject);
    }
}
