using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DropBehaviourFromBlock : MonoBehaviour
{
    private float dropSize = 0.2f;
    private string playerTag = "Player";
    private float distantToSeekPlayer = 1.5f;
    private float dropSpeed = 0.5f;
    private float timeIntervalLookingForPlayer = 1f;
    private int thisDropValue;
    
    private new GridObjectEnum name; 
    private GameObject target;

    void Start()
    {
        transform.localScale = transform.localScale * dropSize;     // transforms the blockdrop so its smaller
        Destroy(this.gameObject,15f);
    }

    void Update()
    {
        if(target != null)
        {
            Seek();
        }  
    }

    public void GetInfo(GridObjectEnum _name, int _value)
    {
        name = _name;
        thisDropValue = _value;
    }

    void OnCollisionEnter2D(Collision2D collisionInfo)
    {
        if(collisionInfo.gameObject.CompareTag(playerTag)){ 
            PlayerStats.Instance.AddGold(thisDropValue);
            Destroy(this.gameObject);
        }
    }

    public void SetTarget(GameObject _target)
    {
        target = _target;
    }

    public void ResetTarget()
    {
        target = null;
    }

    private void Seek()
    {
        Vector2 dirToPlayer = target.transform.position - transform.position;
        float distanceThisFrame = dropSpeed * Time.deltaTime;
        transform.Translate ( dirToPlayer.normalized * distanceThisFrame, Space.World);  
    }
}
