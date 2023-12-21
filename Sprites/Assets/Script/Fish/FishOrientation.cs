using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FishOrientation : MonoBehaviour
{
    public Rigidbody2D fishRB;

    private void FixedUpdate()
    {
        Vector3 difference = fishRB.velocity;

        difference.Normalize();
        
        float rotationZ = Mathf.Atan2(difference.y, difference.x)* Mathf.Rad2Deg;

        transform.rotation =  Quaternion.Euler(0f,0f,rotationZ);

        if(rotationZ < 90 && rotationZ > -90)
        {
            this.transform.localRotation = Quaternion.Euler(180,0,-rotationZ);
        }
    }
 
    float AngleBetweenTwoPoints(Vector3 a, Vector3 b) {
         return Mathf.Atan2(a.y - b.y, a.x - b.x) * Mathf.Rad2Deg;
    }
}
