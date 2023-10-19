using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boss : MonoBehaviour
{
    private float bulletCounter = 0;
    private float moveTimer = 0;
    private float delayTimer = 0;
    private int bulletsFired = 0;
    private float phasePause = 0;
    private Vector3 toPlayer = Vector3.zero;

    public GameObject player;

    public GameObject explosion;

    public HUDManager screen;

    public CollisionManager col;

    private bool moving = true;

    private Vector3 moveTo = Vector3.zero;

    private int phase = -1;

    [SerializeField]
    List<Sprite> spritesheet = new List<Sprite>();

    private float spriteTimer = 0;
    private int spriteNum = 0;

    //Phase 1 stuff
    private bool left = false;

    //Phase 2 stuff
    private Vector3 vecVel = Vector3.zero;
    private float angleTicker = 0;
    private float secondaryBulletCounter;

    // Update is called once per frame
    void Update()
    {
        //movement
        Camera cam = Camera.main;
        float height = 2f * cam.orthographicSize;
        float width = height * cam.aspect;

        spriteTimer += 60 * Time.deltaTime;
        if (spriteTimer > 10) //Simple spritesheet loop
        {
            gameObject.GetComponent<SpriteRenderer>().sprite = spritesheet[spriteNum];
            spriteTimer = 0;
            spriteNum++;
            if (spriteNum >= spritesheet.Count)
                spriteNum = 0;
        }

        if (phasePause > 0)
        {
            Vector3 moveTo = Vector3.zero;
            moveTo.x = -(screen.hudWidth * width) / 2;
            moveTo.y = (height / 2) - (height / 10);
            phasePause -= 60 * Time.deltaTime;
            vecVel = (moveTo - transform.position) / 2;
        }
        else
        {
            switch (phase)
            {
                case -1: //Move into screen
                    moveTimer += 60 * Time.deltaTime;
                    if (moveTimer < 300)
                    {
                        Vector3 velocity = new Vector3(0, -.5f, 0) * Time.deltaTime;
                        Vector3 dir = RotateDegrees(velocity, 90);
                        transform.rotation = Quaternion.LookRotation(Vector3.back, dir.normalized);
                        transform.position += velocity;
                    }
                    else
                    {
                        phase = 1;
                        phasePause = 120;
                        moveTimer = 0;
                    }
                    break;
                case 0: //Death
                    delayTimer += 60 * Time.deltaTime;
                    if (delayTimer > 30)
                    {
                        Instantiate(explosion, transform.position + new Vector3(0, 0, 2), Quaternion.identity, transform);
                    }
                    bulletCounter += 60 * Time.deltaTime;
                    if (bulletCounter > 240)
                    {
                        Destroy(gameObject);
                        col.RemoveEnemy(gameObject);
                        col.RegisterKill(gameObject.GetComponent<Enemy>().PointAmount);
                        screen.Victory();
                    }
                    break;
                case 1:
                    moveTimer += 60 * Time.deltaTime;
                    if (moveTimer > 240)
                    {
                        delayTimer += 60 * Time.deltaTime;
                        if (delayTimer > 10)
                        {
                            ShootPair();
                            bulletsFired++;
                            delayTimer = 0;
                        }
                        if (bulletsFired > 8)
                        {
                            moveTimer = 0;
                            delayTimer = 0;
                            bulletsFired = 0;
                        }
                    }
                    else
                    {
                        if (left)
                        {
                            Vector3 velocity = new Vector3(-2, 0, 0) * Time.deltaTime;
                            transform.position += velocity;
                            if (transform.position.x < (-width/2) + (width / 20))
                            {
                                left = !left;
                            }
                        }
                        else
                        {
                            Vector3 velocity = new Vector3(2, 0, 0) * Time.deltaTime;
                            transform.position += velocity;
                            if (transform.position.x > (width / 2) - (width / 20) - (screen.hudWidth * width))
                            {
                                left = !left;
                            }
                        }
                        toPlayer = player.transform.position - transform.position;
                        Vector3 dir = RotateDegrees(toPlayer, 90);
                        transform.rotation = Quaternion.LookRotation(Vector3.back, dir.normalized);
                    }
                    bulletCounter += 60 * Time.deltaTime;
                    if (bulletCounter > 20)
                    {
                        ShootDownBeam();
                        bulletCounter = 0;
                    }
                    if (gameObject.GetComponent<Enemy>().health < 1900)
                    {
                        phase = 2;
                        phasePause = 120;
                        moveTimer = 0;
                        bulletCounter = 0;
                        delayTimer = 0;
                        bulletsFired = 0;
                        moveTimer = 0;

                        DropPower();
                    }
                    break;
                case 2:
                    moveTimer += 60 * Time.deltaTime;
                    if (moveTimer < 120)
                    {
                        Vector3 dir = RotateDegrees(vecVel, 90);
                        transform.rotation = Quaternion.LookRotation(Vector3.back, dir.normalized);
                        transform.position += vecVel * Time.deltaTime;
                    }
                    else
                    {
                        toPlayer = player.transform.position - transform.position;
                        Vector3 dir = RotateDegrees(toPlayer, 90);
                        transform.rotation = Quaternion.LookRotation(Vector3.back, dir.normalized);

                        delayTimer += 60 * Time.deltaTime;
                        if (delayTimer > 90)
                        {
                            ShootAcceleratingRing(angleTicker);
                            angleTicker += 40;
                            delayTimer = 0;
                        }
                        bulletCounter += 60 * Time.deltaTime;
                        if (bulletCounter > 180)
                        {
                            secondaryBulletCounter += 60 * Time.deltaTime;
                            if (secondaryBulletCounter > 20)
                            {
                                FastShot();
                                bulletsFired++;
                                secondaryBulletCounter = 0;
                                if (bulletsFired > 2)
                                {
                                    bulletCounter = 0;
                                    bulletsFired = 0;
                                }
                            }
                        }
                    }
                    toPlayer = player.transform.position - transform.position;
                    Vector3 direc = RotateDegrees(toPlayer, 90);
                    transform.rotation = Quaternion.LookRotation(Vector3.back, direc.normalized);
                    if (gameObject.GetComponent<Enemy>().health < 1300)
                    {
                        phase = 3;
                        phasePause = 120;
                        moveTimer = 0;
                        bulletCounter = 0;
                        delayTimer = 0;
                        bulletsFired = 0;
                        secondaryBulletCounter = 0;

                        DropPower();
                    }
                    break;
                case 3:
                    delayTimer += 60 * Time.deltaTime;
                    if (delayTimer > 40)
                    {
                        ShootFans(angleTicker);
                        angleTicker += 25;
                        delayTimer = 0;
                    }
                    bulletCounter += 60 * Time.deltaTime;
                    if (bulletCounter > 240)
                    {
                        ShootHomingTri();
                        bulletCounter = 0;
                    }
                    if (gameObject.GetComponent<Enemy>().health < 1000)
                    {
                        secondaryBulletCounter += 60 * Time.deltaTime;
                        if (secondaryBulletCounter > 30)
                        {
                            ShootDownBeam();
                            secondaryBulletCounter = 0;
                        }
                    }
                    toPlayer = player.transform.position - transform.position;
                    Vector3 direction = RotateDegrees(toPlayer, 90);
                    transform.rotation = Quaternion.LookRotation(Vector3.back, direction.normalized);
                    if (gameObject.GetComponent<Enemy>().health < 700)
                    {
                        phase = 0;
                        phasePause = 120;
                        moveTimer = 0;
                        bulletCounter = 0;
                        delayTimer = 0;
                        bulletsFired = 0;
                        secondaryBulletCounter = 0;
                        gameObject.GetComponent<Enemy>().health = 10000;
                    }
                    break;
            }
        }
    }

    private void ShootDownBeam()
    {
        float x;
        Vector3 trajectory = new Vector3((x = Random.Range(-1f, 1f)), x/3, 0);
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "bossBeam");
        trajectory = RotateDegrees(trajectory, Random.Range(-30f, 30f));
        bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 2;
    }

    private void ShootPair()
    {
        GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet1");
        Vector3 trajectory = toPlayer;
        trajectory = RotateDegrees(trajectory, -24f);
        bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 4;
        GameObject bullet2 = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet1");
        Vector3 trajectory2 = toPlayer;
        trajectory2 = RotateDegrees(trajectory2, 24f);
        bullet2.GetComponent<Playerbullet>().velocity = trajectory2.normalized * 4;
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

    private void ShootAcceleratingRing(float extra)
    {
        for (int i = 0; i < 8; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet3");
            Vector3 trajectory = new Vector3(3.5f, 0, 0);
            trajectory = RotateDegrees(trajectory, (45 * i) + extra);
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized;
        }
    }

    private void FastShot()
    {
        for (int i = 0; i <= 2; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet1");
            Vector3 trajectory = toPlayer;
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * (3 + i * 2);
        }
    }

    private void ShootFans(float extra)
    {
        for (int q = 0; q < 4; q++)
        {
            for (int i = -3; i <= 3; i++)
            {
                GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet1");
                Vector3 trajectory = new Vector3(1, 0, 0);
                trajectory = RotateDegrees(trajectory, (2 * i) + (q * 90) + extra);
                bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 3;
            }
        }
    }

    private void ShootHomingTri()
    {
        for (int i = -1; i <= 1; i++)
        {
            GameObject bullet = gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position, "enemyBullet5");
            Vector3 trajectory = toPlayer;
            trajectory = RotateDegrees(trajectory, 5 * i);
            bullet.GetComponent<Playerbullet>().velocity = trajectory.normalized * 5;
            bullet.GetComponent<Homing>().player = player;
        }
    }

    private void DropPower()
    {
        gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position , "powerItemLarge");
        gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position + new Vector3(-.05f, -.05f, 0), "powerItemLarge");
        gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position + new Vector3(-.025f, .025f, 0), "powerItemLarge");
        gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position + new Vector3(.05f, .05f, 0), "powerItemLarge");
        gameObject.GetComponent<Enemy>().bulletBankManager.RequestBullet(transform.position + new Vector3(.025f, .025f, 0), "powerItemLarge");
    }
}
