using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwayFromPlayer : MonoBehaviour
{
    public Transform player;
    public float viewingReach = 10;
    public int zPos = -10;

    void Update()
    {
        CamerMov();
    }

    void CamerMov()
    {
        Vector3 mousePosition = Input.mousePosition;
        mousePosition = Camera.main.ScreenToWorldPoint(mousePosition);

        Vector3 dir = new Vector3 (
            mousePosition.x - player.position.x,
            mousePosition.y - player.position.y,
            0f
        );

        transform.position = new Vector3(player.position.x + dir.normalized.x* viewingReach,player.position.y + dir.normalized.y* viewingReach,zPos) ;
    }
}
