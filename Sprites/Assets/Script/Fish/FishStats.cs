using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FishStats : MonoBehaviour
{
    private Rigidbody2D rb2D;

    private GridObjectEnum type;
    public SpriteRenderer spriteRenderer;
    public FishBehaviour fishBehaviour;

    private int index;
    public int speed;
    public int tier;
    public int startHealth;
    public int health;
    private int HowOftenTillCaught = 8;
    public int HowOftenTillCaughtMin = 1;
    public int HowOftenTillCaughtMax = 10;

    bool interactWithPlayer;

    public Fish [] fish;
    private FishNameEnum fishName;
    private int indexForBackPack = 0;

    private string sceneName;

    private void Start()
    {
        HowOftenTillCaught = Random.Range(HowOftenTillCaughtMin,HowOftenTillCaughtMax);
        WhichFishIsIt();
        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        if(!sceneName.Equals("Menu"))
        {
            GameObject activateBlock = GameObject.FindWithTag("Stats");
            activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,type);
            rb2D = this.gameObject.GetComponent<Rigidbody2D>();
            this.gameObject.active = false;
        }else
        {
            StartCoroutine("MenuIdle");
        }
    }

    private IEnumerator MenuIdle()
    {
        while(true)
        {
            fishBehaviour.SetFishState(FishStatesEnum.IdleAround);
            yield return new WaitForSeconds(Random.Range(4,24));
        }
    }

    public void WhichFishIsIt()
    {
        if(fish.Length > 0)
        {
            int random = (int) Random.Range(1,101);
            Sprite newSprite = null;
            int firstBorder = 0;
            int secondBorder = fish[0].chanceToSpawn;
            for(int i = 0; i < fish.Length; i++)
            {
                if(random >= firstBorder && random < secondBorder)
                {
                    indexForBackPack = i;
                }
                firstBorder = secondBorder;
                if(i != fish.Length-1)
                secondBorder += fish[i+1].chanceToSpawn;
            }

            newSprite = fish[indexForBackPack].sprite;
            fishName = fish[indexForBackPack].fishName;
            speed += fish[indexForBackPack].speedChange;
            SetHealth(startHealth += fish[indexForBackPack].healthChange);
            fishBehaviour.SetAggression(fish[indexForBackPack].aggressive);
            fishBehaviour.SetDamage(fish[indexForBackPack].damage);
        
            spriteRenderer.sprite = newSprite;
        }
    }

    public void SetType(GridObjectEnum _type)
    {
        type = _type;
    }

    public GridObjectEnum GetType()
    {
        return type;
    }

    public void SetIndex(int _index)
    {
        index = _index;
    }

    public void SetSpeed(int _speed)
    {
        speed = _speed;
    }

    public int GetSpeed()
    {
        return speed;
    }  

    public void SetHealth(int _health)
    {
        startHealth = _health; 
        health = _health;
    }

    public void SetTier(int _tier)
    {
        tier = _tier;
    }

    public int GetTier()
    {
        return tier;
    }    

    public void FishCaught(int _tier)
    {
        if(_tier >= tier)
        {
            HowOftenTillCaught -= _tier+1;
            if(HowOftenTillCaught < 0)
            {
                GameObject caughtParticles = (GameObject) Instantiate(Resources.Load("Particles/CaughtFishParticles"));
                caughtParticles.transform.position = this.transform.position;
                Destroy(caughtParticles,1);
                FishGotCaught();
            }else
            {
                GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/BubbleParticles"));
                particles.transform.position = this.transform.position;
                Destroy(particles,1);
            }
        }else
        {
            FishTierIndicator.Instance.SetIndicator();
        }
    }

    public void FishDamaged(int _damage)
    {
        GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/Blood"));
        particles.transform.position = this.transform.position;
        Destroy(particles,1);

        if(fishBehaviour.GetAggression())
        {
            fishBehaviour.SetObjectToFollow(GameObject.FindWithTag("Player"),5);
            fishBehaviour.SetFishState(FishStatesEnum.IdleAroundPLayer);
        }

        health -= _damage;
        FishLife.Instance.SetValues(startHealth,health);
        IsFishDead();
    }

    private void FishGotCaught()
    {
        PlayerBackpack.Instance.AddFish(type, fish[indexForBackPack]);
        FishClassScript fishClass = GameObject.FindGameObjectWithTag("FishClass").GetComponent<FishClassScript>();
        fishClass.fishes[index].FishGotCaught();
    }

    private void IsFishDead()
    {
        if(health <= 0)
        {
            FishClassScript fishClass = GameObject.FindGameObjectWithTag("FishClass").GetComponent<FishClassScript>();
            fishClass.fishes[index].FishGotKilled();
        }
    }

    public bool ChanceInAHundred(float _chanceToHit)
    {
        float _objectChance = Random.Range(0,100f);
        if(_objectChance < _chanceToHit){
            return true;
        }
        return false;
    }
}