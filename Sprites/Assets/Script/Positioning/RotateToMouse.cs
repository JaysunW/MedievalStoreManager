using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateToMouse : MonoBehaviour
{
    public Transform playerTransform;
    public GameObject player;

     private void FixedUpdate()
     {
        Vector3 difference = Camera.main.ScreenToWorldPoint(Input.mousePosition) - transform.position;

        difference.Normalize();
        
        float rotationZ = Mathf.Atan2(difference.y, difference.x)* Mathf.Rad2Deg;

        transform.rotation =  Quaternion.Euler(0f,0f,rotationZ);

        if(rotationZ < -90 || rotationZ > 90)
        {
            if(player.transform.eulerAngles.y == 0)
            {
                transform.localRotation = Quaternion.Euler(180,0,-rotationZ);
            }
            else if(player.transform.eulerAngles.y == 180)
            {
                transform.localRotation = Quaternion.Euler(180,180,-rotationZ);
            }
        }
     }
 
    float AngleBetweenTwoPoints(Vector3 a, Vector3 b) {
         return Mathf.Atan2(a.y - b.y, a.x - b.x) * Mathf.Rad2Deg;
    }
}
