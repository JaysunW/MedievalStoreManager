using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Player : MonoBehaviour
{
    public GoldUI goldUI;

    public Sprite [] costumes;
    public int costumeMK = 0;

    public int areaToInteractWithObjects = 2;
    private LayerMask chestMask = 1<<15;
    private string sceneName;

    public Transform pfGoldPopUp;

    void Start()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        sceneName = currentScene.name;
        PlayerBackpack.Instance.PopulateBackpackMaximums();
        PlayerStats.Instance.SetGoldUI(goldUI);
        PlayerStats.Instance.AddGold(0);
        PlayerStats.Instance.SetGameObjectPlayer(this.gameObject);
        ActivateBlocks.Instance.SetPlayer(this.gameObject);
        if(!sceneName.Equals("Shop"))
        {
            BackToTheShip.Instance.SetGameObjectPlayer(this.gameObject);
        }
        costumeMK = PlayerStats.Instance.GetCostumeMK();
    }

    public void UpdateCostume()
    {
        costumeMK = PlayerStats.Instance.GetCostumeMK();
    }

    void Update()
    {
        goldUI = GameObject.FindGameObjectWithTag("GoldUI").GetComponent<GoldUI>();
        // if(Input.GetKeyDown("q"))
        // {
        //     SceneManager.LoadScene("Level1");
        // }
        if(Input.GetKeyDown("t") && sceneName.Equals("Level1"))
        {
            BackToTheShip.Instance.O2Empty();
            //SceneManager.LoadScene("Shop");
        }
        // if(Input.GetKeyDown("z"))
        // {
        //     SceneManager.LoadScene("Glossar");
        // }
        // if(Input.GetKeyDown("u"))
        // {
        //     SceneManager.LoadScene("Menu");
        // }
        if(Input.GetKeyDown("e"))
        {
            TakeTreasureFromChest();
        }

        if(sceneName.Equals("Shop"))
        {
            this.gameObject.transform.position = Vector2.zero;
        }
        LookToMouse();
    }

    private void LookToMouse()
    {
        float difference = Camera.main.ScreenToWorldPoint(Input.mousePosition).x - this.transform.position.x;
        if(costumeMK+1 < costumes.Length)
        {
            if(difference > 0 && this.GetComponent<SpriteRenderer>().sprite != costumes[costumeMK])
            {
                this.GetComponent<SpriteRenderer>().sprite = costumes[costumeMK];
            }else if(difference <= 0 && this.GetComponent<SpriteRenderer>().sprite != costumes[costumeMK+1])
            {
                this.GetComponent<SpriteRenderer>().sprite = costumes[costumeMK+1];
            }
        }
    }

    private void TakeTreasureFromChest()
    {
        Collider2D[] chests = Physics2D.OverlapCircleAll(this.transform.position, areaToInteractWithObjects, chestMask);
        foreach(Collider2D chest in chests)
        {
            if(chest.GetComponent<Chest>() != null)
            {
                GlossarSave.Instance.ChestFound(chest.GetComponent<Chest>().chestName);
                
                chest.GetComponent<Chest>().TakeTreasureFromChest();
            }
        }
    }

    void OnDrawGizmos() // To draw the visualization for the programmer
    {
        Gizmos.DrawWireSphere(this.transform.position, areaToInteractWithObjects);
    }
}