using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CoralInfo : MonoBehaviour
{
    public GameObject coralObject;
    private Vector2Int colRow;
    private Vector2 coralPosition;
    public GameObject [] drops;

    private float tileSize;
    private char facingDirection;
    public int startCoralHealth;
    private int coralHealth;

    private GameObject toOpenCounter; 

    private string sceneName;

    void Start()
    {
        
        startCoralHealth += Random.Range(-7,7);
        coralHealth = startCoralHealth;

        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        if(!sceneName.Equals("Menu"))
        {
            GameObject activateBlock = GameObject.FindWithTag("Stats");
            activateBlock.GetComponent<ActivateBlocks>().AddTodeactivatedLists(this.gameObject,GridObjectEnum.Coral1);
            this.gameObject.active = false;
            coralObject = this.gameObject;
            coralPosition = coralObject.transform.position; 
            tileSize = GridManagerStats.Instance.tileSize;
            PutThisCoralIntoGrid();
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

    private void ParticleEffect()
    {
        GameObject particles = (GameObject) Instantiate(Resources.Load("Particles/AllDestroy"));
        Sprite _newSprite = gameObject.GetComponent<SpriteRenderer>().sprite;
        ParticleSystem _particles = particles.GetComponent<ParticleSystem>();
        _particles.textureSheetAnimation.SetSprite(0,_newSprite);
        particles.transform.position = this.transform.position;
        Destroy(particles,1);
    }

    private void DestoryCoral()
    {
        ParticleEffect();
        ChangeGridValueWhereTheCoralWas(colRow);
        DropIndividualItem();
        Destroy(this.gameObject);
    }

    public void ChangeGridValueWhereTheCoralWas(Vector2Int _oralColRow)
        {
            GridObjectEnum _coralCountAtGridPosition = GridManagerStats.Instance.grid[_oralColRow.x,_oralColRow.y];

            switch(_coralCountAtGridPosition)
            {
                case GridObjectEnum.Coral1:
                    GridManagerStats.Instance.grid[_oralColRow.x,_oralColRow.y] = GridObjectEnum.Air;
                break;
                case GridObjectEnum.Coral2:
                    GridManagerStats.Instance.grid[_oralColRow.x,_oralColRow.y] = GridObjectEnum.Coral1;
                break;
                case GridObjectEnum.Coral3:
                    GridManagerStats.Instance.grid[_oralColRow.x,_oralColRow.y] = GridObjectEnum.Coral2;
                break;
                case GridObjectEnum.Coral4:
                    GridManagerStats.Instance.grid[_oralColRow.x,_oralColRow.y] = GridObjectEnum.Coral3;
                break;
            }
        }

    private void PutThisCoralIntoGrid()
    {
        switch(facingDirection)
        {
            case 't':
                colRow.x = (int) Mathf.Ceil(coralPosition.x/tileSize);
                colRow.y = (int) Mathf.Floor(-coralPosition.y/tileSize);
                HowManyCoralsAreInTheGridPosition(GridManagerStats.Instance.grid[colRow.x,colRow.y]);  
            break;
                case 'r':
                colRow.x = (int) Mathf.Ceil(coralPosition.x/tileSize);
                colRow.y = (int) Mathf.Ceil(-coralPosition.y/tileSize);
                HowManyCoralsAreInTheGridPosition(GridManagerStats.Instance.grid[colRow.x,colRow.y]);
            break;
            case 'b':
                colRow.x = (int) Mathf.Ceil(coralPosition.x/tileSize);                   
                colRow.y = (int) Mathf.Ceil(-coralPosition.y/tileSize);
                HowManyCoralsAreInTheGridPosition(GridManagerStats.Instance.grid[colRow.x,colRow.y]);
            break;
            case 'l':
                colRow.x = (int) Mathf.Floor(coralPosition.x/tileSize);                   
                colRow.y = (int) Mathf.Ceil(-coralPosition.y/tileSize);
                HowManyCoralsAreInTheGridPosition(GridManagerStats.Instance.grid[colRow.x,colRow.y]);
            break;
        }

    }

    private void HowManyCoralsAreInTheGridPosition(GridObjectEnum _coralInQuestion)
    {
        switch(_coralInQuestion)
            {
            case GridObjectEnum.Coral1:
                GridManagerStats.Instance.grid[colRow.x,colRow.y] = GridObjectEnum.Coral2;
            break;
            case GridObjectEnum.Coral2:
                GridManagerStats.Instance.grid[colRow.x,colRow.y] = GridObjectEnum.Coral3;
            break;
            case GridObjectEnum.Coral3:
                GridManagerStats.Instance.grid[colRow.x,colRow.y] = GridObjectEnum.Coral4;
            break;
            default:
                GridManagerStats.Instance.grid[colRow.x,colRow.y] = GridObjectEnum.Coral1;
            break;
        }
    }

    private void DropIndividualItem()
    {
        GameObject coralDrop = (GameObject) Instantiate(Resources.Load("Drops/CoralPiece"));
        coralDrop.GetComponent<CoralPieceBehaviour>().SetSprite(this.gameObject.GetComponent<SpriteRenderer>().sprite);
        coralDrop.GetComponent<CoralPieceBehaviour>().SetValues(startCoralHealth);
        coralDrop.transform.position = this.transform.position;
    }

    IEnumerator IsBeingOpened()
    {
        if(toOpenCounter == null)
        {
            toOpenCounter = (GameObject) Instantiate(Resources.Load("Indicator/Counter"));
        }
        toOpenCounter.GetComponent<Counter>().SetPosition((Vector2) this.transform.position);
        toOpenCounter.GetComponent<Counter>().SetValues(startCoralHealth,coralHealth); 
        yield return new WaitForSeconds(1);
        Destroy(toOpenCounter);
    }

    public void Breakdown(int _coralDamage)
    {

        
        StopCoroutine("IsBeingOpened");
        coralHealth -= _coralDamage;

        

        if(coralHealth <= 0)
        {
            DestoryCoral();
            Destroy(toOpenCounter);
        }else
        {
            StartCoroutine("IsBeingOpened");
        }
    }
}
