using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackSize : MonoBehaviour
{
    private float tileSize;
    private int cols;
    private int rows;
    

    // Start is called before the first frame update
    void Start()
    {
        tileSize = GridManagerStats.Instance.tileSize;
        cols = GridManagerStats.Instance.cols;
        rows = GridManagerStats.Instance.rows;

        this.transform.position = new Vector2(tileSize * (cols-1)/2,tileSize*(-(rows-1f)/2));
        this.transform.localScale = new Vector2(tileSize*(cols-2),tileSize/100*rows);
    }
}
