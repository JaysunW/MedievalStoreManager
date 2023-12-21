using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SecondaryWater : MonoBehaviour
{
    private float tileSize;
    private int cols;
    private int rows;
    
    void Start()
    {
        tileSize = GridManagerStats.Instance.tileSize;
        cols = GridManagerStats.Instance.cols;
        rows = GridManagerStats.Instance.rows;

        this.transform.position = new Vector2(tileSize * (cols-1)/2,tileSize * -0.25f);
        this.transform.localScale = new Vector2(tileSize * (cols-2),tileSize *1.5f);
    }
}
