using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackAirPosition : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;
        this.transform.position = new Vector2(gridWidthHalf-0.5f,2.5f);
        float backAirWidth = gridWidth/100f;
        this.transform.localScale = new Vector3(1f * backAirWidth +0.2f,1.2f,1);
    }
}
