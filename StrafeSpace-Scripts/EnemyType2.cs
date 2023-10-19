using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyType2 : MonoBehaviour
{
    private float bulletCounter = 120;
    private float smallTimer = 20;
    private int shotCounter = 0;
    private float downTimer = 0;

    public GameObject player;

    public HUDManager screen;

    private enum State
    {
        Left,
        Down,
        Right
    }

    private State currentState = State.Right;

    // Update is called once per frame
    void Update()
    {
        //shooting
        bulletCounter -= 60 * Time.deltaTime;
        if (bulletCounter < 0)
        {
            smallTimer -= 60 * Time.deltaTime;
            if (smallTimer < 0)
            {
                shotCounter++;
                smallTimer = 20;
                Shoot();
                if (shotCounter >= 3)
                {
                    shotCounter = 0;
                    bulletCounter = 120;
                }
            }
        }

        //movement
        Camera cam = Camera.main;
        float height = 2f * cam.orthographicSize;
        float width = height * cam.aspect;

        if (transform.position.x < -width/2 + (width/20)) //left 10th of screen
        {
            if (currentState == State.Down)
            {
                downTimer += 60 * Time.deltaTime;
                if (downTimer > 60)
                {
                    currentState = State.Right;
                    downTimer = 0;
                }
            }
            else if (currentState == State.Left)
                currentState = State.Down;
        }
        else if (transform.position.x > (width/2 - (width/20)) - (screen.hudWidth * width))
        {
            if (currentState == State.Down)
            {
                downTimer += 60 * Time.deltaTime;
                if (downTimer > 60)
                {
                    currentState = State.Left;
                    downTimer = 0;
                }
            }
            else if (currentState == State.Right)
                currentState = State.Down;
        }

        Vector3 velocity = Vector3.zero;
        switch (currentState)
        {
            case State.Down:
                velocity = new Vector3(0, -2f, 0) * Time.deltaTime;
                break;
            case State.Left:
                velocity = new Vector3(-2, 0, 0) * Time.deltaTime;
                break;
            case State.Right:
                velocity = new Vector3(2, 0, 0) * Time.deltaTime;
                break;
        }
        transform.rotation = Quaternion.LookRotation(Vector3.back, velocity.normalized);
        transform.position += velocity;
    }

    private void Shoot()
    {
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet2");
        Vector3 trajectory = player.transform.position - bullet.transform.position;
        bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 3;
    }
}
