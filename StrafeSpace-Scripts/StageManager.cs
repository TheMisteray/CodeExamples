using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StageManager : MonoBehaviour
{
    [SerializeField]
    GameObject Enemy1;
    [SerializeField]
    GameObject Enemy2;
    [SerializeField]
    GameObject Enemy3;
    [SerializeField]
    GameObject Enemy4;
    [SerializeField]
    GameObject Enemy5;
    [SerializeField]
    GameObject Boss;

    [SerializeField]
    GameObject Explosion;

    [SerializeField]
    HUDManager screen;

    [SerializeField]
    GameObject player;

    [SerializeField]
    CollisionManager collisionManager;

    [SerializeField]
    BulletBankManager bulletBankManager;

    private float spawnTimer = 0;
    private float seconds = 0;

    private bool start = false;

    // Update is called once per frame
    void Update()
    {
        if (start)
        {
            spawnTimer += Time.deltaTime * 60;
            if (spawnTimer > 60)
            {
                Camera cam = Camera.main;
                float height = 2f * cam.orthographicSize;
                float width = height * cam.aspect;
                seconds++;
                spawnTimer = 0;
                switch (seconds)
                {
                    case 2:
                        for (int i = 0; i<4; i++) //4 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - (screen.hudWidth * width) -.5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 12:
                        for (int i = 0; i < 4; i++) //4 Enemy1 from right
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = (width / 2) - (screen.hudWidth * width) - .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((-width / 2) + .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 22:
                        for (int i = 0; i < 2; i++)
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = (-width / 2) + .5f + (width/5 * 2);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = (width / 2) - (screen.hudWidth * width) - .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - .5f - (width / 5 * 2) - (screen.hudWidth * width));

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 30:
                        for (int i = 0; i < 2; i++) //2 Enemy2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 40:
                        for (int i = 0; i < 2; i++)//2 enemy2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) -.5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 4; i++)//4 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 52:
                        for (int i =0; i < 1; i++)//Enemy 4 down center
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = (-(screen.hudWidth * width)/2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 58:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 66:
                        for (int i = 0; i < 2; i++)//2 enemy 2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)//2 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 72:
                        for (int i = 0; i < 2; i++)//2 enemy 2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 4; i++) //4 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - (screen.hudWidth * width) - .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 80:
                        for (int i = 0; i < 2; i++)//2 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = (-width / 2) + .5f + (width / 5 * 2);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = (width / 2) - (screen.hudWidth * width) - .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - .5f - (width / 5 * 2) - (screen.hudWidth * width));

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = -1; i < 2; i+=2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 90:
                        for (int i = 0; i < 1; i++)// Enemy 3
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2));

                            GameObject enemy = Instantiate(Enemy3, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType3>().player = player;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 110:
                        for (int i = 0; i < 1; i++)//Enemy 4 down center
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = (-(screen.hudWidth * width) / 2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 122:
                        for (int i = 0; i < 4; i++)//4 enemy2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 126:
                        for (int i = 0; i < 8; i++) //4 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - (screen.hudWidth * width) - .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 134:
                        for (int i = 0; i < 1; i++)//Enemy 5 at center
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = (-(screen.hudWidth * width) / 2);

                            GameObject enemy = Instantiate(Enemy5, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType5>().player = player;
                            enemy.GetComponent<EnemyType5>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 138:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 142:
                        for (int i = 0; i < 2; i++)//2 enemy 2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)//2 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 146:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 150:
                        for (int i = 0; i < 2; i++)//2 enemy 2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 2; i++)//2 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 155:
                    case 156:
                    case 157:
                    case 158:
                    case 159:
                    case 160:
                        for (int i = 0; i < 1; i++)//1 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 164:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down wide
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i*2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 168:
                        for (int i = 0; i < 8; i++) //8 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - (screen.hudWidth * width) - .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 8; i++) //8 Enemy1 from right
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = (width / 2) - (screen.hudWidth * width) - .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((-width / 2) + .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 174:
                        for (int i = -1; i < 2; i+=2)//2 Enemy 3
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2)) + i;

                            GameObject enemy = Instantiate(Enemy3, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType3>().player = player;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 182:
                    case 183:
                    case 184:
                    case 185:
                    case 186:
                    case 188:
                        for (int i = 0; i < 1; i++)//1 enemy2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 196:
                        for (int i = 0; i < 1; i++)//Enemy 5 at right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) - 1);

                            GameObject enemy = Instantiate(Enemy5, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType5>().player = player;
                            enemy.GetComponent<EnemyType5>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 198:
                        for (int i = 0; i < 8; i++) //8 Enemy1 from left
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = -width / 2 + .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((width / 2) - (screen.hudWidth * width) - .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 204:
                        for (int i = 0; i < 1; i++)// Enemy 3 at right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) - 1);

                            GameObject enemy = Instantiate(Enemy3, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType3>().player = player;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 210:
                    case 212:
                    case 214:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 218:
                    case 219:
                    case 220:
                    case 221:
                        for (int i = 0; i < 1; i++)//1 enemy2 from right
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = width / 2 - (screen.hudWidth * width) - .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        for (int i = 0; i < 1; i++)//1 enemy 2 from left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + i;
                            spawnPos.x = -width / 2 + .5f;

                            GameObject enemy = Instantiate(Enemy2, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType2>().player = player;
                            enemy.GetComponent<EnemyType2>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 226:
                        for (int i = -1; i < 2; i+=2)//2 Enemy 5
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) - i);

                            GameObject enemy = Instantiate(Enemy5, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType5>().player = player;
                            enemy.GetComponent<EnemyType5>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 230:
                        for (int i = 0; i < 8; i++) //8 Enemy1 from right
                        {
                            Vector3 spawnPos = Vector3.zero;
                            Vector3 anchorPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1 + (.7f * i);
                            spawnPos.x = (width / 2) - (screen.hudWidth * width) - .5f;

                            anchorPos.y = (height / 2) - ((height / 5) * 2);
                            anchorPos.x = ((-width / 2) + .5f);

                            GameObject enemy = Instantiate(Enemy1, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType1>().swingPoint = anchorPos;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 234:
                        for (int i = 0; i < 1; i++)// Enemy 3 at left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + 1);

                            GameObject enemy = Instantiate(Enemy3, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType3>().player = player;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 240:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down wide
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i * 2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 243:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 246:
                        for (int i = 0; i < 1; i++)//Enemy 4 down center
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = (-(screen.hudWidth * width) / 2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 250:
                        for (int i = 0; i < 1; i++)//Enemy 5 at left
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + 1);

                            GameObject enemy = Instantiate(Enemy5, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<EnemyType5>().player = player;
                            enemy.GetComponent<EnemyType5>().screen = screen;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 253:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 256:
                        for (int i = -1; i < 2; i += 2)//2 Enemy 4 down wide
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = ((-(screen.hudWidth * width) / 2) + i * 2);

                            GameObject enemy = Instantiate(Enemy4, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                    case 270: //boss
                        for (int i = 0; i<1; i++)
                        {
                            Vector3 spawnPos = Vector3.zero;

                            spawnPos.y = (height / 2) + 1;
                            spawnPos.x = -((screen.hudWidth * width) / 2);

                            GameObject enemy = Instantiate(Boss, spawnPos, Quaternion.identity, transform);
                            enemy.GetComponent<Boss>().player = player;
                            enemy.GetComponent<Boss>().screen = screen;
                            enemy.GetComponent<Boss>().explosion = Explosion;
                            enemy.GetComponent<Boss>().col = collisionManager;
                            enemy.GetComponent<Enemy>().collisionManager = collisionManager;
                            enemy.GetComponent<Enemy>().bulletBankManager = bulletBankManager;
                            enemy.transform.position = spawnPos;
                            collisionManager.AddEnemy(enemy);
                        }
                        break;
                }
            }
        }
    }

    public void Begin()
    {
        start = true;
    }
}
