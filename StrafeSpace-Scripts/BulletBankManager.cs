using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletBankManager : MonoBehaviour
{
    [SerializeField]
    HUDManager screen;
    //Bullet Types
    [SerializeField]
    GameObject playerBulletSmall;
    [SerializeField]
    GameObject playerBulletLarge;

    [SerializeField]
    GameObject enemyBullet1;
    [SerializeField]
    GameObject enemyBullet2;
    [SerializeField]
    GameObject enemyBullet3;
    [SerializeField]
    GameObject enemyBullet4;
    [SerializeField]
    GameObject enemyBullet5;
    [SerializeField]
    GameObject bossBeam;

    [SerializeField]
    GameObject powerItemSmall;
    [SerializeField]
    GameObject poweritemLarge;

    [SerializeField]
    CollisionManager collisionManager;

    //Bullet Storage
    private Stack<GameObject> playerBulletSmallBank;
    private Stack<GameObject> playerBulletLargeBank;

    private Stack<GameObject> enemyBullet1Bank;
    private Stack<GameObject> enemyBullet2Bank;
    private Stack<GameObject> enemyBullet3Bank;
    private Stack<GameObject> enemyBullet4Bank;
    private Stack<GameObject> enemyBullet5Bank;

    private Stack<GameObject> bossBeamBank;

    private Stack<GameObject> powerBankSmall;
    private Stack<GameObject> powerBankLarge;

    // Start is called before the first frame update
    void Start()
    {
        playerBulletSmallBank = new Stack<GameObject>();
        //Spawn initial Bullets

        //TODO: find out why spawning more here causes bullets to vanish
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(playerBulletSmall, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            playerBulletSmallBank.Push(bullet);
        }

        enemyBullet1Bank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(enemyBullet1, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            enemyBullet1Bank.Push(bullet);
        }
        enemyBullet2Bank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(enemyBullet2, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            enemyBullet2Bank.Push(bullet);
        }
        enemyBullet3Bank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(enemyBullet3, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            enemyBullet3Bank.Push(bullet);
        }
        enemyBullet4Bank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(enemyBullet4, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            enemyBullet4Bank.Push(bullet);
        }
        enemyBullet5Bank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(enemyBullet5, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            enemyBullet5Bank.Push(bullet);
        }
        bossBeamBank = new Stack<GameObject>();
        for (int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(bossBeam, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            bossBeamBank.Push(bullet);
        }

        powerBankSmall = new Stack<GameObject>();
        for(int i = 0; i < 0; i++)
        {
            GameObject bullet = Instantiate(powerItemSmall, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            powerBankSmall.Push(bullet);
        }

        playerBulletLargeBank = new Stack<GameObject>();
        for(int i = 1; i < 0; i++)
        {
            GameObject bullet = Instantiate(playerBulletLarge, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            playerBulletLargeBank.Push(bullet);
        }

        powerBankLarge = new Stack<GameObject>();
        for (int i = 1; i < 0; i++)
        {
            GameObject bullet = Instantiate(poweritemLarge, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Collide();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            powerBankLarge.Push(bullet);
        }
    }

    public Stack<GameObject> getPlayerBulletSmalls()
    {
        return playerBulletSmallBank;
    }

    public GameObject RequestBullet(Vector3 position, string kind)
    {
        Stack<GameObject> bank = null;
        GameObject bulletType = null;
        GameObject bullet = null;
        switch (kind)
        {
            case "playerBulletSmall":
                bank = playerBulletSmallBank;
                bulletType = playerBulletSmall;
                break;
            case "playerBulletLarge":
                bank = playerBulletLargeBank;
                bulletType = playerBulletLarge;
                break;
            case "enemyBullet1":
                bank = enemyBullet1Bank;
                bulletType = enemyBullet1;
                break;
            case "enemyBullet2":
                bank = enemyBullet2Bank;
                bulletType = enemyBullet2;
                break;
            case "enemyBullet3":
                bank = enemyBullet3Bank;
                bulletType = enemyBullet3;
                break;
            case "enemyBullet4":
                bank = enemyBullet4Bank;
                bulletType = enemyBullet4;
                break;
            case "enemyBullet5":
                bank = enemyBullet5Bank;
                bulletType = enemyBullet5;
                break;
            case "bossBeam":
                bank = bossBeamBank;
                bulletType = bossBeam;
                break;
            case "powerItemSmall":
                bank = powerBankSmall;
                bulletType = powerItemSmall;
                break;
            case "powerItemLarge":
                bank = powerBankLarge;
                bulletType = poweritemLarge;
                break;
        }

        if (bank.Count > 0)
        {
            bullet = bank.Pop();
            bullet.GetComponent<Playerbullet>().Activate();
            bullet.transform.position = position;
        }
        else //new bullet
        {
            bullet = Instantiate(bulletType, transform.position, Quaternion.identity, transform);
            bullet.GetComponent<Playerbullet>().SetBank(gameObject);
            bullet.GetComponent<Playerbullet>().Activate();
            bullet.GetComponent<Playerbullet>().SetScreen(screen);
            bullet.transform.position = position;
        }

        //Add bullets to collisionManager
        switch (kind)
        {
            case "playerBulletSmall":
                collisionManager.smallPlayerBullets.Add(bullet);
                break;
            case "playerBulletLarge":
                collisionManager.largePlayerBullets.Add(bullet);
                break;
            case "enemyBullet1":
            case "enemyBullet2":
            case "enemyBullet3":
            case "enemyBullet4":
            case "enemyBullet5":
            case "bossBeam":
                collisionManager.enemyBullets.Add(bullet);
                break;
            case "powerItemSmall":
                collisionManager.smallPowerItems.Add(bullet);
                break;
            case "powerItemLarge":
                collisionManager.largePowerItems.Add(bullet);
                break;
        }

        return bullet;
    }

    public void ReturnBullet(GameObject bullet, string kind)
    {
        switch(kind)
        {
            case "playerBulletSmall":
                playerBulletSmallBank.Push(bullet);
                collisionManager.smallPlayerBullets.Remove(bullet);
                break;
            case "playerBulletLarge":
                playerBulletLargeBank.Push(bullet);
                collisionManager.largePlayerBullets.Remove(bullet);
                break;
            case "enemyBullet1":
                enemyBullet1Bank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                break;
            case "enemyBullet2":
                enemyBullet2Bank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                break;
            case "enemyBullet3":
                enemyBullet3Bank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                break;
            case "enemyBullet4":
                enemyBullet4Bank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                break;
            case "enemyBullet5":
                enemyBullet5Bank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                break;
            case "bossBeam":
                bossBeamBank.Push(bullet);
                collisionManager.enemyBullets.Remove(bullet);
                bullet.GetComponent<BossBeam>().BeamMode = false;
                break;
            case "powerItemSmall":
                powerBankSmall.Push(bullet);
                collisionManager.smallPowerItems.Remove(bullet);
                break;
            case "powerItemLarge":
                powerBankLarge.Push(bullet);
                collisionManager.largePowerItems.Remove(bullet);
                break;
        }
        bullet.transform.position = transform.position;
    }
}
