using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HookRotation : MonoBehaviour
{

    public Transform playerTF; 
    public Transform hookTF; 

    // Start is called before the first frame update
    void Start()
    {
        ChangeRotation();
    }

    private void ChangeRotation()
    {
        //Get the Screen positions of the object
         Vector2 positionOnScreen = (Vector2) Camera.main.WorldToViewportPoint (hookTF.position);
         
         //Get the Screen position of the other object
         Vector2 objectOnScreen = (Vector2) Camera.main.WorldToViewportPoint (playerTF.position);
         
         //Get the angle between the points
         float angle = AngleBetweenTwoPoints(objectOnScreen, positionOnScreen);
 
         //Ta Daaa
         transform.rotation = Quaternion.Euler (new Vector3(0f,0f,angle));
    }

    float AngleBetweenTwoPoints(Vector3 a, Vector3 b) {
        return Mathf.Atan2(a.y - b.y, a.x - b.x) * Mathf.Rad2Deg;
    }
}
