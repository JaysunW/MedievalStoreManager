using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeekRange : MonoBehaviour
{
    public GameObject gameObject;


    void OnTriggerEnter2D(Collider2D other) {
        if (other.tag == "Player")
        {
            gameObject.SendMessage("SetTarget",other.transform.gameObject);
        }
    }
    
    void OnTriggerExit2D(Collider2D other) {
        if (other.tag == "Player")
        {
            gameObject.SendMessage("ResetTarget");
        } 
    }
}
