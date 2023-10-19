using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LivesManager : MonoBehaviour
{
    [SerializeField]
    GameObject lifeCounter;

    [SerializeField]
    HUDManager hud;

    private static int MAX_LIVES = 5;

    private int lives = 5;

    [SerializeField]
    private List<GameObject> livesStack = new List<GameObject>();

    public void DecreaseLife()
    {
        lives--;

        for (int i = 0; i < lives; i++)
        {
            livesStack[i].SetActive(true);
        }
        for (int i = lives; i< MAX_LIVES; i++)
        {
            livesStack[i].SetActive(false);
        }
    }
}
