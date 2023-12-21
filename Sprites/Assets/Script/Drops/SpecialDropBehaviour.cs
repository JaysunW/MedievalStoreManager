using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpecialDropBehaviour : MonoBehaviour
{
    public float dropSize = 0.1f;
    private float dropSpeed = 0.5f;
    private string playerTag = "Player";
    private float distantToSeekPlayer = 1f;
    private float timeIntervalLookingForPlayer = 1f;

    public Gemstones [] gemstone;
    private int gemstoneIndex;
    public GemstoneNameEnum gemstoneName;

    public new SpecialDropEnum name; 
    private GameObject target;

    void Start()
    {
        DecideWhichGemstone();
        transform.localScale = transform.localScale * dropSize;     // transforms the blockdrop so its smaller
        Destroy(this.gameObject,10f);
    }

    void Update()
    {
        if(target != null)
        {
            Seek();
        }  
    }

    public void DecideWhichGemstone()
    {
        if(gemstone.Length > 0)
        {
            int random = (int) Random.Range(1,101);
            Sprite newSprite = null;
            int firstBorder = 0;
            int secondBorder = gemstone[0].chanceToSpawn;
            for(int i = 0; i < gemstone.Length; i++)
            {
                if(random >= firstBorder && random < secondBorder)
                {
                    newSprite = gemstone[i].sprite;
                    gemstoneName = gemstone[i].gemstoneName;
                    gemstoneIndex = i;
                }
                firstBorder = secondBorder;
                if(i != gemstone.Length-1)
                secondBorder += gemstone[i+1].chanceToSpawn;
            }

            if(newSprite == null)
            {
                newSprite = gemstone[0].sprite;
                gemstoneName = gemstone[0].gemstoneName;
                gemstoneIndex = 0;
            }
            
            this.GetComponent<SpriteRenderer>().sprite = newSprite;
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

    private void OnCollisionEnter2D(Collision2D collisionInfo)
    {
        if(collisionInfo.collider.tag == playerTag){
            switch(name)
            {
                case SpecialDropEnum.Gem:
                    if(!PlayerBackpack.Instance.GetGemBackpackFull())
                    {
                        PlayerBackpack.Instance.AddGemstoneDropToBackpack(name,gemstone[gemstoneIndex]);
                        Destroy(this.gameObject);
                    }
                break;
                case SpecialDropEnum.Jewel:
                    if(!PlayerBackpack.Instance.GetJewelBackpackFull())
                    {
                        PlayerBackpack.Instance.AddGemstoneDropToBackpack(name,gemstone[gemstoneIndex]);
                        Destroy(this.gameObject);
                    }
                break;
            }
        }
    }

    private void Seek()
    {
        Vector2 dirToPlayer = target.transform.position - transform.position;
        float distanceThisFrame = dropSpeed * Time.deltaTime;
        transform.Translate ( dirToPlayer.normalized * distanceThisFrame, Space.World);  
    }
}
