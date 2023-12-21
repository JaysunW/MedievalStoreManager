using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Chest : MonoBehaviour
{
    public Sprite openSprite;
    public ChestEnum chestName;

    private int treasure;
    private bool treasureInChest= true;
    public float startTreasure = 1000;
    public float moneyForWood = 1000;
    public float goldMultiplier = 1;

    private int startHitsTillOpening;
    public int hitsTillOpening;
    private int startHitsTillDestroyed;
    public int hitsTillDestroyed = 10;
    
    private bool opened = false;

    private GameObject toOpenCounter;

    private string sceneName;

    void Start()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        if(!sceneName.Equals("Menu"))
        {
            GameObject activateBlock = GameObject.FindWithTag("Stats");
            activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,GridObjectEnum.Chest1);
            this.gameObject.active = false;
            startHitsTillOpening = hitsTillOpening;
            startHitsTillDestroyed = hitsTillDestroyed;
            TreasureCalculation();
            HitTillOpenCalculation();
        }
    }

    private void TreasureCalculation()
    {
        float _treasure = (Random.Range(startTreasure/2,startTreasure) + startTreasure) * goldMultiplier;
        treasure = (int) _treasure;
    }

    private void HitTillOpenCalculation()
    {
        float _tillOpen = Random.Range(10,15)*goldMultiplier;
        hitsTillOpening = (int) _tillOpen;
    }

    IEnumerator IsBeingOpened()
    {
        yield return new WaitForSeconds(1);
        Destroy(toOpenCounter);
    }

    public void Breakdown(int _damage)
    {
        if(!opened)
        {
            StopCoroutine("IsBeingOpened");
            hitsTillOpening -= _damage; 

            if(toOpenCounter == null)
            {
                toOpenCounter = (GameObject) Instantiate(Resources.Load("Indicator/Counter"));
            }
            toOpenCounter.GetComponent<Counter>().SetPosition((Vector2) this.transform.position);
            toOpenCounter.GetComponent<Counter>().SetValues(startHitsTillOpening, hitsTillOpening);  


            if(hitsTillOpening <= 0)
            {   
                opened = true;
                this.GetComponent<SpriteRenderer>().sprite = openSprite;
                Destroy(toOpenCounter);
            }else
            {
                StartCoroutine("IsBeingOpened");
            }
        }else{
            StopCoroutine("IsBeingOpened");
            hitsTillDestroyed -= _damage;

            if(toOpenCounter == null)
            {
                toOpenCounter = (GameObject) Instantiate(Resources.Load("Indicator/Counter"));
            }
            toOpenCounter.GetComponent<Counter>().SetPosition((Vector2) this.transform.position);
            toOpenCounter.GetComponent<Counter>().SetValues(startHitsTillDestroyed, hitsTillDestroyed); 

            if(hitsTillDestroyed <= 0)
            {   
                Destroy(toOpenCounter);
                DestroyChest();
            }else
            {
                StartCoroutine("IsBeingOpened");
            }
        }
    }

    private void ParticleEffect()
    {
        GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/AllDestroy"));
        Sprite _newSprite = gameObject.GetComponent<SpriteRenderer>().sprite;
        ParticleSystem _particles = particles.GetComponent<ParticleSystem>();
        _particles.textureSheetAnimation.SetSprite(0,_newSprite);
        particles.transform.position = this.transform.position;
        Destroy(particles,2);
    }

    public void DestroyChest()
    {
        ParticleEffect();
        PlayerStats.Instance.AddGold(moneyForWood + Random.Range(0,moneyForWood)*goldMultiplier);
        Destroy(this.gameObject);
    }

    public void TakeTreasureFromChest()
    {
        if(treasureInChest && opened)
        {
            PlayerStats.Instance.AddGold(treasure);
            treasureInChest = false;
        }
    }
}
