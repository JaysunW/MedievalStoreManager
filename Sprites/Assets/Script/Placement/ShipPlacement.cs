using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipPlacement : MonoBehaviour
{

    public GameObject hook;
    public GameObject rope;

    void Start()
    {
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;
        this.transform.position = new Vector2(gridWidthHalf-0.5f,2.8f);
        SetShip();
        SetHook();
        SetRope();
    }

    void SetShip()
    {
        BackToTheShip.Instance.SetShip(this.gameObject);
    }

    void SetHook()
    {
        BackToTheShip.Instance.SetHook(hook);
    }

    void SetRope()
    {
        BackToTheShip.Instance.SetRope(rope);
    }
}
