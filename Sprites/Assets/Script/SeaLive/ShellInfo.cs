using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ShellInfo : MonoBehaviour
{
    private GameObject shellObject;
    private Vector2Int colRow;
    private Vector2 shellPosition;

    public ShellSpriteValue [] spriteValue;

    private float tileSize;
    private char facingDirection;
    public int hitsTillOpening;
    private int startHitsTillOpening;

    public int minToOpen;
    public int maxToOpen;

    public int valueDifference;

    private bool isShellOpen;
    
    private GameObject toOpenCounter;

    private int shellIndex;

    private string sceneName;
    private void Start()
    {
        DecideWhichSprite();

        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        if(!sceneName.Equals("Menu"))
        {
            GameObject activateBlock = GameObject.FindWithTag("Stats");
            activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,GridObjectEnum.Shell1);
            this.gameObject.active = false;
            startHitsTillOpening = Random.Range(minToOpen,maxToOpen);
            hitsTillOpening = startHitsTillOpening;
            shellObject = this.gameObject;
            shellPosition = shellObject.transform.position; 
            tileSize = GridManagerStats.Instance.tileSize;
        }
    }

    public void DecideWhichSprite()
    {
        if(spriteValue.Length > 0)
        {
            int random = (int) Random.Range(0,220);
            Sprite newSprite = null;
            float firstBorder = 0;
            float secondBorder = spriteValue[0].chanceToSpawn;
            for(int i = 0; i < spriteValue.Length; i++)
            {
                if(random >= firstBorder && random < secondBorder)
                {
                    newSprite = spriteValue[i].sprite;
                    shellIndex = i;
                }
                firstBorder = secondBorder;
                if(i != spriteValue.Length-1)
                secondBorder += spriteValue[i+1].chanceToSpawn;
            }

            if(newSprite == null)
            {
                newSprite = spriteValue[0].sprite;
                shellIndex = 0;
            }
            
            this.GetComponent<SpriteRenderer>().sprite = newSprite;
        }
    }

    public Vector2Int GetColRow()
    {
        return colRow;
    }

    public void SetInfos(char _facingDirection)
    {
        facingDirection = _facingDirection;
    }

    private void DropIndividualItem()
    {
        GameObject pearl = (GameObject) Instantiate(Resources.Load("Pearl"));
        pearl.GetComponent<PearlBehaviour>().SetValues(startHitsTillOpening*valueDifference);
        pearl.transform.position = this.transform.position;
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

    private void Open()
    {
        ParticleEffect();
        DropIndividualItem();
        Destroy(this.gameObject);
    }

    IEnumerator IsBeingOpened()
    {
        if(toOpenCounter == null)
        {
            toOpenCounter = (GameObject) Instantiate(Resources.Load("Indicator/Counter"));
        }
        toOpenCounter.GetComponent<Counter>().SetPosition((Vector2) this.transform.position);
        toOpenCounter.GetComponent<Counter>().SetValues(startHitsTillOpening, hitsTillOpening); 
        yield return new WaitForSeconds(1);
        Destroy(toOpenCounter);
    }

    public void Breakdown(int _knifeMk)
    {
        if(!isShellOpen)
        {
            StopCoroutine("IsBeingOpened");
            hitsTillOpening -= _knifeMk;

            if(hitsTillOpening <= 0)
            {
                isShellOpen = true;
                Open();
                Destroy(toOpenCounter);
            }else
            {
                StartCoroutine("IsBeingOpened");
            }

        }
    }
}
