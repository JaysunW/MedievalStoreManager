using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoralPieceBehaviour : MonoBehaviour
{
    private float dropSize = 0.4f;
    private string playerTag = "Player";
    private float distantToSeekPlayer = 1.5f;
    private float dropSpeed = 0.3f;
    private float timeIntervalLookingForPlayer = 1f;
    private int thisDropValue;

    public int minValue = 300;
    public int maxValue = 500;

    private GameObject target;

    void Start()
    {
        transform.localScale = transform.localScale * dropSize;     // transforms the blockdrop so its smaller
        Destroy(this.gameObject,15f);
    }

    public void SetSprite(Sprite _input)
    {
        this.gameObject.GetComponent<SpriteRenderer>().sprite = _input;
    }

    public void SetValues(int _dividerInput)
    {   
        minValue = minValue * _dividerInput;
        maxValue = maxValue * _dividerInput;
        thisDropValue = Random.Range((int) minValue,(int) maxValue);
    }

    void Update()
    {
        if(target != null)
        {
            Seek();
        }  
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

