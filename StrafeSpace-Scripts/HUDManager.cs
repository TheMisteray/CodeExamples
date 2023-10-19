using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class HUDManager : MonoBehaviour
{
    public float score = 0;
    public float playerHealth = 3;
    public float power = 1;

    [SerializeField]
    TextMeshProUGUI scoreLabel;

    [SerializeField]
    TextMeshProUGUI powerLabel;

    [SerializeField]
    TextMeshProUGUI victoryLabel;
    [SerializeField]
    TextMeshProUGUI defeatLabel;

    [SerializeField]
    GameObject buttonStart;
    [SerializeField]
    GameObject buttonEasy;

    [SerializeField]
    Slider healthBar;

    [SerializeField]
    RectTransform hudDimensions;

    public float hudWidth
    {        
        get { return hudDimensions.anchorMax.x - hudDimensions.anchorMin.x; }
    }

    // Update is called once per frame
    void Update()
    {
        scoreLabel.text = "Score: " + score.ToString("000000000");
        powerLabel.text = "Power: " + power.ToString("0.00");
    }

    public void Victory()
    {
        Camera cam = Camera.main;
        float height = 2f * cam.orthographicSize;
        float width = height * cam.aspect;
        victoryLabel.transform.position = new Vector3(-hudWidth / 2 * width, -.2f, 0);
    }

    public void Defeat()
    {
        Camera cam = Camera.main;
        float height = 2f * cam.orthographicSize;
        float width = height * cam.aspect;
        defeatLabel.transform.position = new Vector3(-hudWidth / 2 * width, -.2f, 0);
    }

    public void Begin()
    {
        buttonStart.transform.position = new Vector3(0, 300, 0);
        buttonEasy.transform.position = new Vector3(0, 300, 0);
    }
}
