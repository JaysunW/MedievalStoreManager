using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hook : MonoBehaviour
{
    public GameObject player;
    private Transform playerTF;
    public GameObject ship;
    private Transform shipTF;

    void Start()
    {

        playerTF = player.GetComponent<Transform>();
        shipTF = ship.GetComponent<Transform>();
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;

        if(PlayerToShipDistance() <= 12)
        {
            this.transform.position = shipTF.position;
        }else
        {
            this.transform.position = CalculateNewHookPos();
        }
    }

    private Vector2 CalculateNewHookPos()
    {
        Vector2 playerShipDistance = (Vector2) (playerTF.position - shipTF.position);
        int intDistance = (int) playerShipDistance.magnitude;
        return (Vector2) shipTF.position + playerShipDistance.normalized * (intDistance - 10);
    }

    private int PlayerToShipDistance()
    {
        int _output = (int) (playerTF.position - shipTF.position).magnitude;
        return _output;
    }
}
