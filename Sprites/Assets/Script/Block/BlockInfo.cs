using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlockInfo : MonoBehaviour
{
    public Color damageColor;
    public int startHealth = 100;
    private int blockHealth;
    private int index;
    public int tier = -1;
    private Vector2Int colRow;

    public GridObjectEnum thisObject;
    public bool standardBlockSpriteActive = false;
    public Sprite[] standardBlockSprite;
    public bool specialCornerSpriteActive = false;
    public Sprite[] specialCornerSprite;

    public Sprite[] allSidesVariation;
    private Sprite[] folderObjects;

    private GameObject healthBar;
    private bool beingDamaged = false;

    void Start()
    {
        GameObject activateBlock = GameObject.FindWithTag("Stats");
        activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,thisObject);
        this.gameObject.active = false;
        blockHealth = startHealth;
        UpdateBlockSprite();
    }

    private bool PlayerStartAreaBlock(Vector2 _colRow)
    {
        bool _output = false;
        int gridWidth = GridManagerStats.Instance.cols;
        int gridWidthHalf = (int) gridWidth/2;
        for(int i = gridWidthHalf-2;i < gridWidthHalf+2;i++)
        {
            if(_colRow == new Vector2(i,0))
            {
                _output = true;
            }
        }
        return _output;
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

    private void DestroyBlock()
    {
        ParticleEffect();
        BlockClassScript blockClass = GameObject.FindGameObjectWithTag("BlockClass").GetComponent<BlockClassScript>();
        blockClass.cells[index].DestroyBlock();
    }

    public void Breakdown(int _blockDamage)   // the breakdown of the block
    {
        StopCoroutine("IsBeingDamaged");
        blockHealth -= _blockDamage;
        if(healthBar == null)
        {
            healthBar = (GameObject) Instantiate(Resources.Load("Indicator/BlockHealth"));
        }
        healthBar.GetComponent<HealthBar>().SetPosition((Vector2) this.transform.position);
        healthBar.GetComponent<HealthBar>().SetValues(startHealth, blockHealth);

        if(blockHealth <= 0)
        {
            Destroy(healthBar);
            DestroyBlock();
        }else
        {
            GameObject goldPopupGameObject = (GameObject) Instantiate(Resources.Load("Particles/GoldPopup"));
            GoldPopup goldPopup = goldPopupGameObject.GetComponent<GoldPopup>();
            goldPopup.SetPosition(this.transform.position);
            goldPopup.SetVelocity(RandomUpwardsUnitVector()*2);
            goldPopup.SetAmount((int) _blockDamage);
            goldPopup.SetColor(damageColor);
            StartCoroutine("IsBeingDamaged");
        }
    }

    public Vector2 RandomUpwardsUnitVector()
    {
        float random = Random.Range(0.4f* Mathf.PI, 0.6f * Mathf.PI);
        return new Vector2(Mathf.Cos(random), Mathf.Sin(random));
    }

    IEnumerator IsBeingDamaged()
    {
        yield return new WaitForSeconds(1);
        Destroy(healthBar);
    }

    public void BlockToStrong()
    {
        StopCoroutine("IsBeingDamaged");
        if(healthBar == null)
        {
            healthBar = (GameObject) Instantiate(Resources.Load("Indicator/BlockHealth"));
        }
        healthBar.GetComponent<HealthBar>().SetPosition((Vector2) this.transform.position);
        healthBar.GetComponent<HealthBar>().ToHighTier();
        StartCoroutine("IsBeingDamaged");
    }

    public void UpdateBlockSprite()
    {
        if(standardBlockSpriteActive)
        {
            string blockSides = GridManagerStats.Instance.WhatSidesAreBlocks((int)colRow.x,(int)colRow.y,thisObject);
            
            switch(blockSides)
            {
                case "":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[0];
                break;
                case "t":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[8];
                break;
                case "r":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[4];
                break;
                case "d":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[1];
                break;
                case "l":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[3];
                break;
                case "tr":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[12];
                break;
                case "td":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[9];
                break;
                case "tl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[11];
                break;
                case "rd":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[5];
                break;
                case "rl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[7];
                break;
                case "dl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[2];
                break;
                case "trd":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[13];
                break;
                case "trl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[14];
                break;
                case "tdl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[10];
                break;
                case "rdl":
                    this.GetComponent<SpriteRenderer>().sprite = standardBlockSprite[6];
                break;
                case "trdl":
                    if(specialCornerSpriteActive)
                    {
                        string blockCorner = GridManagerStats.Instance.WhatCornersAreBlocks((int)colRow.x,(int)colRow.y,thisObject);
                        switch(blockCorner)
                        {
                            case "234":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[0];
                            break;
                            case "134":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[1];
                            break;
                            case "124":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[2];
                            break;
                            case "123":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[3];
                            break;
                            case "34":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[4];
                            break;
                            case "24":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[5];
                            break;
                            case "23":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[6];
                            break;
                            case "14":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[7];
                            break;
                            case "13":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[8];
                            break;
                            case "12":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[9];
                            break;
                            case "4":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[10];
                            break;
                            case "3":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[11];
                            break;
                            case "2":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[12];
                            break;
                            case "1":
                                this.GetComponent<SpriteRenderer>().sprite = specialCornerSprite[13];
                            break;
                            case "1234":
                                int variation = Random.Range(0,allSidesVariation.Length);
                                this.GetComponent<SpriteRenderer>().sprite = allSidesVariation[variation];
                            break;
                        }
                    }else{
                        int variation = Random.Range(0,allSidesVariation.Length);
                        this.GetComponent<SpriteRenderer>().sprite = allSidesVariation[variation];
                    }
                break;
            }
        }
    }

    public void SetIndex(int _index)    // getting the Index of this block in the BlockClass script
    {
        index = _index;
    }

        public int GetTier()
    {
        return tier;
    }

    public void SetTier(int _tier)
    {
        tier = _tier;
    }

    public void SetGridPosition(Vector2Int _colRow)
    {
        colRow = _colRow;
    }
}
