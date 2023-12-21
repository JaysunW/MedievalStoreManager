using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCameraToPlayer : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        Transform playerTF = player.GetComponent<Transform>();
        this.transform.position = new Vector3 (playerTF.position.x,playerTF.position.y,this.transform.position.z);
    }
}
